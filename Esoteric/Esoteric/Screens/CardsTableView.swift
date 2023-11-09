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

    
    init() {
        self.cards = tarotDB.shuffled()
    }
    
    func getTaroInfo(){
//#if DEBUG
//        self.text = "Сегодня тебя ожидают небольшие испытания, но не позволяй им сбить с толку – верь в свои силы и достигнешь успеха."
//#else
        if let card = selectedCard {
            gpt.test(promt: "Я гадаю на картах таро, мне выпала \(card.name). Что это значит? Мне нужен максимально креативный ответ.") { [weak self] result in
                DispatchQueue.main.async {
                    self?.text = result
                }
            }
        }
//#endif
       
    }
    
    
}


struct CardsTableView: View {
    
    @StateObject var model: CardsTableViewModel = CardsTableViewModel()
    @State var isSelected = false
  
    var body: some View {
        ZStack {
            BackGroundView()
            VStack(spacing: 20) {
                ZStack {
                    if let selectedCard = model.selectedCard {
                        CardFlipHero(isSelected: $isSelected, text: "card1")
                            .frame(width: 220, height: 320)
                            
                            .shadow(color: .purple.opacity(0.5), radius: 40, x: 0, y: 0)
                    }
                }.frame(width: 220, height: 320)
               
                   
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
                                        if isSelected == false  {
                                            withAnimation {
                                                
                                                model.selectedCard = card
                                                
                                            }
                                           
                                        }
                                    }
                                
                            }
                        }
                    }.frame(height: 230)
                    
                }.scrollIndicators(.hidden)
                
                
                
            }
            
        }
        .sheet(isPresented: $isSelected, content: {
            ScrollView(.vertical, content: {
                VStack(alignment: .leading, content: {
                    Image("art_delimiter2").resizable().aspectRatio(contentMode: .fill)
                    
                    
                    ShineTitleView(text: model.selectedCard?.name ?? "Будущее туманно")
                    
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
        CardsTableView().navigationTitle("lol")
    }.preferredColorScheme(.dark)
}
