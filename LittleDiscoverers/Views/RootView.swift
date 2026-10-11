import SwiftUI

struct RootView: View {
    @StateObject private var model = AppViewModel()

    var body: some View {
        ZStack {
            LDTheme.cream.ignoresSafeArea()
            switch model.route {
            case .home:
                HomeView()
            case .topics:
                TopicSelectionView()
            case .howToPlay:
                HowToPlayView()
            case .grownUps:
                GrownUpsView()
            case .quiz:
                QuizView()
            case .results:
                ResultsView()
            }
        }
        .environmentObject(model)
    }
}
