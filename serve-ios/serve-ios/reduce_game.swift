//
//  ContentView.swift
//  serve-ios
//
//  Created by Kenzo on 14/7/25.
//

import SwiftUI

struct ScenarioCard: Identifiable {
    let id = UUID()
    let textLeft: String
    let textRight: String
    let correctIsLeft: Bool
}



struct ScenarioCardView: View {
    let card: ScenarioCard
    var onChoose: (Bool) -> Void
    
    var body: some View {
        HStack(spacing: 20) { // Fixed spacing that will scale naturally
            ChoiceView(text: card.textLeft, isLeft: true)
                .onTapGesture { onChoose(true) }
            
            ChoiceView(text: card.textRight, isLeft: false)
                .onTapGesture { onChoose(false) }
        }
        .padding()
        .frame(maxWidth: .infinity) // Ensure full width
    }
}

struct ChoiceView: View {
    let text: String
    let isLeft: Bool

    var body: some View {
        Text(text)
            .font(.system(size: 24, weight: .bold))
            .minimumScaleFactor(0.5)
            .lineLimit(3)
            .multilineTextAlignment(.center)
            .padding()
            .frame(maxWidth: .infinity, minHeight: 140) // Flexible dimensions
            .background(Color(isLeft ? .green : .blue).opacity(0.3))
            .cornerRadius(10)
            .animation(.easeInOut, value: text)
    }
}

func createGame() -> ReduceGame {
    let gameCards = [
        ScenarioCard(textLeft: "Shower for 5 minutes", textRight: "Shower for 1 hour!", correctIsLeft: true),
        ScenarioCard(textLeft: "Use both sides of the paper", textRight: "Draw only one line and throw away!", correctIsLeft: true),
        ScenarioCard(textLeft: "Keep lights on, I love light!", textRight: "Turn off the light when not using.", correctIsLeft: false),
        ScenarioCard(textLeft: "Throw away food if don't like", textRight: "Eat some of it and share with others", correctIsLeft: false),
        ScenarioCard(textLeft: "Bring your own bag", textRight: "Use plastic bags that harm the planet", correctIsLeft: true)
    ]
    return ReduceGame(cards: gameCards)
}

class ReduceGame: ObservableObject {
    @Published var cards: [ScenarioCard]
    @Published var currentIndex = 0
    @Published var score = 0

    init(cards: [ScenarioCard]) {
        self.cards = cards.shuffled()
    }

    func choose(isLeft: Bool) {
        guard let currentCard = currentCard else { return }
        
        if currentCard.correctIsLeft == isLeft {
            score += 1
        }
        currentIndex += 1
    }
    
    var currentCard: ScenarioCard? {
        guard currentIndex < cards.count else { return nil }
        return cards[currentIndex]
    }
    
    func reset() {
        currentIndex = 0
        cards = cards.shuffled()
        score = 0
    }
    
}

struct EndScreenView: View {
    let score: Int
    var resetAction: () -> Void
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle() // Acts as a perfect container
                    .fill(Color.green) // Fallback
                    .overlay(
                        Image("Green_Forest_1")
                            .resizable()
                            .scaledToFill()
                    )
                    .ignoresSafeArea()
                    .frame(width: geo.size.width, height: geo.size.height)
                VStack {
                    Text("Game Over")
                        .font(.system(size: geo.size.width * 0.097, weight: .black))
                        .foregroundStyle(.red)
                        .shadow(radius: 10)
                    
                    HStack {
                        Text("Score: \(score)")
                            .font(.system(size: geo.size.width * 0.0703, weight: .bold))
                        Image(systemName: "star.fill") // Filled star
                            .font(.system(size: geo.size.width * 0.0703))
                            .foregroundColor(.yellow)
                    }
                    Button(action: {
                        resetAction()
                    }) {
                        Text("Play Again")
                            .padding()
                            .foregroundStyle(.black)
                            .font(.system(size: geo.size.width * 0.0586, weight: .bold))
                    }
                    .foregroundStyle(.black)
                }
            }
        }
    
    }
}

struct GameView: View {
    @StateObject var game: ReduceGame
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle() // Acts as a perfect container
                    .fill(Color.green) // Fallback
                    .overlay(
                        Image("Green_Forest_1")
                            .resizable()
                            .scaledToFill()
                    )
                    .ignoresSafeArea()
                    .frame(width: geo.size.width, height: geo.size.height)
                VStack {
                    if let currentCard = game.currentCard {
                        ScenarioCardView(card: currentCard, onChoose: {choice in game.choose(isLeft: choice)})
                    } else {
                        EndScreenView(score: game.score, resetAction: {game.reset()})
                    }
                }
            }
        }
    }
}

struct GameMenuView: View {
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    Rectangle() // Acts as a perfect container
                        .fill(Color.green) // Fallback
                        .overlay(
                            Image("Green_Forest_1")
                                .resizable()
                                .scaledToFill()
                        )
                        .ignoresSafeArea()
                        .frame(width: geo.size.width, height: geo.size.height)
                    VStack() {
                        Text("Welcome to the Reduce Game!")
                            .padding(.top, geo.size.height * 0.097)
                            .foregroundStyle(.black)
                            .font(.system(size: geo.size.width * 0.0703, weight: .bold))
                            .frame(width: .infinity)
                        Spacer()
                        NavigationLink {
                            GameView(game: createGame())
                        } label: {
                            Text("Start game")
                                .padding()    // Green background
                                .foregroundStyle(.black)     // White text
                                .font(.system(size: geo.size.width * 0.0586, weight: .bold))
                        }
                        Spacer()
                    }
                    .padding(.bottom, geo.size.height * 0.097)
                }
            }
        }
    }
}

#Preview {
    //@Previewable @StateObject var game = createGame()
    //EndScreenView(score: 10, resetAction: {game.reset()})
    GameMenuView()
}

//
//  reduce_game.swift
//  serve-ios
//
//  Created by Nguyen Dylan on 15/7/25.
//

