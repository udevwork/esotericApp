//
//  CardsLayouts.swift
//  Esoteric
//
//  Created by Denis Kotelnikov on 10.11.2023.
//

import SwiftUI

struct OneCardsLayouts: View {
    
    @StateObject var model: CardsTableViewModel
    @Binding var isSelected: Bool
    
    let height:CGFloat = screenPart(2.6)
    let width:CGFloat  = 210
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                if let card = model.selectedCards[0] {
                    CardFlipHero(isSelected: $isSelected,
                                 text: "card\(card?.number ?? 0)")
                        .shadow(color: .purple.opacity(0.5), radius: 40, x: 0, y: 0)
                }
            }
        }
    }
}

struct ThreeCardsLayouts: View {
    
    @StateObject var model: CardsTableViewModel
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 0, content: {
            
            if  let card =  model.selectedCards[0] {
                CardFlipHero(isSelected: $isSelected,
                             text: "card\(card?.number ?? 0)")
            
                .shadow(color: .purple.opacity(0.5), radius: 40, x: 0, y: 0)
                
            }
            
            if let card =  model.selectedCards[1] {
                CardFlipHero(isSelected: $isSelected,
                             text: "card\(card?.number ?? 0)")
             
                .shadow(color: .purple.opacity(0.5), radius: 40, x: 0, y: 0)
                
            }
            
            if let card =  model.selectedCards[2] {
                CardFlipHero(isSelected: $isSelected,
                             text: "card\(card?.number ?? 0)")
           
                .shadow(color: .purple.opacity(0.5), radius: 40, x: 0, y: 0)
                
            }
            
            
        })
    }
}



#Preview {
    OneCardsLayouts(model: CardsTableViewModel(deckType: .OneCard), isSelected: .constant(false))
}
