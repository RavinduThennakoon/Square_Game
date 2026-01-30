//

import SwiftUI
import Combine

struct ContentView: View {
    
    @StateObject private var viewModel: GameViewModel
    let onQuit: () -> Void
    
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @AccessibilityFocusState private var isGameStatusFocused: Bool
    
    init(difficulty: Difficulty, onQuit: @escaping () -> Void) {
        _viewModel = StateObject(
            wrappedValue: GameViewModel(difficulty: difficulty)
        )
        self.onQuit = onQuit
    }
    
    var body: some View {
        VStack(spacing: 15) {
            
            // NEW: Game status summary for VoiceOver users
            Text(viewModel.getGameStatusForAccessibility())
                .accessibilityLabel("Game status")
                .accessibilityValue(viewModel.getGameStatusForAccessibility())
                .accessibilityAddTraits(.isHeader)
                .font(.caption)
                .foregroundColor(.clear)  // Hidden visually but available to VoiceOver
                .frame(height: 0)
                .accessibilityFocused($isGameStatusFocused)
            
            // Top bar
            HStack {
                Button(action: {
                    AccessibilityHelper.announce("Quitting game")
                    onQuit()
                }) {
                    Text("Quit")
                        .font(.headline)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.red.opacity(0.2))
                        .foregroundColor(.red)
                        .cornerRadius(8)
                }
                .accessibilityLabel("Quit game")
                .accessibilityHint("Return to the difficulty selection screen")
                .accessibilityAddTraits(.isButton)
                
                Spacer()
                
                // NEW: Better time display with accessibility
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Time")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(timeFormatted(viewModel.timeRemaining))
                        .font(.headline)
                        .foregroundColor(viewModel.timeRemaining <= 10 ? .red : .primary)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Time remaining")
                .accessibilityValue(timeAccessibilityValue(viewModel.timeRemaining))
                .accessibilityHint(viewModel.timeRemaining <= 10 ? "Hurry up, time is running out" : "")
            }
            .padding(.horizontal)
            
            // NEW: Better score display
            VStack(spacing: 2) {
                Text("Score")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(viewModel.score) / \(viewModel.difficulty.numberOfPairs)")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Score")
            .accessibilityValue("\(viewModel.score) out of \(viewModel.difficulty.numberOfPairs) pairs matched")
            
            // Game grid
            LazyVGrid(
                columns: Array(
                    repeating: GridItem(.flexible(), spacing: 8),
                    count: viewModel.difficulty.gridSize
                ),
                spacing: 8
            ) {
                ForEach(viewModel.cards.indices, id: \.self) { index in
                    CardView(card: viewModel.cards[index])
                        .onTapGesture {
                            viewModel.cardTapped(at: index)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel(viewModel.cards[index].accessibilityLabel)
                        .accessibilityHint(viewModel.cards[index].accessibilityHint)
                        .accessibilityAddTraits(.isButton)
                        .accessibilityIdentifier("card_\(index)")  // NEW: For UI testing
                }
            }
            .padding()
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Card grid")
            
            // Game over overlay
            if viewModel.gameOver {
                VStack(spacing: 20) {
                    Text(viewModel.gameWon ? "🎉 You Win! 🎉" : "⏰ Time's Up!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(viewModel.gameWon ? .green : .red)
                        .accessibilityLabel(viewModel.gameWon ? "You win!" : "Time's up!")
                        .accessibilityAddTraits(.isHeader)
                    
                    Text("Score: \(viewModel.score) / \(viewModel.difficulty.numberOfPairs)")
                        .font(.headline)
                        .accessibilityLabel("Final score: \(viewModel.score) out of \(viewModel.difficulty.numberOfPairs) pairs matched")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(uiColor: .systemBackground))
                        .shadow(radius: 10)
                )
                .padding()
                .accessibilityElement(children: .contain)
                .accessibilityAddTraits(.isModal)
            }
            
            // Restart button
            Button(action: {
                AccessibilityHelper.announce("Restarting game")
                viewModel.startGame()
            }) {
                Text("Restart")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .accessibilityLabel("Restart game")
            .accessibilityHint("Start a new game at the same difficulty level")
            .accessibilityAddTraits(.isButton)
        }
        .padding(.vertical)
        // NEW: Support Dynamic Type
        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
    }
    
    // MARK: - Helper Functions
    
    private func timeFormatted(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", minutes, secs)
    }
    
    private func timeAccessibilityValue(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        
        if minutes > 0 {
            return "\(minutes) minute\(minutes == 1 ? "" : "s") and \(secs) second\(secs == 1 ? "" : "s")"
        } else {
            return "\(secs) second\(secs == 1 ? "" : "s")"
        }
    }
}

// NEW: Preview
#Preview("Easy Game") {
    ContentView(difficulty: .easy) {
        print("Quit tapped")
    }
}
