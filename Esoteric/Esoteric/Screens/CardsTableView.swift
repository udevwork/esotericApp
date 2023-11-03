//
//  CardsTableView.swift
//  Esoteric
//
//  Created by Denis Kotelnikov on 03.11.2023.
//

import SwiftUI

class CardsTableViewModel: ObservableObject {
    
    var gpt = GPTService()
    @Published var text: String = "Гадаю на кофейной гуще..."

    init() {
     
#if DEBUG
        self.text = "Сегодня тебя ожидают небольшие испытания, но не позволяй им сбить с толку – верь в свои силы и достигнешь успеха."
#else
        gpt.test(promt: "Придумай мне гороскоп на день.") { [weak self] result in
            DispatchQueue.main.async {
                self?.text = result
            }
        }
#endif
       
        
    }
    
    
}

struct CardsTableView: View {
    @StateObject var model: CardsTableViewModel = CardsTableViewModel()
    var body: some View {
        VStack(spacing: 20) {
            CardFlipHero(text: "card1")
            Text(model.text).padding(.horizontal,15)
        }
    }
}

#Preview {
    CardsTableView()
}
