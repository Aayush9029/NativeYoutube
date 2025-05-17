//
//  GlowEffect.swift
//  AppleIntelligenceGlowEffectKit
//
//  Created by Adam Różyński on 23/04/2025.
//

import SwiftUI

public struct GlowEffect: View {
    @State private var offset: Int = 0
    private var gradientStops: [Gradient.Stop] {
        generateGradientStops(offset: offset)
    }

    private var timer = Timer.publish(every: 0.4, on: .main, in: .common).autoconnect()
    var lineWidth: CGFloat
    var cornerRadius: CGFloat
    var blurRadius: CGFloat

    public init(lineWidth: CGFloat, cornerRadius: CGFloat, blurRadius: CGFloat) {
        self.lineWidth = lineWidth
        self.cornerRadius = cornerRadius
        self.blurRadius = blurRadius
    }

    public var body: some View {
        ZStack {
            BlurredGradientLine(gradientStops: gradientStops, lineWidth: lineWidth / 3, cornerRadius: cornerRadius, blurRadius: blurRadius / 3)
            BlurredGradientLine(gradientStops: gradientStops, lineWidth: lineWidth / 2, cornerRadius: cornerRadius, blurRadius: blurRadius / 2)
            BlurredGradientLine(gradientStops: gradientStops, lineWidth: lineWidth, cornerRadius: cornerRadius, blurRadius: blurRadius)
            BlurredGradientLine(gradientStops: gradientStops, lineWidth: lineWidth, cornerRadius: cornerRadius, blurRadius: blurRadius)
        }
        .onReceive(timer) { _ in
            withAnimation(.linear(duration: 0.6)) {
                offset += 1
            }
        }
    }
}

struct BlurredGradientLine: View {
    let gradientStops: [Gradient.Stop]
    let lineWidth: CGFloat
    let cornerRadius: CGFloat
    let blurRadius: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(
                    AngularGradient(
                        gradient: Gradient(stops: gradientStops),
                        center: .center
                    ),
                    lineWidth: lineWidth
                )
                .blur(radius: blurRadius)
        }
    }
}

private let baseColors: [Color] = [
    Color(hex: "BC82F3"),
    Color(hex: "F5B9EA"),
    Color(hex: "8D9FFF"),
    Color(hex: "FF6778"),
    Color(hex: "FFBA71"),
    Color(hex: "C686FF")
]

func generateGradientStops(offset: Int) -> [Gradient.Stop] {
    let count = baseColors.count
    return (0..<count).map { i in
        let color    = baseColors[abs(i - offset) % count]     
        let location = Double(i) / Double(count)
        return Gradient.Stop(color: color, location: location)
    }
}


#Preview("GlowEffect") {
    GlowEffect(lineWidth: 4, cornerRadius: 10, blurRadius: 4)
        .frame(width: 80, height: 80)
}


