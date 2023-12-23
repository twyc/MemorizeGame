//
//  ContentView.swift
//  Memorize
//
//  Created by wangyichao on 2023/11/29.
//

import SwiftUI

let allEmojis: Array<Array<String>> = [
    ["😀","😃","😄","😁","😆","😅","🤣","😂","🙂","🙃","😉","😊","😇","🥰","😍","🤩","😘"],
    ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🦁", "🐯", "🦓", "🦒", "🦔", "🐾", "🐔", "🐸", "🦆"],
    ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🫐", "🍈", "🍒", "🍑", "🥭", "🍍", "🥥", "🥝"]
]

struct ContentView: View {
    
    @State var cardCount = 8 * 2
    @State var themeIndex = 0
    
    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle)
            ScrollView {
                cards
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
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
            ForEach(0..<cardCount, id: \.self) { index in
                CardView(content: getEmojis()[index])
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
    
    func getEmojis()-> Array<String> {
//        Since inside Card there is isFaceUp not changing content logic.
//        Shuffle every runloop will cause unwilled repeat.
        let x = allEmojis[themeIndex].prefix(8)
        let ret = (x+x).shuffled()
        print("\(ret)")
        return ret
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
    let content: String
    @State var isFaceUp: Bool = false
    @State var preContent: String = "0"
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.stroke(lineWidth: 2)
                Text(calulateContent()).font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            base.fill().opacity(isFaceUp ? 0 : 1)
        }.onTapGesture {
            isFaceUp.toggle()
            if(isFaceUp) {
                preContent = content
            }
        }
    }
    
    func calulateContent() -> String {
        if (!isFaceUp) {
            return content
        }
        return preContent
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
