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
    let imageLeft: String
    let imageRight: String
}

struct FeedbackView: View {
    let isCorrect: Bool
    let score: Int
    let action: () -> Void
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(isCorrect ? .green : .red).opacity(0.7)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Text("Score: \(score)")
                            .font(.system(size: geo.size.width * 0.0703, weight: .bold))
                        Image(systemName: "star.fill") // Filled star
                            .font(.system(size: geo.size.width * 0.0703))
                            .foregroundColor(.yellow)
                    }
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: geo.size.width * 0.097))
                        .foregroundColor(.white)
                    
                    Text(isCorrect ? "Good Choice!" : "Wrong Answer!")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.bottom, geo.size.height * 0.0219)
                    
                    Button(action: action) {
                        Text("Move to next question")
                            .font(.title2)
                            .bold()
                            .padding()
                            .frame(width: .infinity)
                            .background(Color.white)
                            .foregroundColor(isCorrect ? .green : .red)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}

struct ScenarioCardView: View {
    let card: ScenarioCard
    var onChoose: (Bool) -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            ChoiceView(text: card.textLeft, isLeft: true, imageName: card.imageLeft)
                .onTapGesture { onChoose(true) }
            ChoiceView(text: card.textRight, isLeft: false, imageName: card.imageRight)
                .onTapGesture { onChoose(false) }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

struct ChoiceView: View {
    let text: String
    let isLeft: Bool
    let imageName: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: imageName)
                .font(.system(size: 40))
                .foregroundColor(isLeft ? .green : .blue)
            Text(text)
                .font(.system(size: 20, weight: .bold))
                .minimumScaleFactor(0.5)
                .lineLimit(3)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 160)
        .background(Color(isLeft ? .green : .blue).opacity(0.3))
        .cornerRadius(10)
        .animation(.easeInOut, value: text)
    }
}

func createGame() -> ReduceGame {
    let gameCards = [
        ScenarioCard(textLeft: "Shower for 5 minutes", textRight: "Shower for 1 hour!", correctIsLeft: true, imageLeft: "timer", imageRight: "clock.badge.exclamationmark"),
        ScenarioCard(textLeft: "Use both sides of the paper", textRight: "Draw only one line and throw away!", correctIsLeft: true, imageLeft: "square.fill.on.square", imageRight: "trash.fill"),
        ScenarioCard(textLeft: "Keep lights on, I love light!", textRight: "Turn off the light when not using.", correctIsLeft: false, imageLeft: "lightbulb.fill", imageRight: "lightbulb.slash.fill"),
        ScenarioCard(textLeft: "Throw away food if don't like", textRight: "Eat some of it and share with others", correctIsLeft: false, imageLeft: "trash.fill", imageRight: "fork.knife.circle.fill"),
        ScenarioCard(textLeft: "Bring your own bag", textRight: "Use plastic bags that harm the planet", correctIsLeft: true, imageLeft: "bag.fill", imageRight: "xmark.bin.fill"),
        ScenarioCard(textLeft: "Turn off water while brushing teeth", textRight: "Let water run the whole time", correctIsLeft: true, imageLeft: "drop.halffull", imageRight: "drop.triangle"),
        ScenarioCard(textLeft: "Fix dripping tap right away", textRight: "Let tap drip all day long", correctIsLeft: true, imageLeft: "wrench.fill", imageRight: "drop.triangle"),
        ScenarioCard(textLeft: "Take small portions and ask for more", textRight: "Take huge portions and throw away", correctIsLeft: true, imageLeft: "fork.knife.circle.fill", imageRight: "trash.fill"),
        ScenarioCard(textLeft: "Save food you don't eat for later", textRight: "Throw away food you don't finish", correctIsLeft: true, imageLeft: "refrigerator.fill", imageRight: "trash.fill"),
        ScenarioCard(textLeft: "Take many snacks and waste them", textRight: "Share your snack with a friend", correctIsLeft: false, imageLeft: "takeoutbag.and.cup.and.straw.fill", imageRight: "person.2.fill"),
        ScenarioCard(textLeft: "Open curtains to use sunlight", textRight: "Turn on all lights in daytime", correctIsLeft: true, imageLeft: "light.max", imageRight: "lightbulb.fill"),
        ScenarioCard(textLeft: "Close fridge door quickly", textRight: "Stand with fridge door open", correctIsLeft: true, imageLeft: "refrigerator.fill", imageRight: "door.garage.open"),
        ScenarioCard(textLeft: "Break toys and throw away", textRight: "Play with toys carefully", correctIsLeft: false, imageLeft: "hammer.fill", imageRight: "teddybear.fill"),
        ScenarioCard(textLeft: "Share toys with friends", textRight: "Ask for brand new toys every day", correctIsLeft: true, imageLeft: "teddybear.fill", imageRight: "cart.fill"),
        ScenarioCard(textLeft: "Fix broken crayons with tape", textRight: "Throw away broken crayons", correctIsLeft: true, imageLeft: "pencil.tip", imageRight: "trash.fill"),
        ScenarioCard(textLeft: "Throw paper on the ground", textRight: "Put paper in recycling bin", correctIsLeft: false, imageLeft: "xmark.bin.fill", imageRight: "arrow.3.trianglepath"),
        ScenarioCard(textLeft: "Use a refillable water bottle", textRight: "Use new plastic bottles each time", correctIsLeft: true, imageLeft: "waterbottle.fill", imageRight: "waterbottle"),
        ScenarioCard(textLeft: "Change clothes many times a day", textRight: "Wear clothes until they're dirty", correctIsLeft: false, imageLeft: "tshirt.fill", imageRight: "tshirt"),
        ScenarioCard(textLeft: "Pass clothes to younger kids", textRight: "Throw away outgrown clothes", correctIsLeft: true, imageLeft: "tshirt.fill", imageRight: "trash.fill"),
        ScenarioCard(textLeft: "Leave trash on the ground", textRight: "Pick up trash at the park", correctIsLeft: false, imageLeft: "xmark.bin.fill", imageRight: "arrow.3.trianglepath"),
        ScenarioCard(textLeft: "Water plants with leftover water", textRight: "Pour leftover water down the drain", correctIsLeft: true, imageLeft: "drop.fill", imageRight: "shower.fill"),
        ScenarioCard(textLeft: "Use crayons until they're tiny", textRight: "Throw away big crayons", correctIsLeft: true, imageLeft: "pencil.tip", imageRight: "trash.fill"),
        ScenarioCard(textLeft: "Grab handfuls of tissues", textRight: "Use a tissue only when needed", correctIsLeft: false, imageLeft: "hand.point.up.braille.fill", imageRight: "1.square.fill")
    ]
    return ReduceGame(cards: gameCards)
}

