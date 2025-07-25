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
                Color(isCorrect ? .green : .red)
                    .opacity(0.7)
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
                            .background(Color.white)
                            .foregroundColor(isCorrect ? .green : .red)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 40)
                }
            }
        }
    }
}

// Add this extension (put it outside any other structs)
extension View {
    func slashSelect(action: @escaping () -> Void) -> some View {
        modifier(SlashSelectModifier(action: action))
    }
}

struct SlashSelectModifier: ViewModifier {
    let action: () -> Void
    @State private var dragPoints: [CGPoint] = []
    @State private var validSlash = false
    @State private var gestureStarted = false
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            // Trail drawing - only shows after first valid movement
            if validSlash && dragPoints.count > 1 {
                Path { path in
                    path.move(to: dragPoints.first!)
                    for point in dragPoints.dropFirst() {
                        path.addLine(to: point)
                    }
                }
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [.white, .blue]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(
                        lineWidth: 8,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .blur(radius: 2)
                .opacity(0.7)
            }
        }
        .gesture(
            DragGesture(minimumDistance: 10)
                .onChanged { value in
                    if !gestureStarted {
                        gestureStarted = true
                        dragPoints = [value.location]
                    } else {
                        dragPoints.append(value.location)
                        
                        if dragPoints.count >= 2 {
                            let distance = hypot(
                                value.location.x - dragPoints.first!.x,
                                value.location.y - dragPoints.first!.y
                            )
                            validSlash = distance > 30
                        }
                    }
                }
                .onEnded { value in
                    if validSlash {
                        action()
                    }
                    dragPoints = []
                    validSlash = false
                    gestureStarted = false
                }
        )
        .contentShape(Rectangle())
    }
}

// 2. Modify ChoiceView - just replace onTapGesture with slashSelect
struct ChoiceView: View {
    let text: String
    let isLeft: Bool
    let imageName: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: imageName)
                .font(.system(size: 80))
                .foregroundColor(.white)
                .padding(.bottom, 10)
            
            Text(text)
                .font(.system(size: 32, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
                .minimumScaleFactor(0.5)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)
        }
        .padding(30)
        .frame(maxWidth: .infinity, minHeight: 350)
        .background(
            isLeft ?
            LinearGradient(gradient: Gradient(colors: [.green, .mint]), startPoint: .top, endPoint: .bottom) :
            LinearGradient(gradient: Gradient(colors: [.blue, .cyan]), startPoint: .top, endPoint: .bottom)
        )
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white, lineWidth: 5)
        )
        .padding(.horizontal, 20)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: text)
    }
}

// 3. Update ScenarioCardView - just change onTapGesture to slashSelect
struct ScenarioCardView: View {
    let card: ScenarioCard
    var onChoose: (Bool) -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            ChoiceView(text: card.textLeft, isLeft: true, imageName: card.imageLeft)
                .slashSelect {
                    onChoose(true)
                }
            
            ChoiceView(text: card.textRight, isLeft: false, imageName: card.imageRight)
                .slashSelect {
                    onChoose(false)
                }
        }
        .padding()
        .frame(maxWidth: .infinity)
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
            .ignoresSafeArea()
        }
    }
}



#Preview {
    let game = createGame()
    ReduceGameView(game: game)
}
