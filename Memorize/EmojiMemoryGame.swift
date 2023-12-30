//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by wangyichao on 2023/12/30.
// VM file

import Foundation

class EmojiMemoryGame: ObservableObject {
    private static let allEmojis: Array<Array<String>> = [
        ["😀","😃","😄","😁","😆","😅","🤣","😂","🙂","🙃","😉","😊","😇","🥰","😍","🤩","😘"],
        ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🦁", "🐯", "🦓", "🦒", "🦔", "🐾", "🐔", "🐸", "🦆"],
        ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🫐", "🍈", "🍒", "🍑", "🥭", "🍍", "🥥", "🥝"]
    ]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame(numberOfPairsOfCards: 8, cardContentFactory: { index in
            if allEmojis[0].indices.contains(index) {
                return allEmojis[0][index]
            }
            return "⁇"
        })
    }
    
    
    @Published private var model = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    // MARK: - Intents
    
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
}
