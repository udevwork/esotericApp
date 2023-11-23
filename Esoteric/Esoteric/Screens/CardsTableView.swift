//
//  CardsTableView.swift
//  Esoteric
//
//  Created by Denis Kotelnikov on 03.11.2023.
//

import SwiftUI

class CardsTableViewModel: ObservableObject {

    enum DeckType {
        case OneCard, ThreeCards, TarotReader
    }
    
    var gpt = GPTService()
    @Published var text: String = ""
    @Published var isGPTloading: Bool = false
    @Published var selectedCard: Tarot? = nil
    @Published var cards: [Tarot] = []
    @Published var isSelected = false
    @Published var activePageIndex: Int = 0


    var cardsNum: Int
    var selectedCardsNumber: Int = 0
    var selectedCards: [Int: Tarot?] = [:]

    let onboardData = HorMenuSnapData()
    let tilePadding: CGFloat = 45
    let tileWidth: CGFloat = screenWidthPart(2.5)
    let tileHeight: CGFloat = screenPart(3)
    
    @Published var showModalView = false
    
    init(deckType: CardsTableViewModel.DeckType) {
        self.cards = tarotDB.shuffled()
        switch deckType {
      
            case .OneCard:
                self.cardsNum = 1
                for index in 1...cardsNum {
                    selectedCards[index] = nil
                }
            case .ThreeCards:
                self.cardsNum = 3
                for index in 1...cardsNum {
                    selectedCards[index] = nil
                }
            case .TarotReader:
                self.cardsNum = 3
                for index in 1...cardsNum {
                    selectedCards[index] = nil
                }
                select(card: self.cards.randomElement()!)
                select(card: self.cards.randomElement()!)
                select(card: self.cards.randomElement()!)
                activePageIndex = 0
                isSelected = true
        }
        
        
       
    }
    
    func select(card: Tarot) {
        if selectedCardsNumber == cardsNum {
            return
        }
        selectedCards[selectedCardsNumber] = card
        withAnimation {
            activePageIndex = selectedCardsNumber
        }
       
        selectedCardsNumber += 1
      
        if selectedCardsNumber == cardsNum {
        }
    }

    func getTaroInfo() {
        if text.isEmpty == false {
            showModalView = true
            return
        }
        var names: String = ""
        selectedCards.forEach { (key: Int, value: Tarot?) in
            names.append("\(value!.name),")
        }
        if names.isEmpty {
            return
        }
        var promt: String = ""
        promt = """
Я гадаю на картах таро. Мой запрос был "Стоит ли менять работу?".
мне выпали \(names). Что эти карты вместе могут значить в рамках моего запроса?
Ответь так, будто ты человек и пишешь неформальное письмо.
"""
//        if cardsNum == 1 {
//            promt = "мне выпала \(names). Что эта карта может значить? Ответь в паре предложений."
//        } else {
//            promt = "мне выпали \(names). Что эти карты вместе могут значить? Ответь в паре предложений."
//        }
          //  text = "мне выпали \(names). Что эти карты вместе могут значить? Ответь в паре предложений."
        isGPTloading = true
        gpt.test(promt: promt) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let content):
                    if content.isEmpty {
                        self?.text = "Туман не рассеялся"
                    } else {
                        self?.text = content
                        self?.isGPTloading = false
                        self?.showModalView = true
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self?.text = "Туман не рассеялся"
                }
            }
        }
    }

    func addRandomCards() {
        let randomCards = generateRandomCards()
        selectedCardsNumber = 0
        for card in randomCards {
            select(card: card)
        }
        cards.append(contentsOf: randomCards)
        var names: String = ""
        selectedCards.forEach { (key: Int, value: Tarot?) in
            names.append("\(value!.name),")
        }
    }


    func generateRandomCards() -> [Tarot] {
        guard let randomCard1 = tarotDB.randomElement(),
              let randomCard2 = tarotDB.randomElement(),
              let randomCard3 = tarotDB.randomElement() else { return [] }
        return [randomCard1, randomCard2, randomCard3]
    }

}

struct CardsTableView: View {
    
    @StateObject var model: CardsTableViewModel
    
