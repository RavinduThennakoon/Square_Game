//
//  CardView.swift
//  Square_Game
//
//  Created by COBSCCOMP242P-017 on 2026-01-26.
//
//

import SwiftUI

struct CardView: View {
    
    let card: Card
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(card.isFaceUp || card.isMatched ? card.color : Color.gray)
                .frame(minWidth: 44, minHeight: 44)  // NEW: Ensure minimum touch target size
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black.opacity(0.2), lineWidth: 2)
                )
            
            // NEW: Show pattern symbol when card is face up or matched
            if card.isFaceUp || card.isMatched {
                Image(systemName: card.pattern.systemImage)
                    .resizable()
                    .scaledToFit()
                    .padding(8)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                    .accessibilityHidden(true)  // Hide from VoiceOver since card label describes it
            }
        }
        .animation(reduceMotion ? .none : .easeInOut, value: card.isFaceUp)  // NEW: Respect reduce motion
        // NEW: Comprehensive accessibility
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(card.accessibilityLabel)
        .accessibilityHint(card.accessibilityHint)
        .accessibilityAddTraits(card.isMatched ? [.isButton, .isSelected] : .isButton)
        .accessibilityRemoveTraits(card.isMatched ? .isButton : [])
    }
}

// NEW: Preview with accessibility testing
#Preview("Face Down Card") {
    CardView(card: Card(color: .blue, pattern: .circle, isFaceUp: false, isMatched: false))
        .frame(width: 100, height: 100)
        .padding()
}

#Preview("Face Up Card") {
    CardView(card: Card(color: .red, pattern: .star, isFaceUp: true, isMatched: false))
        .frame(width: 100, height: 100)
        .padding()
}

#Preview("Matched Card") {
    CardView(card: Card(color: .green, pattern: .heart, isFaceUp: true, isMatched: true))
        .frame(width: 100, height: 100)
        .padding()
}
