//
//  MemorizeGame.swift
//  Memorize
//
//  Created by wangyichao on 2023/12/30.
//  model file

import Foundation
import SwiftUI

struct MemoryGame<CardContent> where CardContent: Equatable{
    private(set) var cards: Array<Card>
    private(set) var theme: Theme {
        didSet {
            cards.shuffle()
        }
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent, theme: Theme) {
        cards = []
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex+1)a"))
            cards.append(Card(content: content, id: "\(pairIndex+1)b"))
        }
        self.theme = theme
    }
    
    mutating func startGame(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent, theme: Theme) {
        cards = []
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex+1)a"))
            cards.append(Card(content: content, id: "\(pairIndex+1)b"))
        }
        self.theme = theme
    }
    
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
            cards.indices.filter{index in cards[index].isFaceUp}.only
        }
        set {
            cards.indices.forEach{
                cards[$0].isFaceUp = (newValue == $0)
            }
        }
    }
    
    mutating func choose(_ card: Card) {
        print("chose \(card)")
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}) {
            // take care that the value type can't be writen
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                if let x = indexOfTheOneAndOnlyFaceUpCard {
                    if cards[chosenIndex].content == cards[x].content {
                        cards[chosenIndex].isMatched = true
                        cards[x].isMatched = true
                    }
                } else {
                    indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                }
                cards[chosenIndex].isFaceUp = true
            }
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        let content: CardContent
        func canShow() -> Bool {
            if isFaceUp {
                // ensure up card won't disappear immediately
                return true
            }
            return !isMatched
        }
        
        var id: String
        var debugDescription: String {
            "\(id): \(content) \(isFaceUp ? "up" : "down") \(isMatched ? "matched" : "") "
        }
    }
    
    struct Theme {
        private(set) var name: String
        private(set) var emojis: [String]
        private(set) var color: Color
    }
}

enum AllThemes: CaseIterable {
    case laugh,animal,fruit

    var theme: MemoryGame<String>.Theme {
        switch self {
        case .laugh:
            return MemoryGame<String>.Theme(name: "Laugh", emojis: ["😀","😃","😄","😁","😆","😅","🤣","😂","🙂","🙃","😉","😊","😇","🥰","😍","🤩","😘"], color: .orange)
        case .fruit:
            return MemoryGame<String>.Theme(name: "fruit", emojis: ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🫐", "🍈", "🍒", "🍑", "🥭", "🍍", "🥥", "🥝"], color: .green)
        case .animal:
            return MemoryGame<String>.Theme(name: "animal", emojis: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🦁", "🐯", "🦓", "🦒", "🦔", "🐾", "🐔", "🐸", "🦆"], color: .yellow)
        }
    }
    
    static func randomTheme() -> MemoryGame<String>.Theme {
        guard let randomTheme = AllThemes.allCases.randomElement() else {
            fatalError("Can't fetch random theme")
        }
        return randomTheme.theme
    }
}

extension Array {
    var only: Element? {
        return count == 1 ? first : nil
    }
}
