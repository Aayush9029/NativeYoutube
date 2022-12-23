//
//  ThinBackground.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2022-12-23.
//

import SwiftUI

struct ThinRoundedBackground: ViewModifier {
    let padding: CGFloat
    let radius: CGFloat
    let material: Material

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(material)
            .cornerRadius(radius)
    }
}

extension View {
    func thinRoundedBG(padding: CGFloat = 12, radius: CGFloat = 6, material: Material = .ultraThinMaterial) -> ModifiedContent<Self, ThinRoundedBackground> {
        return modifier(ThinRoundedBackground(padding: padding, radius: radius, material: material))
    }
}
