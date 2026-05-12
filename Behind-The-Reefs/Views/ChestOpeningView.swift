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
        ZStack {
            // Chest
            Image(chestOpened ? "Behind_the_Reefs_TreasureChest-02" : "Behind_the_Reefs_TreasureChest-01")
                .resizable()
                .scaledToFit()
                .frame(width: 220)
        }
    }
    
}

struct NewGameAlertView_Previews: PreviewProvider {
    static var previews: some View {
        ChestOpeningView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
