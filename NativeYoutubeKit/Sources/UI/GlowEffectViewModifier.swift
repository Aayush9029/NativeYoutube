//
//  GlowEffectViewModifier.swift
//  AppleIntelligenceGlowEffectUI
//
//  Created by Adam Różyński on 27/04/2025.
//

import SwiftUI

public struct GlowEffectViewModifier: ViewModifier {
    var lineWidth: CGFloat
    var cornerRadius: CGFloat
    var blurRadius: CGFloat

    public init(lineWidth: CGFloat, cornerRadius: CGFloat, blurRadius: CGFloat) {
        self.lineWidth = lineWidth
        self.cornerRadius = cornerRadius
        self.blurRadius = blurRadius
    }

    public func body(content: Content) -> some View {
        GeometryReader { proxy in
            ZStack {
                GlowEffect(lineWidth: lineWidth, cornerRadius: cornerRadius, blurRadius: blurRadius)
                    .frame(width: proxy.size.width + lineWidth, height: proxy.size.height + lineWidth)
                content
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }
    }
}

public extension View {
    func glowEffect(lineWidth: CGFloat = 4, cornerRadius: CGFloat = 8, blurRadius: CGFloat = 8) -> some View {
        modifier(GlowEffectViewModifier(lineWidth: lineWidth, cornerRadius: cornerRadius, blurRadius: blurRadius))
    }
}
