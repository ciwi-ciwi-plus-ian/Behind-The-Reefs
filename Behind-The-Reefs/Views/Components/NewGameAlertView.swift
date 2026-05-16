//
//  NewGameAlertView.swift
//  Behind-The-Reefs
//
//  Created by Bryan Samuel on 12/05/26.
//

// NewGameAlertView.swift
import SwiftUI

struct NewGameAlertView: View {
    
    var onDismiss: (() -> Void)?
    
    var body: some View {
        ZStack {
            // Black overlay
            Color.black.opacity(0.4).ignoresSafeArea()
            
            // The Alert Container
            ZStack {

                VStack(spacing: 0) {
                    // Header
                    Text("Start Again?")
                        .font(.custom("Chewy-Regular", size: 32))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 2, y: 2)
                        .padding(.top, 10)
                    
                    // Divider
                    Rectangle()
                        .fill(Color.white.opacity(0.8))
                        .frame(height: 4)
                        .padding(.horizontal, 60)
                        .overlay(
                            Rectangle()
                                .fill(Color.black.opacity(0.25))
                                .frame(height: 1)
                                .offset(y: 2)
                                .padding(.horizontal, 60)
                        )
                        .padding(.vertical, 20)
                    
                    // Body Text
                    VStack(spacing: 8) {
                        Text("Are you sure want to start a new game? Past progress will be deleted!")
                            .font(.custom("Sniglet-Regular", size: 18))
                            .foregroundColor(.white)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 15)
                    
                    // Buttons
                    HStack(spacing: 15) {
                        // NO
                        Button{
                            onDismiss?()
                        } label :{
                            Image("noCancel")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 35)
                        }
                        
                        // YES
                        Button(action: {onDismiss?()}) {
                            Image("yesNewGame")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 35)
                        }
                    }
                    .padding(.bottom, 15)
                }

            }
            .padding(20)
            .frame(width: 500, height: 300)
            .background(
                Image("frame")
                    .resizable()
                    .scaledToFit()
            )
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .shadow(radius: 10)
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


