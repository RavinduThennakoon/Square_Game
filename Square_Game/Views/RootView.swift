//
//  RootView.swift
//  Square_Game
//
//  Created by COBSCCOMP242P-017 on 2026-01-26.
//
import SwiftUI

struct RootView: View {
    
    @State private var selectedDifficulty: Difficulty? = nil
    
    var body: some View {
        if let difficulty = selectedDifficulty {
            ContentView(
                difficulty: difficulty,
                onQuit: {
                    selectedDifficulty = nil
                }
            )
        } else {
            StartView(selectedDifficulty: $selectedDifficulty)
        }
    }
}


