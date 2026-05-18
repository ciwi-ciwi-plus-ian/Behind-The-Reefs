//
//  CreditsView.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import SwiftUI

struct CreditsView: View {
    
    var body: some View {
        
        ZStack {
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                    } label: {
                        Image("exitButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .padding(35)
                            .padding(.trailing,-20)
                    }
                }
                Spacer()

                Text("Made with dedication by Behind the Reef team")
                    .font(Font.custom("Chewy-Regular", size: 10))
                    .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                    
                Text("© 2026 Behind the Reef. All rights reserved.")
                    .font(Font.custom("Chewy-Regular", size: 10))
                    .padding(.bottom, -15)
                    .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
            }
            
            ZStack {
                VStack {
                    Spacer()
                    // Box Kayu
                        .frame(width: 500, height: 350)
                        .background(
                            Image("frame")
                                .resizable()
                                .scaledToFit()
                                .padding(.top,25)
                        )
                    
                }
                ZStack {
                    //Tulisan Credits Detail
                    VStack {
                        Text("Behind The Reef")
                            .font(Font.custom("Chewy-Regular", size: 40))
                            .foregroundColor(Color.white)
                            .padding (.bottom,-20)
                            .padding(.top,15)
                        
                        Text("CREDITS")
                            .font(Font.custom("Chewy-Regular", size: 20))
                            .foregroundColor(Color.white)
                        
                        //Devider line
                        Rectangle()
                            .fill(Color.white.opacity(0.8))
                            .frame(width:400, height:3)
                            .padding(.horizontal, 40)
                            .padding(.top,-10)
                        
                        HStack {
                            Text("Project Manager")
                                .font(Font.custom("Chewy-Regular", size: 20))
                                .foregroundColor(Color.white)
                                .padding(.trailing,130)
                            Text("Ivana Grasielda")
                                .font(Font.custom("Chewy-Regular", size: 20))
                                .foregroundColor(Color.white)
                        }
                        .padding(.top,-10)
                        
                        HStack{
                            Text("Programmer 1")
                                .font(Font.custom("Chewy-Regular", size: 20))
                                .foregroundColor(Color.white)
                                .padding(.trailing,173)
                            Text("Bryan Samuel")
                                .font(Font.custom("Chewy-Regular", size: 20))
                                .foregroundColor(Color.white)
                        }
                        
                        HStack{
                            Text("Programmer 2")
                                .font(Font.custom("Chewy-Regular", size: 20))
                                .foregroundColor(Color.white)
                                .padding(.trailing,168)
                            Text("Ivone Liwang")
                                .font(Font.custom("Chewy-Regular", size: 20))
                                .foregroundColor(Color.white)
                        }
                        
                        HStack{
                            Text("Programmer 3")
                                .font(Font.custom("Chewy-Regular", size: 20))
                                .foregroundColor(Color.white)
                                .padding(.trailing,160)
                                .padding(.leading,-7)
                            Text("Hana Azizah N.")
                                .font(Font.custom("Chewy-Regular", size: 20))
                                .foregroundColor(Color.white)
                                .padding(.trailing,-10)
                        }
                        
                        HStack{
                            Text("Art & Design")
                                .font(Font.custom("Chewy-Regular", size: 20))
                                .foregroundColor(Color.white)
                                .padding(.trailing,145)
                                .padding(.leading,-7)
                            Text("Angely Georgina J.")
                                .font(Font.custom("Chewy-Regular", size: 20))
                                .foregroundColor(Color.white)
                                .padding(.trailing,-10)
                            
                        }
                        
                        .padding (.bottom,10)
                        Text("Special Thanks to Our Mentor")
                            .font(Font.custom("Chewy-Regular", size: 15))
                            .foregroundColor(Color.white)
                            .padding(.bottom,-12)
                        
                        Text("Amelia Alexandra")
                            .font(Font.custom("Chewy-Regular", size: 20))
                            .foregroundColor(Color.white)
            
                    }
                }
            }
        }
    }
}
#Preview(traits: .landscapeRight) {
    CreditsView()
}
