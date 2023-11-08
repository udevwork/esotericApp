//
//  CardsTableView.swift
//  Esoteric
//
//  Created by Denis Kotelnikov on 03.11.2023.
//

import SwiftUI

class CardsTableViewModel: ObservableObject {
    
   // var gpt = GPTService()
    @Published var text: String = "Гадаю на кофейной гуще..."

    @Published var selectedCard: FakeCard? = nil
    @Published var cards: [FakeCard] = [.init(img: "card1"),
                                    .init(img: "card2"),
                                    .init(img: "card3"),
                                    .init(img: "card1"),
                                    .init(img: "card2"),
                                    .init(img: "card3"),
                                    .init(img: "card1"),
                                    .init(img: "card2"),
                                    .init(img: "card3")]
//
    
    init() {
//     
//#if DEBUG
//        self.text = "Сегодня тебя ожидают небольшие испытания, но не позволяй им сбить с толку – верь в свои силы и достигнешь успеха."
//#else
//        gpt.test(promt: "Придумай мне гороскоп на день.") { [weak self] result in
//            DispatchQueue.main.async {
//                self?.text = result
//            }
//        }
//#endif
       
        
    }
    
    
}

struct FakeCard : Identifiable, Hashable {
    var id = UUID().uuidString
    var img: String
}

struct CardsTableView: View {
    @StateObject var model: CardsTableViewModel = CardsTableViewModel()
//    @State var debug: String = "_"
//    @State var dragAmount = CGSize.zero
//    

    @State var isSelected = false
//    
//
  
    var body: some View {
        ZStack {
            BackGroundView()
            VStack(spacing: 20) {
                ZStack {
                    if let selectedCard = model.selectedCard {
                        CardFlipHero(text: selectedCard.img)
                            .frame(width: 220, height: 320)
                            .onTapGesture {
                                isSelected = true
                            }
                            .shadow(color: .purple.opacity(0.5), radius: 40, x: 0, y: 0)
                    }
                }.frame(width: 220, height: 320)
                
                HStack {
                    Rectangle().frame(height: 1).foregroundStyle(Color.white)
                    Text("Выберите карту")
                        .lineLimit(1)
                        .frame(width: 150)
                        .font(.custom("ElMessiri-Bold", size: 18))
                    Rectangle().frame(height: 1).foregroundStyle(Color.white)
                }.padding(.horizontal)
                
                ScrollView(.horizontal) {
                    HStack(spacing: -20) {
                        ForEach(model.cards.indices) { i in
                            if model.cards[i] != model.selectedCard {
                                
                                FakeCardView(text: model.cards[i].img)
                                    .onTapGesture {
                                        withAnimation {
                                            if isSelected == false {
                                                model.selectedCard = model.cards[i]
                                            }
                                        }
                                    }
                                
                            }
                        }
                    }.frame(height: 230)
                    
                }.scrollIndicators(.hidden)
                
                
                
            }
            if isSelected {
                Rectangle().frame(width: 200, height: 200, alignment: .center)
            }
        }
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
