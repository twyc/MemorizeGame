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
            Button(action: {
                viewModel.startGame()
            }, label: {
                Text("Start Memorize!").font(.largeTitle)
            })
            ScrollView {
                cards
                    .animation(.default, value: viewModel.cards)
            }
            themeNameLabel
        }
        .padding()
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 0)], spacing: 0) {
            ForEach(viewModel.cards) { card in
                CardView(card: card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            }
        }
        .foregroundColor(viewModel.theme.color)
    }
    
    var themeNameLabel: some View {
        HStack {
            Spacer()
            Text(viewModel.theme.name).font(.largeTitle).foregroundColor(viewModel.theme.color)
            Spacer()
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
        .opacity(card.canShow() ? 1 : 0)
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
