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
        HStack(spacing: 20) {
            ChoiceView(text: card.textLeft, isLeft: true)
                .onTapGesture {
                    onChoose(true)
                }
            
            ChoiceView(text: card.textRight, isLeft: false)
                .onTapGesture {
                    onChoose(false)
                }
        }
        .padding()
    }
}
   

struct ChoiceView: View {
    let text: String
    let isLeft: Bool

    var body: some View {
        Text(text)
            .font(.largeTitle)
            .frame(width: 300, height: 140)
            .background(Color(isLeft ? .green : .blue).opacity(0.3))
            .cornerRadius(12)
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
        ZStack {
            Image("Green_Forest_1")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                Text("Game Over")
                    .font(.system(size: 100, weight: .black))
                    .foregroundStyle(.red)
                    .shadow(radius: 10)
                
                HStack {
                    Text("Score: \(score)")
                        .font(.system(size: 75, weight: .bold))
                    Image(systemName: "star.fill") // Filled star
                        .font(.system(size: 75))
                        .foregroundColor(.yellow)
                }
                Button(action: {
                    resetAction()
                }) {
                    Text("Play Again")
                        .padding()
                        .foregroundStyle(.black)
                        .font(.system(size: 60, weight: .bold))
                }
                .foregroundStyle(.black)
            }
        }
    
    }
}

struct GameView: View {
    @StateObject var game: ReduceGame
    var body: some View {
        ZStack {
            Image("Green_Forest_1")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
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

struct GameMenuView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Image("Green_Forest_1")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack() {
                    Text("Welcome to the Reduce Game!")
                        .padding(.top, 100)
                        .foregroundStyle(.black)
                        .font(.system(size: 75, weight: .bold))
                        .frame(width: 600)
                    Spacer()
                    NavigationLink {
                        GameView(game: createGame())
                    } label: {
                        Text("Start game")
                            .padding()    // Green background
                            .foregroundStyle(.black)     // White text
                            .font(.system(size: 60, weight: .bold))
                    }
                    Spacer()
                }
                .padding(.bottom, 100)
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

