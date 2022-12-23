//
//  CleanButton.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI

struct CleanButton: View {
    let title: String
    let image: String
    let isCurrent: Bool

    var body: some View {
        Group {
            Label(title, systemImage: image)
                .labelStyle(.iconOnly)
                .font(.callout)
                .foregroundColor(isCurrent ? .red : .gray)
        }
        .padding(6)
        .background(.ultraThinMaterial)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isCurrent ? .red : .gray, lineWidth: isCurrent ? 2 : 0.5)
        )
    }
}

struct SmallButtonView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            CleanButton(title: "questions", image: "questionmark", isCurrent: false)
            CleanButton(title: "questions", image: "questionmark", isCurrent: true)
        }
        .padding()
    }
}
