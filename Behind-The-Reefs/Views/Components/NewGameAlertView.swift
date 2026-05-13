//
//  NewGameAlertView.swift
//  Behind-The-Reefs
//
//  Created by Bryan Samuel on 12/05/26.
//

import SwiftUI

struct NewGameAlertView: View {
    
    var body: some View {
        ZStack {
            // Overlay Gelap
            Color.black.opacity(0.4).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                Text("NEW GAME WARNING")
                    .font(.custom("Chewy-Regular",size: 28))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 2, x: 2, y: 2)
                    .padding(.top, 20)
                
                // Icon Warning
                ZStack {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 70, height: 70)
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                }
                .padding(.vertical, 15)
                
                // Body Text
                VStack(spacing: 10) {
                    Text("Are you sure want to start a new game? Past progress will be deleted!")
                        .font(.custom("Sniglet-Regular",size: 18))
                    
                    Text("Are you sure you want to proceed?")
                        .font(.custom("Sniglet-Regular",size: 16))
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 25)
                
                // Buttons
                HStack(spacing: 20) {
                    // NO
                    Button(action: {}) {
                        Text("NO, CANCEL")
                            .font(.custom("Chewy-Regular",size: 14))
                            .foregroundColor(.white)
                            .padding(.vertical, 19)
                            .padding(.horizontal, 20)
                            .background(
                                Capsule()
                                    .fill(Color.red)
                                    .overlay(Capsule().stroke(Color.white.opacity(0.8), lineWidth: 4))
                            )
                    }
                    // YES
                    Button(action: {}) {
                        Text("YES, START\nNEW GAME")
                            .font(.custom("Chewy-Regular",size: 14))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 40)
                            .background(
                                Capsule()
                                    .fill(Color.green)
                                    .overlay(Capsule().stroke(Color.white.opacity(0.8), lineWidth: 4))
                            )
                    }
                }
                .padding(.bottom, 30)
            }
            .frame(maxWidth: 500)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.brown)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white.opacity(0.5), lineWidth: 8)
                    )
            )
            .shadow(radius: 20)
            .padding(.horizontal, 50)
        }
    }
}

// Preview Landscape
struct NewGameAlertView_Previews: PreviewProvider {
    static var previews: some View {
        NewGameAlertView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}


