import AVFoundation
import Foundation

/// Speaks one utterance at a time. Playback uses the tvOS audio session so
/// short prompts can be heard while the app is in front. Speech stays on
/// device; Apple documents that speech generation is not sent to a server.
final class NarrationService: NSObject, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()
    private var queuedUtterance: AVSpeechUtterance?
    private var didConfigureSession = false

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        configureSessionIfNeeded()

        let utterance = AVSpeechUtterance(string: trimmed)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.9

        if synthesizer.isSpeaking {
            queuedUtterance = utterance
            synthesizer.stopSpeaking(at: .immediate)
        } else {
            synthesizer.speak(utterance)
        }
    }

    func stop() {
        queuedUtterance = nil
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        deactivateSession()
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            guard let queued = self.queuedUtterance else {
                self.deactivateSession()
                return
            }
            self.queuedUtterance = nil
            synthesizer.speak(queued)
        }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { [weak self] in
            guard let self, self.queuedUtterance == nil, !synthesizer.isSpeaking else { return }
            self.deactivateSession()
        }
    }

    private func configureSessionIfNeeded() {
        guard !didConfigureSession else { return }
        let session = AVAudioSession.sharedInstance()
        let mode: AVAudioSession.Mode = session.availableModes.contains(.voicePrompt) ? .voicePrompt : .default
        do {
            try session.setCategory(.playback, mode: mode)
            try session.setActive(true)
        } catch {
            try? session.setCategory(.playback, mode: .default)
            try? session.setActive(true)
        }
        didConfigureSession = true
    }

    private func deactivateSession() {
        guard didConfigureSession else { return }
        try? AVAudioSession.sharedInstance().setActive(false, options: [.notifyOthersOnDeactivation])
        didConfigureSession = false
    }
}
