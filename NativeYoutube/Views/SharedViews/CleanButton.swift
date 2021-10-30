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
        Group{
            Label(title, systemImage: image)
                .labelStyle(.iconOnly)
                .font(.callout)
                .foregroundColor(isCurrent ? .red : .gray)
                
        }
        .padding(6)
        .background(.ultraThinMaterial)
        .cornerRadius(8)
        .shadow(color: isCurrent ? .red : .clear, radius: 2, x: 0, y: 0)

        
    }
}

struct SmallButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CleanButton(title: "questions", image: "questionmark", isCurrent: false)
            .padding()
    }
}
