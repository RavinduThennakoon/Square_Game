//
//  GameViewModel.swift
//  Square_Game
//
//  Created by COBSCCOMP242P-017 on 2026-01-26.
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
    
    // MARK: - Init
    init(difficulty: Difficulty) {
        self.difficulty = difficulty
        startGame()
    }
    
    // MARK: - Game Setup
    func startGame() {
        score = 0
        gameOver = false
        gameWon = false
        firstSelectedIndex = nil
        timeRemaining = difficulty.timeLimit
        
        setupCards()
        startTimer()
    }
    
    private func setupCards() {
        let colors: [Color] = [
            .red, .blue, .green, .yellow, .purple,
            .orange, .pink, .mint, .cyan, .indigo
        ]
        
        var gameColors: [Color] = []
        
        for i in 0..<difficulty.numberOfPairs {
            let color = colors[i % colors.count]
            gameColors.append(contentsOf: [color, color])
        }
        
        // odd card
        gameColors.append(.gray)
        gameColors.shuffle()
        
        cards = gameColors.map { Card(color: $0) }
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
                } else {
                    self.gameOver = true
                    self.timer?.cancel()
                }
            }
    }
    
    // MARK: - Game Logic
    func cardTapped(at index: Int) {
        guard !cards[index].isFaceUp,
              !cards[index].isMatched,
              !gameOver else { return }
        
        cards[index].isFaceUp = true
        
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
            
            if score == difficulty.numberOfPairs {
                gameWon = true
                gameOver = true
                timer?.cancel()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.cards[first].isFaceUp = false
                self.cards[second].isFaceUp = false
                self.firstSelectedIndex = nil
            }
        }
    }
}
