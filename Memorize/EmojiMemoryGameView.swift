//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by wangyichao on 2023/11/29.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    @State var themeIndex = 0
    
    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle)
            ScrollView {
                cards
            }
            Button("Shuffle") {
                viewModel.shuffle()
            }
            Spacer()
            cardCountAdjusters
        }
        .padding()
        .onAppear{
            changeTheme(idx: 0)
        }
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 0)], spacing: 0) {
            ForEach(viewModel.cards.indices, id: \.self) { index in
                CardView(card: viewModel.cards[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .foregroundColor(.orange)
    }
    
    var cardCountAdjusters: some View {
        HStack {
            Spacer()
            themeAdjuster(idx: 0, theme: "😀")
            themeAdjuster(idx: 1, theme: "🐶")
            themeAdjuster(idx: 2, theme: "🍏")
            Spacer()
        }
    }
    
    func changeTheme(idx: Int) {
        themeIndex = idx
    }
    
    func themeAdjuster(idx: Int, theme: String) -> some View {
        VStack {
            Button(action: {
                changeTheme(idx: idx)
            }, label: {
                Text(theme)
            })
            .imageScale(.large)
            .font(.largeTitle)
            .disabled(idx == themeIndex)
            Text(idx.codingKey.stringValue).font(.body)
        }
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.stroke(lineWidth: 2)
                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1, contentMode: .fit)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            base.fill().opacity(card.isFaceUp ? 0 : 1)
        }
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
