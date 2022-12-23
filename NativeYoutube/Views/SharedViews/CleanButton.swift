//
//  CleanButton.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI

struct CleanButton: View {
    let page: Pages
    let image: String
    @Binding var binded: Pages

    var body: some View {
        Button {
            withAnimation {
                binded = page
            }
        } label: {
            Group {
                Label(page.rawValue, systemImage: image)
                    .labelStyle(.iconOnly)
                    .font(.callout)
                    .foregroundColor(binded == page ? .red : .gray)
            }
            .padding(6)
            .background(.ultraThinMaterial)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        binded == page ? .red : .gray,
                        lineWidth: binded == page ? 2 : 0.5
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
