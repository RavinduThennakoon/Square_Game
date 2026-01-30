import SwiftUI
import Combine


struct ContentView: View {
    
    @StateObject private var viewModel: GameViewModel
    let onQuit: () -> Void
    
    init(difficulty: Difficulty, onQuit: @escaping () -> Void) {
        _viewModel = StateObject(
            wrappedValue: GameViewModel(difficulty: difficulty)
        )
        self.onQuit = onQuit
    }
    
    var body: some View {
        VStack(spacing: 15) {
            
            // Top bar
            HStack {
                Button("Quit") {
                    onQuit()
                }
                .foregroundColor(.red)
                
                Spacer()
                
                Text("Time: \(viewModel.timeRemaining)")
                    .foregroundColor(viewModel.timeRemaining <= 10 ? .red : .primary)
            }
            .font(.headline)
            .padding(.horizontal)
            
            Text("Score: \(viewModel.score)")
                .font(.headline)
            
            LazyVGrid(
                columns: Array(
                    repeating: GridItem(.flexible()),
                    count: viewModel.difficulty.gridSize
                )
            ) {
                ForEach(viewModel.cards.indices, id: \.self) { index in
                    CardView(card: viewModel.cards[index])
                        .onTapGesture {
                            viewModel.cardTapped(at: index)
                        }
                }
            }
            .padding()
            
            if viewModel.gameOver {
                Text(viewModel.gameWon ? "🎉 You Win!" : "⏰ Time’s Up!")
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            Button("Restart") {
                viewModel.startGame()
            }
        }
    }
}

