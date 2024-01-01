//
//  MemorizeGame.swift
//  Memorize
//
//  Created by wangyichao on 2023/12/30.
//  model file

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable{
    private(set) var cards: Array<Card>
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex+1)a"))
            cards.append(Card(content: content, id: "\(pairIndex+1)b"))
        }
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
}

extension Array {
    var only: Element? {
        return count == 1 ? first : nil
    }
}
