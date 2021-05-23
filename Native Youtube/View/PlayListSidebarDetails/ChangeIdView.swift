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
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .cornerRadius(10)
               
                Button(action: {
                    if textVal.count > 2{
                        data.changeDefaultPlaylist(newPlaylistID: textVal)
                        textVal = ""
                    }
                }, label: {
                    Image(systemName: "square.and.arrow.down.fill")
                        .foregroundColor(.white)
                })
                .background(Color.blue.opacity(0.75).ignoresSafeArea(edges: .all))
                .cornerRadius(8)
                .shadow(color: .blue.opacity(0.5), radius: 5)
                .padding(5)
               
                Button(action: {
                    data.revertToDefault()
                    textVal = ""

                }, label: {
                    Image(systemName: "clock.arrow.circlepath")
                })
                .background(Color.green.opacity(0.75).ignoresSafeArea(edges: .all))
                .cornerRadius(8)
                .shadow(color: .green.opacity(0.5), radius: 5)
            }
        }
    }
}

extension NSTextField{
    open override var focusRingType: NSFocusRingType{
        get{.none}
        set{}
    }
}

struct ChangeIdView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeIdView()

    }
}