    var body: some View {
        ZStack {
            TaroDeckBackGroundView()
            VStack(spacing: 0) {
                Spacer()
                HStack {
                    
                    VStack(spacing: -10) {
                        H1TitleView(textColor: .accentColor,text: "Карта дня", alignment: .center)
                        ArticleView(text: "Запрос во вселенную", alignment: .leading).opacity(0.6)
                    }
                    
                }
                Spacer()
                ZStack {
                   
                    PagingScrollView(activePageIndex  : $model.activePageIndex,
                                     tileWidth        : model.tileWidth,
                                     tilePadding      : model.tilePadding) {
                        
                        ForEach(model.selectedCards.map({
                            return $1!
                        })) { card in
    
                    
                            CardFlipHero(isSelected: $model.isSelected,
                                             text: "card\(card.number )")
                            
                                .shadow(color: .purple.opacity(0.5), radius: 40, x: 0, y: 0)
                        }
                        
                    }
                    
                } .frame(height: model.tileHeight)
                    .offset(y:-20)
                
                
                if model.isSelected == false {
                    VStack() {
                        ChooseYourCardArtView()
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: -20) {
                                ForEach(model.cards, id: \.id) { card in
                                    if card != model.selectedCard {
                                        FakeCardView()
                                            .onTapGesture {
                                                model.select(card: card)
                                                withAnimation {
                                                    model.selectedCard = card
                                                }
                                            }
                                    }
                                }
                            }.frame(height: screenPart(4.2))
                        }.frame(height: screenPart(7.2)).scrollIndicators(.hidden)
                        SwipeCardsCardArtView()
                    }
                } else {
                    ZStack{
                        Button(action: {
                            model.getTaroInfo()
                        }, label: {
                            Text("Открыть предсказание")
                        }).DefButtonStyle()
                    }.frame(height: screenPart(4))
                }
                Spacer()
            }
            if model.isGPTloading {
                LoadingIndicator().transition(.opacity)
            }
        }

        .sheet(isPresented: $model.showModalView, content: {
            ScrollView(.vertical, content: {
                VStack(alignment: .center) {
                                        
                    ForEach((model.selectedCards.map({ (key: Int, value: Tarot?) in
                        return value
                    }) as! [Tarot]), id: \.id) { card in
                        ShineTitleView(text: card.name, alignment: .center)
                    }
                    
                    Image("art_delimiter2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 15)
                        .offset(y:-10)
                    
                    
                    ArticleView(text: model.text)
                    
                }.padding(.horizontal, 40).padding(.vertical, 50)
            })
            .presentationBackground(alignment: .bottom) {
                TarotReaderBackGroundView()
            }
            .presentationCornerRadius(5)
            .presentationDetents([.medium, .large])
        })
    }
}

struct FakeCardView: View {
    
    var body: some View {
        GeometryReader(content: { geo in
            Image("card-backward")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .background(.orange, in: RoundedRectangle(cornerRadius: 20))
                .rotation3DEffect(.degrees(self.rotationAngle(for: geo.frame(in: .global).midX)),
                                                           axis: (x: 0, y: 2, z: -1))
            
                .offset(x: 0, y: self.offset(for: geo.frame(in: .global).midX))

        }) .frame(width: 80, height: 110)
            .shadow(color: .black.opacity(0.6), radius: 5, x: -20, y: 0)
    }
    
    func rotationAngle(for xPosition: CGFloat) -> Double {
        let scrollWidth = 110 + -20 // Ширина элемента плюс промежуток между ними
        let midX = UIScreen.main.bounds.width / 2
        let offset = Double(xPosition - midX)
        return -offset / Double(scrollWidth) * 20 // Измените угол поворота здесь
    }
    
    func offset(for xPosition: CGFloat) -> CGFloat {
        let midX = UIScreen.main.bounds.width / -3
           let offset = xPosition - midX
           let maxOffset: CGFloat = -70
           return maxOffset * sin(offset / 200) + 60
       }
    
}

#Preview {
    NavigationStack {
        CardsTableView(model: CardsTableViewModel(deckType: .OneCard))
    }.preferredColorScheme(.dark)
}
