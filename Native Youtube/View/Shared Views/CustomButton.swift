//
//  CustomButton.swift
//  Native Youtube
//
//  Created by Aayush Pokharel on 2021-05-23.
//

import SwiftUI

struct CustomButton: View {
    var image = ""
    var color = Color.blue
    
    @State var buttonHover: Bool = false
    var body: some View {
        HStack{
            Spacer()
            Image(systemName: image)
//                .font(.title3.bold())
                .foregroundColor(buttonHover ? .white : color)
//                .frame(width: 5, height: 5, alignment: .center)
            Spacer()
        }
        .padding(.vertical, 5)
        .overlay(RoundedRectangle(cornerRadius: 5)
                    .stroke(color, lineWidth: 3))
        .background(buttonHover ? color : color.opacity(0))
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .shadow(color: buttonHover ? color.opacity(0.5) : color.opacity(0), radius: 5)
        .offset(x: 0, y: 5)
        .onHover(perform: {_ in
            withAnimation {
                buttonHover.toggle()
            }
        })

    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(image: "magnifyingglass", color: .blue)
    }
}
