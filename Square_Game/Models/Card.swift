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
    let pattern: CardPattern
    var isFaceUp = false
    var isMatched = false
    
    
       // NEW: Accessibility support
       var accessibilityLabel: String {
           if isMatched {
               return "Matched \(pattern.name) card"
           } else if isFaceUp {
               return "\(pattern.name) card, face up"
           } else {
               return "Face down card"
           }
       }
       
       var accessibilityHint: String {
           if isMatched {
               return "This card has been matched"
           } else if isFaceUp {
               return "This card is currently showing"
           } else {
               return "Double tap to reveal this card"
           }
       }
   }

   // NEW: Enum for card patterns to support color-blind users
   enum CardPattern: CaseIterable {
       case circle, square, triangle, star, heart, diamond, cross, hexagon, pentagon, oval
       
       var name: String {
           switch self {
           case .circle: return "Circle"
           case .square: return "Square"
           case .triangle: return "Triangle"
           case .star: return "Star"
           case .heart: return "Heart"
           case .diamond: return "Diamond"
           case .cross: return "Cross"
           case .hexagon: return "Hexagon"
           case .pentagon: return "Pentagon"
           case .oval: return "Oval"
           }
       }
       
       var systemImage: String {
           switch self {
           case .circle: return "circle.fill"
           case .square: return "square.fill"
           case .triangle: return "triangle.fill"
           case .star: return "star.fill"
           case .heart: return "heart.fill"
           case .diamond: return "diamond.fill"
           case .cross: return "plus"
           case .hexagon: return "hexagon.fill"
           case .pentagon: return "pentagon.fill"
           case .oval: return "oval.fill"
           }
       }
       
       static func pattern(for index: Int) -> CardPattern {
           CardPattern.allCases[index % CardPattern.allCases.count]
       }
   }
