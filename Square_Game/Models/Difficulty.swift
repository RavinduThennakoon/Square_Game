//
//  Difficulty.swift
//  Square_Game
//
//  Created by COBSCCOMP242P-017 on 2026-01-26.
//
enum Difficulty {
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
}
