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
            // Background
            Image("mainMenuBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
                ZStack {
                    // Box Kayu
                    Image("frame")
                        .resizable()
                        .scaledToFit()
                        .padding(.top,40)
                    
                    ZStack {
                        VStack {
                            Text("Behind The Reef")
                                .font(Font.custom("Chewy-Regular", size: 40))
                                .foregroundColor(Color.white)
                            
                            Text("CREDITS")
                                .font(Font.custom("Chewy-Regular", size: 20))
                                .foregroundColor(Color.white)
                                
                            //Devider line
                            Rectangle()
                                .fill(Color.white.opacity(0.8))
                                .frame(width:350, height:3)
                                .padding(.horizontal, 40)
                            
                            HStack{
                                Text("Project Manager")
                                    .font(Font.custom("Chewy-Regular", size: 20))
                                    .foregroundColor(Color.white)
                                    .padding(.trailing,150)
                                Text("Ivana Grasielda")
                                    .font(Font.custom("Chewy-Regular", size: 20))
                                    .foregroundColor(Color.white)
                            }
                            
                            HStack{
                                Text("Programmer 1")
                                    .font(Font.custom("Chewy-Regular", size: 20))
                                    .foregroundColor(Color.white)
                                    .padding(.trailing,185)
                                Text("Bryan Samuel")
                                    .font(Font.custom("Chewy-Regular", size: 20))
                                    .foregroundColor(Color.white)
                            }
                            
                            HStack{
                                Text("Programmer 2")
                                    .font(Font.custom("Chewy-Regular", size: 20))
                                    .foregroundColor(Color.white)
                                    .padding(.trailing,185)
                                Text("Ivone Liwang")
                                    .font(Font.custom("Chewy-Regular", size: 20))
                                    .foregroundColor(Color.white)
                            }
                            
                            HStack{
                                Text("Programmer 3")
                                    .font(Font.custom("Chewy-Regular", size: 20))
                                    .foregroundColor(Color.white)
                                    .padding(.trailing,180)
                                Text("Hana A")
                                    .font(Font.custom("Chewy-Regular", size: 20))
                                    .foregroundColor(Color.white)
                            }
                            
                            HStack{
                                Text("Art & Design")
                                    .font(Font.custom("Chewy-Regular", size: 20))
                                    .foregroundColor(Color.white)
                                    .padding(.trailing,185)
                                Text("Angely Georgina J.")
                                    .font(Font.custom("Chewy-Regular", size: 20))
                                    .foregroundColor(Color.white)
                            }
                            
                        }
                    }
                }
            }
        }
    }
#Preview(traits: .landscapeRight) {
    CreditsView()
}
