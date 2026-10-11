import SwiftUI
import UIKit

private enum QuizFocus: Hashable {
    case answer(String)
    case hear
    case next
    case leave
}

struct QuizView: View {
    @EnvironmentObject private var model: AppViewModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @FocusState private var focus: QuizFocus?
    @State private var focusBeforeDialog: QuizFocus?

    var body: some View {
        Group {
            if let session = model.session, let question = session.currentQuestion {
                quizBody(session: session, question: question)
            } else {
                VStack(spacing: 24) {
                    Text("This adventure is not ready.")
                        .font(LDTheme.titleFont)
                    Button("Back to Home") { model.showHome() }
                        .buttonStyle(LDFocusButtonStyle(role: .primary))
                }
            }
        }
        .alert("Leave this adventure?", isPresented: $model.showLeaveConfirmation) {
            Button("Keep Playing", role: .cancel) { model.cancelLeave() }
            Button("Leave", role: .destructive) { model.confirmLeave() }
        } message: {
            Text("Stars from this unfinished adventure will not be saved.")
        }
        .onChange(of: model.showLeaveConfirmation) { _, isShown in
            if isShown {
                focusBeforeDialog = focus
            } else if let focusBeforeDialog {
                focus = focusBeforeDialog
            }
        }
        .onExitCommand { model.handleExitCommand() }
    }

    private func quizBody(session: QuizSession, question: Question) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            header(session)
            progressBar(session)
            HStack(alignment: .center, spacing: 40) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("What is this?")
                        .font(LDTheme.titleFont)
                        .foregroundStyle(LDTheme.ink)
                        .accessibilityIdentifier("questionTitle")
                    IllustrationCard(assetName: question.imageName, accessibilityLabel: "Mystery picture", hidesIdentity: true)
                        .padding(20)
                        .frame(maxWidth: 620, maxHeight: 500)
                        .background(RoundedRectangle(cornerRadius: 32, style: .continuous).fill(LDTheme.card))
                        .accessibilityIdentifier("mysteryPicture")
                }

                VStack(alignment: .leading, spacing: 16) {
                    VStack(spacing: 12) {
                        ForEach(question.choices, id: \.self) { choice in
                            answerButton(choice, question: question, session: session)
                        }
                    }
                    .focusSection()

                    feedback(session: session, question: question)
                        .frame(minHeight: 110, alignment: .topLeading)

                    HStack(spacing: 16) {
                        footerButton("Hear Question", image: "speaker.wave.2", focus: .hear, identifier: "hearQuestionButton") {
                            model.hearQuestion()
                        }
                        footerButton("Next Picture", image: "arrow.right", focus: .next, identifier: "nextPictureButton", enabled: session.canAdvance) {
                            model.nextPicture()
                        }
                        footerButton("Leave Adventure", image: "door.left.hand.open", focus: .leave, identifier: "leaveAdventureButton") {
                            model.requestLeave()
                        }
                    }
                    .focusSection()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 64)
        .padding(.vertical, 32)
        .defaultFocus($focus, .answer(question.choices.first ?? ""))
        .onAppear {
            DispatchQueue.main.async {
                focusFirstAnswer(in: question, session: session)
            }
        }
        .onChange(of: question.id) { _, _ in
            DispatchQueue.main.async {
                guard let current = model.session, let currentQuestion = current.currentQuestion else { return }
                focusFirstAnswer(in: currentQuestion, session: current)
            }
        }
        .onChange(of: model.outcome) { _, newOutcome in
            switch newOutcome {
            case .incorrect:
                let current = model.session ?? session
                DispatchQueue.main.async {
                    focusFirstAnswer(in: current.currentQuestion ?? question, session: current)
                }
                announce(model.feedbackText())
            case .correctFirstTry, .correctAfterRetry:
                DispatchQueue.main.async { focus = .next }
                announce(model.feedbackText())
            case .ignored, .none:
                break
            }
        }
    }

    private func header(_ session: QuizSession) -> some View {
        HStack {
            Text(session.topic.title)
                .font(LDTheme.subtitleFont)
                .foregroundStyle(LDTheme.tealDark)
            Spacer()
            Text("Picture \(session.pictureNumber) of \(session.questions.count)")
                .font(LDTheme.bodyFont)
                .accessibilityIdentifier("pictureProgress")
            Spacer()
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .foregroundStyle(LDTheme.gold)
                    .accessibilityHidden(true)
                Text("\(session.stars) of 5 first-try stars")
            }
            .font(LDTheme.bodyFont)
            .foregroundStyle(LDTheme.ink)
            .accessibilityIdentifier("starsLabel")
        }
    }

    private func progressBar(_ session: QuizSession) -> some View {
        HStack(spacing: 10) {
            ForEach(0..<session.questions.count, id: \.self) { item in
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(item < session.solvedPictureCount ? LDTheme.teal : LDTheme.ink.opacity(0.15))
                    .frame(height: 14)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress, \(session.solvedPictureCount) of \(session.questions.count) pictures solved")
    }

    private func answerButton(_ choice: String, question: Question, session: QuizSession) -> some View {
        let isWrong = session.wrongChoices.contains(choice)
        let isCorrectChoice = session.solved && choice == question.correctAnswer
        return Button {
            model.choose(choice)
        } label: {
            HStack(spacing: 16) {
                Text(choice)
                    .font(LDTheme.buttonFont)
                Spacer()
                if isCorrectChoice {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(LDTheme.success)
                    Text("Well done")
                        .font(LDTheme.captionFont)
                } else if isWrong {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(LDTheme.coral)
                    Text("Not this one")
                        .font(LDTheme.captionFont)
                }
            }
        }
        .buttonStyle(LDFocusButtonStyle(role: .secondary, fillsWidth: true))
        .focused($focus, equals: .answer(choice))
        .disabled(isWrong || session.solved)
        .accessibilityIdentifier("answer_\(choice)")
        .accessibilityHint(isWrong ? "Already tried" : "Answer choice")
    }

    @ViewBuilder
    private func feedback(session: QuizSession, question: Question) -> some View {
        if let text = model.feedbackText() {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: session.solved ? "checkmark.circle.fill" : "arrow.triangle.2.circlepath")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(session.solved ? LDTheme.success : LDTheme.coral)
                Text(text)
                    .font(LDTheme.bodyFont)
                    .foregroundStyle(LDTheme.ink)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .accessibilityIdentifier("feedbackText")
            .accessibilityElement(children: .combine)
            .animation(reduceMotion ? nil : .easeInOut(duration: 0.2), value: text)
        }
    }

    private func footerButton(
        _ title: String,
        image: String,
        focus target: QuizFocus,
        identifier: String,
        enabled: Bool = true,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: image)
                Text(title)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .font(LDTheme.buttonFont)
            .frame(minHeight: 36)
        }
        .buttonStyle(LDFocusButtonStyle(role: target == .next ? .primary : .secondary))
        .focused($focus, equals: target)
        .disabled(!enabled)
        .accessibilityIdentifier(identifier)
    }

    private func focusFirstAnswer(in question: Question, session: QuizSession) {
        if let choice = question.choices.first(where: { !session.wrongChoices.contains($0) && !session.solved }) {
            focus = .answer(choice)
        }
    }

    private func announce(_ message: String?) {
        guard let message else { return }
        UIAccessibility.post(notification: .announcement, argument: message)
    }
}
