import SwiftUI

private enum HelpFocus: Hashable {
    case explore
    case home
}

struct HowToPlayView: View {
    @EnvironmentObject private var model: AppViewModel
    @FocusState private var focus: HelpFocus?

    private let steps: [(String, String)] = [
        ("1", "Choose Animals, Fruits, or Vehicles."),
        ("2", "Move with the ring or swipe on the Siri Remote."),
        ("3", "Press the clickpad to choose an answer."),
        ("4", "A wrong choice turns off. You can try another answer."),
        ("5", "After the right answer, move to Next Picture and press the clickpad."),
        ("6", "A star is earned only when the first answer is correct."),
        ("7", "Menu during a quiz asks before leaving. An unfinished adventure is not saved.")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            Text("How to Play")
                .font(LDTheme.displayFont)
                .foregroundStyle(LDTheme.ink)

            HStack(alignment: .top, spacing: 28) {
                VStack(alignment: .leading, spacing: 14) {
                    ForEach(steps.prefix(4), id: \.0) { step in
                        stepRow(step)
                    }
                }
                VStack(alignment: .leading, spacing: 14) {
                    ForEach(steps.suffix(3), id: \.0) { step in
                        stepRow(step)
                    }
                }
            }

            HStack(spacing: 20) {
                Button("Let's Explore") { model.showTopics() }
                    .buttonStyle(LDFocusButtonStyle(role: .primary))
                    .focused($focus, equals: .explore)
                    .disabled(!model.canStartQuiz)
                    .accessibilityIdentifier("letsExploreButton")
                Button("Back to Home") { model.showHome() }
                    .buttonStyle(LDFocusButtonStyle(role: .secondary))
                    .focused($focus, equals: .home)
                    .accessibilityIdentifier("backHomeButton")
            }
        }
        .padding(.horizontal, 80)
        .padding(.vertical, 44)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .defaultFocus($focus, .explore)
        .onAppear { focus = model.canStartQuiz ? .explore : .home }
        .onExitCommand { model.handleExitCommand() }
    }

    private func stepRow(_ step: (String, String)) -> some View {
        HStack(alignment: .top, spacing: 16) {
            Text(step.0)
                .font(LDTheme.titleFont)
                .foregroundStyle(LDTheme.teal)
                .frame(width: 48, alignment: .leading)
            Text(step.1)
                .font(LDTheme.bodyFont)
                .foregroundStyle(LDTheme.ink)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(LDTheme.card))
        .accessibilityElement(children: .combine)
    }
}
