import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
    @State private var isHovering = false
    let backgroundColor: Color
    let foregroundColor: Color

    public init(backgroundColor: Color = .black, foregroundColor: Color = .white) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor.opacity(0.75))
                    .shadow(
                        color: backgroundColor.opacity(0.5),
                        radius: configuration.isPressed ? 2 : 12,
                        y: configuration.isPressed ? 4 : 12
                    )

                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor.opacity(0.5))
            }
            .font(.headline)
            .foregroundStyle(foregroundColor)
            .shadow(
                color: foregroundColor.opacity(isHovering ? 0.125 : 0),
                radius: isHovering ? 2 : 0
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isHovering = hovering
                }
            }
    }
}

public struct PrimaryButton: View {
    let text: String
    let systemImage: String?
    let action: () -> Void
    let backgroundColor: Color
    let foregroundColor: Color

    public init(
        _ text: String,
        systemImage: String? = nil,
        backgroundColor: Color = .black,
        foregroundColor: Color = .white,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.systemImage = systemImage
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let systemImage = systemImage {
                    Image(systemName: systemImage)
                        .fontWeight(.medium)
                }
                Text(text)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
        }
        .buttonStyle(PrimaryButtonStyle(backgroundColor: backgroundColor, foregroundColor: foregroundColor))
    }
}

#Preview {
    VStack(spacing: 20) {
        PrimaryButton(
            "Default Button",
            action: { print("Default button tapped") }
        )
        
        PrimaryButton(
            "With Icon",
            systemImage: "play.fill",
            action: { print("Play button tapped") }
        )
        
        PrimaryButton(
            "Custom Colors",
            systemImage: "gear",
            backgroundColor: .blue,
            foregroundColor: .white,
            action: { print("Settings button tapped") }
        )
        
        PrimaryButton(
            "Red Button",
            systemImage: "trash",
            backgroundColor: .red,
            foregroundColor: .white,
            action: { print("Delete button tapped") }
        )
    }
    .padding()
}