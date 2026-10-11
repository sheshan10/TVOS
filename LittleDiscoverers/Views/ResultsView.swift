import SwiftUI

private enum ResultsFocus: Hashable {
    case playAgain
    case topics
    case home
}

struct ResultsView: View {
    @EnvironmentObject private var model: AppViewModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @FocusState private var focus: ResultsFocus?
    @State private var revealedStars = 0

    var body: some View {
        Group {
            if let session = model.session, session.completed {
                content(session)
            } else {
                VStack(spacing: 24) {
                    Text("There is no finished adventure to show.")
                        .font(LDTheme.titleFont)
                    Button("Back to Home") { model.showHome() }
                        .buttonStyle(LDFocusButtonStyle(role: .primary))
                }
            }
        }
        .onExitCommand { model.handleExitCommand() }
    }

    private func content(_ session: QuizSession) -> some View {
        let best = model.bestScore(for: session.topic)
        return VStack(alignment: .leading, spacing: 28) {
            Text("Wonderful exploring!")
                .font(LDTheme.displayFont)
                .foregroundStyle(LDTheme.ink)
            Text(session.topic.title)
                .font(LDTheme.subtitleFont)
                .foregroundStyle(LDTheme.teal)

            HStack(spacing: 16) {
                ForEach(0..<5, id: \.self) { item in
                    Image(systemName: item < revealedStars ? "star.fill" : "star")
                        .font(.system(size: 64))
                        .foregroundStyle(item < revealedStars ? LDTheme.gold : LDTheme.ink.opacity(0.35))
                        .accessibilityHidden(true)
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("\(session.stars) of 5 first-try stars")

            VStack(alignment: .leading, spacing: 10) {
                Text("This adventure: \(session.stars) of 5 first-try stars")
                    .font(LDTheme.titleFont)
                Text("Best score: \(best) of 5")
                    .font(LDTheme.subtitleFont)
                    .foregroundStyle(LDTheme.tealDark)
                Text(session.encouragement)
                    .font(LDTheme.bodyFont)
                    .fixedSize(horizontal: false, vertical: true)
            }

            HStack(spacing: 20) {
                resultButton("Play Again", focus: .playAgain, identifier: "playAgainButton", primary: true) {
                    model.playAgain()
                }
                resultButton("Choose a Topic", focus: .topics, identifier: "chooseTopicButton", primary: false) {
                    model.showTopics()
                }
                resultButton("Back to Home", focus: .home, identifier: "backHomeButton", primary: false) {
                    model.showHome()
                }
            }
        }
        .padding(.horizontal, 80)
        .padding(.vertical, 48)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .defaultFocus($focus, .playAgain)
        .onAppear {
            focus = .playAgain
            revealStars(session.stars)
        }
    }

    private func resultButton(
        _ title: String,
        focus target: ResultsFocus,
        identifier: String,
        primary: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(title, action: action)
            .buttonStyle(LDFocusButtonStyle(role: primary ? .primary : .secondary))
            .focused($focus, equals: target)
            .accessibilityIdentifier(identifier)
    }

    private func revealStars(_ stars: Int) {
        if reduceMotion || stars == 0 {
            revealedStars = stars
            return
        }
        revealedStars = 0
        for step in 1...stars {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(step) * 0.12) {
                revealedStars = step
            }
        }
    }
}
