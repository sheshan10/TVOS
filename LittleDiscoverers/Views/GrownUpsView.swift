import SwiftUI

private enum GrownUpsFocus: Hashable {
    case narration
    case reset
    case back
}

struct GrownUpsView: View {
    @EnvironmentObject private var model: AppViewModel
    @FocusState private var focus: GrownUpsFocus?

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("For Grown-ups")
                        .font(LDTheme.displayFont)
                        .foregroundStyle(LDTheme.ink)
                    Text("Progress stays on this Apple TV.")
                        .font(LDTheme.bodyFont)
                        .foregroundStyle(LDTheme.tealDark)
                }
                Spacer()
                Button("Back to Home") { model.showHome() }
                    .buttonStyle(LDFocusButtonStyle(role: .secondary))
                    .focused($focus, equals: .back)
                    .accessibilityIdentifier("backHomeButton")
            }

            HStack(spacing: 18) {
                ForEach(TopicID.allCases) { topic in
                    topicSummary(topic)
                }
            }

            HStack(alignment: .top, spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Toggle(isOn: narrationBinding) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Read questions aloud")
                                .font(LDTheme.buttonFont)
                            Text(model.narrationEnabled ? "Narration is on" : "Narration is off")
                                .font(LDTheme.captionFont)
                        }
                    }
                    .focused($focus, equals: .narration)
                    .accessibilityIdentifier("narrationToggle")

                    Button("Reset Saved Progress") { model.requestReset() }
                        .buttonStyle(LDFocusButtonStyle(role: .secondary))
                        .focused($focus, equals: .reset)
                        .accessibilityIdentifier("resetProgressButton")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(24)
                .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(LDTheme.card))

                Text(explanation)
                    .font(LDTheme.captionFont)
                    .foregroundStyle(LDTheme.ink)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(24)
                    .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(LDTheme.card))
            }
        }
        .padding(.horizontal, 64)
        .padding(.vertical, 36)
        .defaultFocus($focus, .narration)
        .onAppear { focus = .narration }
        .onExitCommand { model.handleExitCommand() }
        .alert("Reset saved progress?", isPresented: $model.showResetConfirmation) {
            Button("Cancel", role: .cancel) { model.cancelReset() }
            Button("Reset Progress", role: .destructive) { model.confirmReset() }
        } message: {
            Text("Best scores, finished adventures, explored pictures, and dates will be cleared on this Apple TV. The narration setting stays as it is.")
        }
    }

    private var narrationBinding: Binding<Bool> {
        Binding(
            get: { model.narrationEnabled },
            set: { model.narrationEnabled = $0 }
        )
    }

    private func topicSummary(_ topic: TopicID) -> some View {
        let item = model.progress.progress(for: topic)
        let dateText = item.lastCompletionDate.map(Self.dateText) ?? "Not yet"
        return VStack(alignment: .leading, spacing: 8) {
            Text(topic.title)
                .font(LDTheme.subtitleFont)
            Text("Best: \(item.bestFirstTryScore) of 5")
            Text("Finished adventures: \(item.completedSessionCount)")
            Text("Pictures explored: \(item.exploredCount) of 5")
            Text("Last finished: \(dateText)")
        }
        .font(LDTheme.captionFont)
        .foregroundStyle(LDTheme.ink)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(LDTheme.card))
        .accessibilityElement(children: .combine)
    }

    private var explanation: String {
        """
        A star is saved only when the first answer is correct. A later correct answer still finishes the picture, but it does not earn a star. The best score is the highest first-try total. Each finished adventure is counted once. Leaving early is not saved.

        Records stay on this Apple TV in UserDefaults: scores, picture IDs, dates, and the narration setting. That suits this small Part B prototype. It is not an advanced Part A storage design.

        The game is visual. Narration reads the question and choices, and VoiceOver can name controls, but there is no fully nonvisual learning mode yet. VoiceOver was not tested on Apple TV hardware.
        """
    }

    private static func dateText(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
