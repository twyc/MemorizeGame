//
//  MemorizeApp.swift
//  Memorize
//
//  Created by wangyichao on 2023/11/29.
//

import SwiftUI

@main
struct MemorizeApp: App {
    var body: some Scene {
        @StateObject var game = EmojiMemoryGame()
        
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
