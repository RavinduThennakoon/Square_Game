//
//  Square_GameApp.swift
//  Square_Game
//
//  Created by COBSCCOMP242P-017 on 2026-01-23.
//

import SwiftUI
import FirebaseCore

@main
struct Square_GameApp: App {
    init() {
           FirebaseApp.configure()
       }
    var body: some Scene {
        WindowGroup {
           RootView()
        }
    }
}
