import SwiftUI

private enum HomeFocus: Hashable {
    case explore
    case howToPlay
    case grownUps
}

struct HomeView: View {
    @EnvironmentObject private var model: AppViewModel
    @FocusState private var focus: HomeFocus?

    private let samples: [(String, String)] = [
        (IllustrationAsset.animalCat.rawValue, "Cat"),
        (IllustrationAsset.fruitApple.rawValue, "Apple"),
        (IllustrationAsset.vehicleCar.rawValue, "Car")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Little Discoverers")
                    .font(LDTheme.displayFont)
                    .foregroundStyle(LDTheme.ink)
                Text("Look. Choose. Discover.")
                    .font(LDTheme.subtitleFont)
                    .foregroundStyle(LDTheme.teal)
            }
            .accessibilityElement(children: .combine)

            HStack(spacing: 28) {
                ForEach(samples, id: \.0) { sample in
                    IllustrationCard(assetName: sample.0, accessibilityLabel: sample.1)
                        .padding(18)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(RoundedRectangle(cornerRadius: 28, style: .continuous).fill(LDTheme.card))
                }
            }
            .frame(height: 320)

            if let problem = model.contentProblem {
                ContentErrorBanner(problem: problem)
            }

            HStack(spacing: 24) {
                actionButton("Let's Explore", image: "sparkles", focus: .explore, identifier: "letsExploreButton", disabled: !model.canStartQuiz) {
                    model.showTopics()
                }
                actionButton("How to Play", image: "questionmark.circle", focus: .howToPlay, identifier: "howToPlayButton") {
                    model.showHowToPlay()
                }
                actionButton("For Grown-ups", image: "person.2", focus: .grownUps, identifier: "grownUpsButton") {
                    model.showGrownUps()
                }
            }
        }
        .padding(.horizontal, 70)
        .padding(.vertical, 40)
        .defaultFocus($focus, .explore)
        .onAppear { focus = model.canStartQuiz ? .explore : .howToPlay }
    }

    private func actionButton(
        _ title: String,
        image: String,
        focus target: HomeFocus,
        identifier: String,
        disabled: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: image)
                Text(title)
            }
            .font(LDTheme.buttonFont)
            .frame(minWidth: 320, minHeight: 44)
        }
        .buttonStyle(LDFocusButtonStyle(role: .primary))
        .focused($focus, equals: target)
        .disabled(disabled)
        .accessibilityIdentifier(identifier)
    }
}
