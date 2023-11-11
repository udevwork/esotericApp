//
//  CardsTableView.swift
//  Esoteric
//
//  Created by Denis Kotelnikov on 03.11.2023.
//

import SwiftUI

class CardsTableViewModel: ObservableObject {

    var gpt = GPTService()
    @Published var text: String = "Туман рассеивается..."
    @Published var selectedCard: Tarot? = nil
    @Published var cards: [Tarot] = []

    var cardsNum: Int
    var selectedCardsNumber: Int = 0
    var selectedCards: [Int: Tarot?] = [:]

    init(cardsNum: Int) {
        self.cardsNum = cardsNum
        for index in 1...cardsNum {
            selectedCards[index] = nil
        }
        self.cards = tarotDB.shuffled()
    }

    func select(card: Tarot) {
        if selectedCardsNumber == cardsNum {
            return
        }
        selectedCards[selectedCardsNumber] = card
        selectedCardsNumber += 1
        if selectedCardsNumber == cardsNum {
        }
    }

    func getTaroInfo() {
        var names: String = ""
        selectedCards.forEach { (key: Int, value: Tarot?) in
            names.append("\(value!.name),")
        }
        if names.isEmpty {
            return
        }
        var promt: String = ""
        if cardsNum == 1 {
            promt = "Я гадаю на картах таро, мне выпала \(names). Что эта карта может значить?"
        } else {
            promt = "Я гадаю на картах таро, мне выпали \(names). Что эти карты вместе могут значить?"
        }
        gpt.test(promt: promt) { [weak self] result in
            DispatchQueue.main.async {
                self?.text = result
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
    @State var isSelected = false
    
   
    var body: some View {
    
        
        ZStack {
            BackGroundView()
            VStack(spacing: 20) {
             
                Spacer()
                
                if model.cardsNum == 1 {
                    OneCardsLayouts(model: model, isSelected: $isSelected)
                }
                if model.cardsNum == 5 {
                    FiveCardsLayouts(model: model, isSelected: $isSelected)
                }
                if model.cardsNum == 3 {
                    ThreeCardsLayouts(model: model, isSelected: $isSelected)
                }
                   
                Spacer()
                
                HStack {
                    Image("r_arrow").scaleEffect(1.4).offset(x: -10.0, y: 5.0)
                    Text("Выберите карту")
//                        .overlay(content: {
//                            CommodityColor.gold.linearGradient
//                        })
                        .lineLimit(1)
                        .frame(width: 150)
                        .font(.custom("ElMessiri-Bold", size: 18))
                    Image("l_arrow").scaleEffect(1.4).offset(x: 10.0, y: 5.0)
                    
                }.padding(.horizontal)
                
                ScrollView(.horizontal) {
                    HStack(spacing: -20) {
                        ForEach(model.cards, id: \.id) { card in
                            if card != model.selectedCard {
                                
                                FakeCardView(text: "card1")
                                    .onTapGesture {
                                        model.select(card: card)
                                            withAnimation {
                                              
                                                model.selectedCard = card
                                                
                                            }
                                           
                                        
                                    }
                                
                            }
                        }
                    }.frame(height: 230)
                    
                }.scrollIndicators(.hidden)
                    .frame(height: 150)
                
                
                
            }
            
        }
        .sheet(isPresented: $isSelected, content: {
            ScrollView(.vertical, content: {
                VStack(alignment: .leading, content: {
                    Image("art_delimiter2").resizable().aspectRatio(contentMode: .fill)
                    
                    ForEach((model.selectedCards.map({ (key: Int, value: Tarot?) in
                        return value
                    }) as! [Tarot]), id: \.id) { card in
                        
                            ShineTitleView(text: card.name)
                        
                    }
                    
                    ArticleView(text: model.text)
                        .onAppear(perform: {
                            
                            model.getTaroInfo()
                        })
                    
                        
                }).padding(30)
            })
                .presentationBackground(alignment: .bottom) {
                    Color.buttonDefColor.opacity(0.0).background(.ultraThinMaterial)
                }
                .presentationCornerRadius(50)
                .presentationDetents([.medium, .height(200)])
        })
       
       
    }
    
    
}

struct FakeCardView: View {

    var text : String
    
    var body: some View {
     
        
        GeometryReader(content: { geo in
            
            Image(text)
                
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 20))
               
                .background(.orange, in: RoundedRectangle(cornerRadius: 20))
                .frame(width: 110, height: 160)
                .rotation3DEffect(.degrees(self.rotationAngle(for: geo.frame(in: .global).midX)),
                                                           axis: (x: 0, y: 1, z: -1))
            
                .offset(x: 0, y: self.offset(for: geo.frame(in: .global).midX))

        }) .frame(width: 110, height: 160)
        
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
        CardsTableView(model: CardsTableViewModel(cardsNum: 1)).navigationTitle("lol")
    }.preferredColorScheme(.dark)
}
