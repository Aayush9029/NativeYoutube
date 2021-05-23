//
//  ChangeIdView.swift
//  Native Youtube
//
//  Created by Aayush Pokharel on 2021-05-15.
//

import SwiftUI

struct ChangeIdView: View {
    @AppStorage("playlistID") var savedID: String = "PLFgquLnL59alKyN8i_z5Ofm_h0KthT072"
    @EnvironmentObject var data: YTData
    
    @State var textVal = ""
    
    var body: some View {
        VStack {
            HStack{
                
                TextField("Playlist ID", text: $textVal)
                    .textFieldStyle(PlainTextFieldStyle())
                    .underlineTextField(color: .red)
                
                CustomButton(image: "square.and.arrow.down.fill", color: .blue)
                    .frame(width: 40, height: 40)
                    .onTapGesture {
                        if textVal.count > 2{
                            data.changeDefaultPlaylist(newPlaylistID: textVal)
                            textVal = ""
                        }
                }
                
                CustomButton(image: "clock.arrow.circlepath", color: .green)
                    .frame(width: 40, height: 40)
                    .padding(10)
                    .onTapGesture {
                        data.revertToDefault()
                        textVal = ""
                }
            }
        }
    }
}


struct ChangeIdView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeIdView()
        
    }
}
