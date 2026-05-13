//
//  MainMenuView.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import SwiftUI

struct MainMenuView: View {
    
    var body: some View {
        
        ZStack {
            
            // Background
            Image("mainMenuBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                
                // Title
                Image("title")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 374)
                    .padding(.top, 34)
                
                // Button Group
                VStack (spacing: 9) {
                    
                    // Continue Button
                    Image("continueButton")
                        .resizable()
                        .scaledToFit()
//                        .frame(width: 178, height: 42)
                    
                    // New Game Button
                    Image("newGameButton")
                        .resizable()
                        .scaledToFit()
//                        .frame(width: 140, height: 60)
                    
                    // Credits Button
                    Image("creditsButton")
                        .resizable()
                        .scaledToFit()
//                        .frame(width: 90, height: 36)
                }
                .padding(.top,11.65)
            }
        }
    }
}

#Preview(traits: .landscapeRight) {
    MainMenuView()
}
