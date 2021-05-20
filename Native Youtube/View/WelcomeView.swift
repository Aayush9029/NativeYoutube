//
//  WelcomeView.swift
//  Native Youtube
//
//  Created by Aayush Pokharel on 2021-05-20.
//

import SwiftUI

struct WelcomeView: View {
    @AppStorage("firstlaunch") var firstTime = true

    var body: some View {
        VStack{
            HStack{
                VStack (alignment: .leading){
            Text("Hello")
                .font(.largeTitle.bold())
            Text("Thanks for using \"Native Youtube?\"")
                }
                Spacer()
            }
            .padding()
            .padding(.bottom)
            VStack{
                
                Text("Btw If you have an iPhone i'd highly recommend you check out").font(.title3.bold())
                Link(destination: URL(string: "https://aayush9029.github.io/RifiApp/")!, label: {
                    HStack{
                        Text("RiFi")
                            .font(.largeTitle.bold())
                }
                    .frame(width: 100, height: 100, alignment: .center)
                    .foregroundColor(.blue)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .white, radius: 10)
                    .padding()
         
            })  .padding()


                
                Link(destination: URL(string: "https://aayush9029.github.io/RifiApp/")!, label: {
                    HStack{
                        Text("Open Webpage")
                        Image(systemName: "arrow.right")
                    }
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.black)
                    .cornerRadius(10)
                    .padding()
                })
                            
                
                    
                    Link(destination: URL(string: "https://youtu.be/W_vOo5uqqj8")!, label: {
                        HStack{
                            Text("Watch Demo")
                        }
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding()
                    })
                
                Button(action: {
                    firstTime = false
                }, label: {
                    Text("I already did")
                        
                }).padding()
                
                Spacer()
                Text("RiFi is a native wireless media controller and gamepad for MacOS Devices.")
                    .padding()
                Text("It lets you control media playback using Camera Vison and Ai, and works well with Mac.")
                    .padding()
        }
            

        }.frame(width: 900, height: 720)
        .padding()
        .background(Color.blue.edgesIgnoringSafeArea(.all))
        .cornerRadius(5)

    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
