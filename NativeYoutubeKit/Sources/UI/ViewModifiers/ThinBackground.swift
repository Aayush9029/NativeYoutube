import SwiftUI

public struct ThinRoundedBackground: ViewModifier {
    let padding: CGFloat
    let radius: CGFloat
    let material: Material
    
    public func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(material)
            .cornerRadius(radius)
    }
}

public extension View {
    func thinRoundedBG(padding: CGFloat = 12, radius: CGFloat = 6, material: Material = .ultraThinMaterial) -> ModifiedContent<Self, ThinRoundedBackground> {
        return modifier(ThinRoundedBackground(padding: padding, radius: radius, material: material))
    }
}