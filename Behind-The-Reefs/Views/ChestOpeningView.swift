//
//  ChestOpeningView.swift
//  Behind-The-Reefs
//
//  Created by Bryan Samuel on 12/05/26.
//

import SwiftUI

struct ChestOpeningView: View {
    
    @State private var chestOpened = false
    
    var body: some View {
        VStack {
            // Chest
            Image(chestOpened ? "Behind_the_Reefs_TreasureChest-02" : "Behind_the_Reefs_TreasureChest-01")
                .resizable()
                .scaledToFit()
                .frame(width: 400)
            
            // Keys
            HStack(spacing: 14) {
                
                ForEach(0..<5, id: \.self) { index in
                    
                    Image("Behind_the_Reefs_Keys-0\(index + 1)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                    
                    
                }
            }.padding(.bottom,30)
            
            
        }
    }
    
}

struct NewGameAlertView_Previews: PreviewProvider {
    static var previews: some View {
        ChestOpeningView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
