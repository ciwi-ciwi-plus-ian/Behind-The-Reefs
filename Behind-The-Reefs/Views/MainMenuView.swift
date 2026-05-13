//
//  MainMenuView.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import SwiftUI

struct MainMenuView: View {
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                // Background
                Image("mainMenuBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    Spacer()
                    
                    // Title
                    Text("Behind The Reefs")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // Continue Button
//                    NavigationLink(destination: ContinueView()) {
                        Text("Continue")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 220, height: 60)
                            .background(Color.blue)
                            .cornerRadius(30)
//                    }
                    
                    // New Game Button
//                    NavigationLink(destination: NewGameView()) {
                        Text("New Game")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 220, height: 60)
                            .background(Color.blue)
                            .cornerRadius(30)
//                    }
                    
                    // Credits Button
//                    NavigationLink(destination: CreditsView()) {
                        Text("Credits")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 180, height: 50)
                            .background(Color.gray)
                            .cornerRadius(25)
//                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview(traits:.landscapeRight) {
    MainMenuView()
}
