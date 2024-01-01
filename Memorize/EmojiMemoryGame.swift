//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by wangyichao on 2023/12/30.
// VM file

import Foundation

class EmojiMemoryGame: ObservableObject {
    private static func getCardContentFactory(by theme: MemoryGame<String>.Theme) -> (Int) -> String {
        let emojis = theme.emojis.shuffled()
        return { index in
            if emojis.indices.contains(index) {
                return emojis[index]
            }
            return "⁇"
        }
    }
    
    private static func createMemoryGame() -> MemoryGame<String> {
        let theme = AllThemes.randomTheme()
        return MemoryGame(numberOfPairsOfCards: 8, cardContentFactory: getCardContentFactory(by: theme), theme: theme)
    }
    
    
    @Published private var model = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    var theme: MemoryGame<String>.Theme {
        return model.theme
    }
    
    // MARK: - Intents
    
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func startGame() {
        let theme = AllThemes.randomTheme()
        model.startGame(numberOfPairsOfCards: 8, cardContentFactory: EmojiMemoryGame.getCardContentFactory(by: theme), theme: theme)
    }
}
