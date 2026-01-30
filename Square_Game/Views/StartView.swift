//
//  StartView.swift
//  Square_Game
//
//  Created by COBSCCOMP242P-017 on 2026-01-26.
//
//

import SwiftUI

struct StartView: View {
    
    @Binding var selectedDifficulty: Difficulty?
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var body: some View {
        VStack(spacing: 40) {
            
            // Title
            VStack(spacing: 10) {
                Text("Color Matching Game")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityLabel("Color Matching Game")
                
                Text("Match all pairs before time runs out!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .accessibilityLabel("Match all pairs before time runs out")
            }
            .padding(.horizontal)
            
            // Difficulty selection
            VStack(spacing: 20) {
                Text("Select Difficulty")
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)
                
                ForEach(Difficulty.allCases, id: \.self) { difficulty in
                    DifficultyButton(difficulty: difficulty) {
                        AccessibilityHelper.announce("\(difficulty.displayName) level selected. Starting game")
                        selectedDifficulty = difficulty
                    }
                }
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Difficulty selection")
            
            // NEW: Instructions (collapsible for accessibility)
            DisclosureGroup("How to Play") {
                VStack(alignment: .leading, spacing: 12) {
                    InstructionRow(
                        icon: "hand.tap.fill",
                        text: "Tap cards to reveal their colors"
                    )
                    InstructionRow(
                        icon: "checkmark.circle.fill",
                        text: "Match two cards of the same color"
                    )
                    InstructionRow(
                        icon: "clock.fill",
                        text: "Complete all pairs before time runs out"
                    )
                    InstructionRow(
                        icon: "star.fill",
                        text: "Cards also have unique symbols for accessibility"
                    )
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(12)
            }
            .padding(.horizontal)
            .accessibilityElement(children: .contain)
        }
        .padding()
        // NEW: Support Dynamic Type
        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
    }
}

// NEW: Custom difficulty button with comprehensive accessibility
struct DifficultyButton: View {
    let difficulty: Difficulty
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(difficulty.displayName)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Image(systemName: iconForDifficulty(difficulty))
                        .font(.title2)
                }
                
                Text("\(difficulty.gridSize)×\(difficulty.gridSize) grid")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("\(difficulty.numberOfPairs) pairs • \(difficulty.timeLimit)s")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(backgroundColorForDifficulty(difficulty))
            .foregroundColor(.white)
            .cornerRadius(16)
            .shadow(radius: 4)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(difficulty.accessibilityLabel)
        .accessibilityValue(difficulty.accessibilityDescription)
        .accessibilityHint(difficulty.accessibilityHint)
        .accessibilityAddTraits(.isButton)
    }
    
    private func iconForDifficulty(_ difficulty: Difficulty) -> String {
        switch difficulty {
        case .easy: return "leaf.fill"
        case .medium: return "flame.fill"
        case .hard: return "bolt.fill"
        }
    }
    
    private func backgroundColorForDifficulty(_ difficulty: Difficulty) -> Color {
        switch difficulty {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }
}

// NEW: Instruction row component
struct InstructionRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
                .accessibilityHidden(true)
            
            Text(text)
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(text)
    }
}

// NEW: Preview
#Preview {
    StartView(selectedDifficulty: .constant(nil))
}
