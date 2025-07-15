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

class ReduceGame: ObservableObject {
    @Published var cards: [ScenarioCard]
    @Published var currentIndex = 0
    @Published var score = 0

    init(cards: [ScenarioCard]) {
        self.cards = cards.shuffled()
    }

    func choose(isLeft: Bool) {
        if cards[currentIndex].correctIsLeft == isLeft {
            score += 1
        }
        currentIndex += 1
    }
}

struct ScenarioCardView: View {
    let card: ScenarioCard
    var onChoose: (Bool) -> Void

    var body: some View {
        HStack(spacing: 20) {
            ChoiceView(text: card.textLeft, isLeft: true)
                .onTapGesture { onChoose(true) }
            ChoiceView(text: card.textRight, isLeft: false)
                .onTapGesture { onChoose(false) }
        }
        .padding()
    }
}

struct ChoiceView: View {
    let text: String
    let isLeft: Bool

    var body: some View {
        Text(text)
            .font(.title2)
            .frame(width: 140, height: 140)
            .background(Color(isLeft ? .green : .blue).opacity(0.3))
            .cornerRadius(12)
            .animation(.easeInOut, value: text)
    }
}


//
//  reduce_game.swift
//  serve-ios
//
//  Created by Nguyen Dylan on 15/7/25.
//

