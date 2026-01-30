//
//  Difficulty.swift
//  Square_Game
//
//  Created by COBSCCOMP242P-017 on 2026-01-26.
//
enum Difficulty: CaseIterable {
    case easy, medium, hard
    
    var gridSize: Int {
        switch self {
        case .easy: return 3
        case .medium: return 5
        case .hard: return 7
        }
    }
    
    var timeLimit: Int {
        switch self {
        case .easy: return 60
        case .medium: return 120
        case .hard: return 180
        }
    }
    
    var numberOfPairs: Int {
        switch self {
        case .easy: return 4
        case .medium: return 12
        case .hard: return 24
        }
    }
    
    
    // NEW: Accessibility support
    var displayName: String {
        switch self {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
    }
    
    var accessibilityLabel: String {
        switch self {
        case .easy: return "Easy level"
        case .medium: return "Medium level"
        case .hard: return "Hard level"
        }
    }
    
    var accessibilityDescription: String {
        switch self {
        case .easy:
            return "3 by 3 grid, 4 pairs to match, 60 seconds time limit"
        case .medium:
            return "5 by 5 grid, 12 pairs to match, 120 seconds time limit"
        case .hard:
            return "7 by 7 grid, 24 pairs to match, 180 seconds time limit"
        }
    }
    
    var accessibilityHint: String {
        "Double tap to start game at this difficulty level"
    }
}
