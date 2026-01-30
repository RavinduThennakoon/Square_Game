//
//  Card.swift
//  Square_Game
//
//  Created by COBSCCOMP242P-017 on 2026-01-26.
//

import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let color: Color
    var isFaceUp = false
    var isMatched = false
}
