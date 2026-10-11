import Combine
import Foundation

@MainActor
final class AppViewModel: ObservableObject {
    @Published private(set) var route: AppRoute = .home
    @Published private(set) var session: QuizSession?
    @Published private(set) var outcome: QuizSession.SelectionResult?
    @Published private(set) var progress: SavedProgress
    @Published private(set) var contentProblem: ContentProblem?
    @Published var showLeaveConfirmation = false
    @Published var showResetConfirmation = false
    @Published var narrationReminder: String?

    private let bank: QuestionBank?
    private let progressStore: ProgressStore
    private let narration: NarrationService
    private let fixedOrder: Bool
    private let now: () -> Date
    private var lastExitAt = Date.distantPast

    var narrationEnabled: Bool {
        get { progress.narrationEnabled }
        set {
            progress.narrationEnabled = newValue
            progressStore.save(progress)
            if !newValue {
                narration.stop()
            }
        }
    }

    var canStartQuiz: Bool {
        bank != nil && contentProblem == nil
    }

    init(
        content: Result<QuestionBank, ContentProblem>,
        progressStore: ProgressStore,
        narration: NarrationService,
        fixedOrder: Bool,
        silenceNarration: Bool = false,
        now: @escaping () -> Date = Date.init
    ) {
        self.progressStore = progressStore
        self.narration = narration
        self.fixedOrder = fixedOrder
        self.now = now
        switch content {
        case .success(let bank):
            self.bank = bank
            self.contentProblem = nil
        case .failure(let problem):
            self.bank = nil
            self.contentProblem = problem
        }
        var loaded = progressStore.load()
        if silenceNarration {
            loaded.narrationEnabled = false
            progressStore.save(loaded)
        }
        self.progress = loaded
    }

    convenience init() {
        let testing = ProcessInfo.processInfo.arguments.contains("-UITesting")
        let defaults: UserDefaults
        if testing, let suite = UserDefaults(suiteName: "littlediscoverers.uitesting") {
            suite.removePersistentDomain(forName: "littlediscoverers.uitesting")
            defaults = suite
        } else {
            defaults = .standard
        }
        self.init(
            content: QuestionBankLoader.loadBundled(),
            progressStore: ProgressStore(defaults: defaults),
            narration: NarrationService(),
            fixedOrder: testing,
            silenceNarration: testing
        )
    }

    func showHome() {
        narration.stop()
        route = .home
    }

    func showTopics() {
        narration.stop()
        route = .topics
    }

    func showHowToPlay() {
        narration.stop()
        route = .howToPlay
    }

    func showGrownUps() {
        narration.stop()
        route = .grownUps
    }

    func startQuiz(topic: TopicID) {
        guard let bank else { return }
        let questions = bank.questions(for: topic, shuffle: !fixedOrder)
        guard questions.count == QuestionBankLoader.questionsPerTopic else { return }
        narration.stop()
        session = QuizSession(topic: topic, questions: questions)
        outcome = nil
        narrationReminder = nil
        showLeaveConfirmation = false
        route = .quiz
        speakCurrentQuestion()
    }

    func choose(_ choice: String) {
        guard var current = session else { return }
        let result = current.select(choice)
        session = current
        guard result != .ignored else { return }
        outcome = result
        narrationReminder = nil
        switch result {
        case .incorrect:
            speak(NarrationScript.retry())
        case .correctFirstTry, .correctAfterRetry:
            if let question = current.currentQuestion {
                speak(NarrationScript.success(question))
            }
        case .ignored:
            break
        }
    }

    func nextPicture() {
        guard var current = session else { return }
        let result = current.advance()
        session = current
        guard result != .blocked else { return }
        outcome = nil
        narrationReminder = nil
        switch result {
        case .finished:
            commitIfNeeded()
            narration.stop()
            route = .results
        case .nextQuestion:
            speakCurrentQuestion()
        case .blocked:
            break
        }
    }

    func hearQuestion() {
        guard narrationEnabled else {
            narrationReminder = "Narration is turned off. A grown-up can turn it on in For Grown-ups."
            return
        }
        narrationReminder = nil
        speakCurrentQuestion()
    }

    func handleExitCommand() {
        let moment = Date()
        guard moment.timeIntervalSince(lastExitAt) > 0.4 else { return }
        lastExitAt = moment
        if showLeaveConfirmation {
            cancelLeave()
            return
        }
        if showResetConfirmation {
            cancelReset()
            return
        }
        if route == .quiz, let session, !session.completed {
            showLeaveConfirmation = true
            return
        }
        if route != .home {
            showHome()
        }
    }

    func cancelLeave() {
        showLeaveConfirmation = false
    }

    func confirmLeave() {
        showLeaveConfirmation = false
        narration.stop()
        session = nil
        outcome = nil
        narrationReminder = nil
        route = .topics
    }

    func playAgain() {
        guard let topic = session?.topic else { return }
        startQuiz(topic: topic)
    }

    func requestReset() {
        showResetConfirmation = true
    }

    func cancelReset() {
        showResetConfirmation = false
    }

    func confirmReset() {
        showResetConfirmation = false
        progress = progressStore.resetKeepingNarration()
    }

    func bestScore(for topic: TopicID) -> Int {
        progress.progress(for: topic).bestFirstTryScore
    }

    func feedbackText() -> String? {
        if let narrationReminder {
            return narrationReminder
        }
        guard let outcome, let question = session?.currentQuestion else { return nil }
        switch outcome {
        case .incorrect:
            return "Good try! Choose another answer."
        case .correctFirstTry:
            return "Well done! \(question.fact)"
        case .correctAfterRetry:
            return "Well done! \(question.fact)"
        case .ignored:
            return nil
        }
    }

    func requestLeave() {
        guard route == .quiz, let session, !session.completed else { return }
        showLeaveConfirmation = true
    }

    private func commitIfNeeded() {
        guard var current = session, current.completed, !current.resultCommitted else { return }
        var updated = progress
        updated.recordCompletion(
            topic: current.topic,
            stars: current.stars,
            pictureIDs: current.questions.map(\.id),
            date: now()
        )
        guard progressStore.save(updated) else { return }
        progress = updated
        current.markResultCommitted()
        session = current
    }

    private func speakCurrentQuestion() {
        guard let question = session?.currentQuestion else { return }
        speak(NarrationScript.question(question))
    }

    private func speak(_ text: String) {
        guard narrationEnabled else {
            narration.stop()
            return
        }
        narration.speak(text)
    }
}

enum AppRoute: Equatable {
    case home
    case topics
    case howToPlay
    case grownUps
    case quiz
    case results
}
