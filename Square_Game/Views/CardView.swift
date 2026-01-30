//
//  CardView.swift
//  Square_Game
//
//  Created by COBSCCOMP242P-017 on 2026-01-26.
//
import SwiftUI

struct CardView: View {
    
    let card: Card
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(card.isFaceUp || card.isMatched ? card.color : .gray)
                .frame(height: 90)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.black.opacity(0.2))
                )
        }
        .animation(.easeInOut, value: card.isFaceUp)
    }
}
