import SwiftUI

private enum TopicFocus: Hashable {
    case topic(TopicID)
    case back
}

struct TopicSelectionView: View {
    @EnvironmentObject private var model: AppViewModel
    @FocusState private var focus: TopicFocus?

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            HStack(alignment: .firstTextBaseline) {
                Text("Choose a Topic")
                    .font(LDTheme.displayFont)
                    .foregroundStyle(LDTheme.ink)
                Spacer()
                backButton
            }

            if let problem = model.contentProblem {
                ContentErrorBanner(problem: problem)
            }

            HStack(spacing: 28) {
                ForEach(TopicID.allCases) { topic in
                    topicCard(topic)
                }
            }
            .focusSection()
        }
        .padding(.horizontal, 70)
        .padding(.vertical, 40)
        .defaultFocus($focus, .topic(.animals))
        .onAppear { focus = model.canStartQuiz ? .topic(.animals) : .back }
        .onExitCommand { model.handleExitCommand() }
    }

    private var backButton: some View {
        Button("Back to Home") { model.showHome() }
            .buttonStyle(LDFocusButtonStyle(role: .secondary))
            .focused($focus, equals: .back)
            .accessibilityIdentifier("backHomeButton")
    }

    private func topicCard(_ topic: TopicID) -> some View {
        let best = model.bestScore(for: topic)
        let bestText = best == 0 ? "No score yet" : "Best: \(best) of 5 stars"
        return Button {
            model.startQuiz(topic: topic)
        } label: {
            VStack(alignment: .leading, spacing: 16) {
                IllustrationCard(assetName: topic.sampleImageName, accessibilityLabel: topic.title)
                    .frame(height: 250)
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(LDTheme.cream))
                Text(topic.title)
                    .font(LDTheme.titleFont)
                Text(topic.summary)
                    .font(LDTheme.bodyFont)
                    .fixedSize(horizontal: false, vertical: true)
                Text(bestText)
                    .font(LDTheme.captionFont)
                    .foregroundStyle(LDTheme.tealDark)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .buttonStyle(LDFocusButtonStyle(role: .card, fillsWidth: true))
        .focused($focus, equals: .topic(topic))
        .disabled(!model.canStartQuiz)
        .accessibilityIdentifier("topic_\(topic.rawValue)")
        .accessibilityLabel("\(topic.title). \(topic.summary). \(bestText)")
    }
}
