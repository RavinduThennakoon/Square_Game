//
//  GameViewModel.swift
//  Square_Game
//
//  Created by COBSCCOMP242P-017 on 2026-01-26.
//

//

import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var cards: [Card] = []
    @Published var score = 0
    @Published var timeRemaining = 0
    @Published var gameOver = false
    @Published var gameWon = false
    
    let difficulty: Difficulty
    
    private var firstSelectedIndex: Int?
    private var timer: AnyCancellable?
    
    // NEW: Track if low time warning has been announced
    private var lowTimeWarningAnnounced = false
    
    // MARK: - Init
    init(difficulty: Difficulty) {
        self.difficulty = difficulty
        startGame()
    }
    
    // MARK: - Game Setup
    private func setupCards() {
        let colors: [Color] = [
            .red, .blue, .green, .yellow, .purple,
            .orange, .pink, .mint, .cyan, .indigo
        ]

        var pairs: [(Color, CardPattern)] = []

        // Build pairs combining color and a pattern for accessibility
        for i in 0..<difficulty.numberOfPairs {
            let color = colors[i % colors.count]
            let pattern = CardPattern.pattern(for: i)
            pairs.append((color, pattern))
            pairs.append((color, pattern))
        }

        // Shuffle and map into Card models
        pairs.shuffle()
        cards = pairs.map { (color, pattern) in
            Card(color: color, pattern: pattern)
        }
    }
    
    // MARK: - Game Setup Entry Point
     func startGame() {
        score = 0
        gameOver = false
        gameWon = false
        firstSelectedIndex = nil
        timeRemaining = difficulty.timeLimit
        lowTimeWarningAnnounced = false

        setupCards()
        startTimer()

        // Announce game start for accessibility
        AccessibilityHelper.announce("Game started. \(difficulty.accessibilityDescription)")
    }
    
    // MARK: - Timer
    private func startTimer() {
        timer?.cancel()
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                    
                    // NEW: Announce low time warning
                    if self.timeRemaining == 10 && !self.lowTimeWarningAnnounced {
                        AccessibilityHelper.announce("Warning: Only 10 seconds remaining", priority: .high)
                        self.lowTimeWarningAnnounced = true
                    }
                } else {
                    self.gameOver = true
                    self.timer?.cancel()
                    
                    // NEW: Announce game over
                    AccessibilityHelper.announce("Time's up! Game over. Your final score is \(self.score) out of \(self.difficulty.numberOfPairs) pairs", priority: .high)
                }
            }
    }
    
    // MARK: - Game Logic
    func cardTapped(at index: Int) {
        guard !cards[index].isFaceUp,
              !cards[index].isMatched,
              !gameOver else { return }
        
        cards[index].isFaceUp = true
        
        // NEW: Announce card reveal
        AccessibilityHelper.announce("Revealed \(cards[index].pattern.name) card")
        
        if let firstIndex = firstSelectedIndex {
            checkMatch(firstIndex, index)
        } else {
            firstSelectedIndex = index
        }
    }
    
    private func checkMatch(_ first: Int, _ second: Int) {
        if cards[first].color == cards[second].color {
            cards[first].isMatched = true
            cards[second].isMatched = true
            score += 1
            firstSelectedIndex = nil
            
            // NEW: Announce match
            AccessibilityHelper.announce("Match found! \(cards[first].pattern.name) cards matched. Score is now \(score)", priority: .medium)
            
            if score == difficulty.numberOfPairs {
                gameWon = true
                gameOver = true
                timer?.cancel()
                
                // NEW: Announce win
                AccessibilityHelper.announce("Congratulations! You won! All \(score) pairs matched with \(timeRemaining) seconds remaining", priority: .high)
            }
        } else {
            // NEW: Announce mismatch
            AccessibilityHelper.announce("No match. Cards will flip back")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.cards[first].isFaceUp = false
                self.cards[second].isFaceUp = false
                self.firstSelectedIndex = nil
            }
        }
    }
    
    // NEW: Get accessibility status for game
    func getGameStatusForAccessibility() -> String {
        let totalPairs = difficulty.numberOfPairs
        let remainingPairs = totalPairs - score
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        
        return "Score: \(score) out of \(totalPairs) pairs matched. \(remainingPairs) pairs remaining. Time: \(minutes) minutes and \(seconds) seconds"
    }
}

