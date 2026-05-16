//
//  MainMenuView.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.

import SwiftUI

struct MainMenuView: View {
    
    @Environment(NavigationRouter.self) private var router
    
    var body: some View {
        
        GeometryReader { geometry in
            
            let w = geometry.size.width
            let h = geometry.size.height
            
            ZStack {
                
                // Background
                Image("mainMenuBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: h * 0.02) { // ← spacing POSITIF, kecil
                    
                    // Title
                    Image("title")
                        .resizable()
                        .scaledToFit()
                        .frame(width: w * 0.5) // ← width saja, NO height
                        .padding(.leading, w * -0.10)
                        .padding(.top, h * 0.07)
                        .padding(.bottom, h * 0.03)
                    
                    // Button Group
                    VStack(spacing: h * -0.05) {
                        
                        // Continue Button
                        Button {
                            // navigasi ke main menu — akan diisi saat routing siap
                        } label: {
                            Image("continueButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: w * 0.30)
                                .padding(.top, h * -0.10)
                        }
                        
                        // New Game Button
                        Button {
                            // navigasi ke main menu — akan diisi saat routing siap
                        } label: {
                            Image("newGameButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: w * 0.30)
                                .padding(.top, h * -0.10)
                        }
                        
                        // Credits Button
                        Button {
                            // navigasi ke main menu — akan diisi saat routing siap
                        } label: {
                            Image("creditsButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: w * 0.30)
                                .padding(.top, h * -0.10)
                        }
                    }
                    .padding(.leading, w * -0.10)
                    .padding(.bottom, h * -0.07)
                }
                .frame(width: w, height: h)
            }
        }
    }
}

#Preview(traits: .landscapeRight) {
    MainMenuView()
        .environment(NavigationRouter())
}