class ReduceGame: ObservableObject {
    @Published var cards: [ScenarioCard]
    @Published var currentIndex = 0
    @Published var score = 0
    @Published var showFeedback: Bool = false
    @Published var isCorrect: Bool = false

    init(cards: [ScenarioCard]) {
        self.cards = cards.shuffled()
    }

    func choose(isLeft: Bool) {
        guard let currentCard = currentCard else { return }
        
        if currentCard.correctIsLeft == isLeft {
            score += 1
            isCorrect = true
        } else {
            isCorrect = false
        }
        showFeedback = true
    }
    
    var currentCard: ScenarioCard? {
        guard currentIndex < cards.count else { return nil }
        return cards[currentIndex]
    }
    
    func moveToNextCard() {
        showFeedback = false
        currentIndex += 1
    }
    
    func reset() {
        currentIndex = 0
        cards = cards.shuffled()
        score = 0
    }
}

struct ReduceEndScreenView: View {
    let score: Int
    var resetAction: () -> Void
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .fill(Color.green)
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
                        Image(systemName: "star.fill")
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

struct ReduceGameView: View {
    @StateObject var game: ReduceGame
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .fill(Color.green)
                    .overlay(
                        Image("Green_Forest_1")
                            .resizable()
                            .scaledToFill()
                    )
                    .ignoresSafeArea()
                    .frame(width: geo.size.width, height: geo.size.height)
                if game.showFeedback {
                    FeedbackView(isCorrect: game.isCorrect, score: game.score, action: { game.moveToNextCard() })
                } else {
                    VStack {
                        if let currentCard = game.currentCard {
                            VStack {
                                HStack {
                                    Text("Score: \(game.score)")
                                        .font(.system(size: geo.size.width * 0.0703, weight: .bold))
                                    Image(systemName: "star.fill") // Filled star
                                        .font(.system(size: geo.size.width * 0.0703))
                                        .foregroundColor(.yellow)
                                }
                                ScenarioCardView(card: currentCard, onChoose: {choice in game.choose(isLeft: choice)})
                            }
                        } else {
                            ReduceEndScreenView(score: game.score, resetAction: {game.reset()})
                        }
                    }
                }
            }
        }
    }
}

struct ReduceGameMenuView: View {
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    Rectangle()
                        .fill(Color.green)
                        .overlay(
                            Image("Green_Forest_1")
                                .resizable()
                                .scaledToFill()
                        )
                        .ignoresSafeArea()
                        .frame(width: geo.size.width, height: geo.size.height)
                    VStack() {
                        Text("Welcome to the Reduce Game!")
                            .foregroundStyle(.black)
                            .font(.system(size: geo.size.width * 0.0703, weight: .bold))
                            .frame(width: .infinity)
                        Spacer()
                        NavigationLink {
                            ReduceGameView(game: createGame())
                        } label: {
                            Text("Start game")
                                .padding()
                                .foregroundStyle(.black)
                                .font(.system(size: geo.size.width * 0.0586, weight: .bold))
                                .background(Color.clear)
                        }
                        .buttonStyle(.plain)
                        Spacer()
                    }
                    .padding(.bottom, geo.size.height * 0.097)
                    .padding(.top, geo.size.height * 0.097)
                }
            }
        }
    }
}

#Preview {
    ReduceGameMenuView()
}
