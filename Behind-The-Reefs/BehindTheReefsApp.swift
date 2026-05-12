//
//  BehindTheReefsApp.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import SwiftUI

@main
struct BehindTheReefsApp: App {
    var body: some Scene {
        WindowGroup {
            NewGameAlertView(bodyText: "Are you sure want to start a new game? Past progress will be deleted!")
        }
    }
}
