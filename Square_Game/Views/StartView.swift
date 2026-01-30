//
//  StartView.swift
//  Square_Game
//
//  Created by COBSCCOMP242P-017 on 2026-01-26.
//
import SwiftUI

struct StartView: View {
    
    @Binding var selectedDifficulty: Difficulty?
    
    var body: some View {
        VStack(spacing: 30) {
            
            Text("Color Matching Game ")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Button("Easy (3 × 3)") {
                selectedDifficulty = .easy
            }
            
            Button("Medium (5 × 5)") {
                selectedDifficulty = .medium
            }
            
            Button("Hard (7 × 7)") {
                selectedDifficulty = .hard
            }
        }
        .buttonStyle(.borderedProminent)
        .padding()
    }
}
