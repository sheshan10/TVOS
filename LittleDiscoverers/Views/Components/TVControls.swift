import SwiftUI

struct LDFocusButtonStyle: ButtonStyle {
    var role: LDButtonRole = .primary
    var fillsWidth = false

    @Environment(\.isFocused) private var isFocused
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        let shape = RoundedRectangle(cornerRadius: role == .card ? 28 : 22, style: .continuous)
        configuration.label
            .foregroundStyle(foreground)
            .padding(.horizontal, role == .card ? 24 : 28)
            .padding(.vertical, role == .card ? 22 : 16)
            .frame(maxWidth: fillsWidth ? .infinity : nil, alignment: .leading)
            .background(background)
            .clipShape(shape)
            .overlay(shape.strokeBorder(borderColor, lineWidth: isFocused ? 7 : (role == .secondary ? 3 : 0)))
            .scaleEffect(isFocused && isEnabled && !reduceMotion ? 1.05 : 1)
            .opacity(isEnabled ? 1 : 0.42)
            .animation(reduceMotion ? nil : .easeInOut(duration: 0.16), value: isFocused)
    }

    private var foreground: Color {
        switch role {
        case .primary:
            return .white
        case .secondary, .card:
            return LDTheme.ink
        }
    }

    private var background: Color {
        if isFocused && role != .primary {
            return LDTheme.mist
        }
        switch role {
        case .primary:
            return isFocused ? LDTheme.tealDark : LDTheme.teal
        case .secondary, .card:
            return LDTheme.card
        }
    }

    private var borderColor: Color {
        if isFocused { return LDTheme.teal }
        return role == .secondary ? LDTheme.teal.opacity(0.35) : .clear
    }
}

struct IllustrationCard: View {
    let assetName: String
    var accessibilityLabel: String
    var hidesIdentity = false

    var body: some View {
        Image(assetName)
            .resizable()
            .scaledToFit()
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(hidesIdentity ? "Mystery picture" : accessibilityLabel)
            .accessibilityHint(hidesIdentity ? "Look at the picture, then choose its name." : "")
    }
}

struct ContentErrorBanner: View {
    let problem: ContentProblem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("The adventures cannot start yet.")
                .font(LDTheme.subtitleFont)
                .foregroundStyle(LDTheme.ink)
            Text(problem.summary)
                .font(LDTheme.captionFont)
                .foregroundStyle(LDTheme.ink)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(Color.white))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(LDTheme.coral, lineWidth: 4)
        )
        .accessibilityElement(children: .combine)
    }
}
