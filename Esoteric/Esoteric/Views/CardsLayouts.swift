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
    
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                
                if model.selectedCards[0] != nil {
                    CardFlipHero(isSelected: $isSelected, text: "card1")
                        .shadow(color: .purple.opacity(0.5), radius: 40, x: 0, y: 0)
                    
                }
            }
        }
    }
}

struct FiveCardsLayouts: View {
    
    @StateObject var model: CardsTableViewModel
    @Binding var isSelected: Bool
    
    
    var body: some View {
        VStack(alignment: .center, spacing: -120, content: {
            
            HStack(alignment: .center, spacing: -20) {
                ZStack {
                    
                    if model.selectedCards[0] != nil {
                        CardFlipHero(isSelected: $isSelected, text: "card1")
                            .shadow(color: .purple.opacity(0.5), radius: 40, x: 0, y: 0)
                        
                    }
                }.scaleEffect(0.5)
                
                ZStack {
                    
                    if model.selectedCards[1] != nil {
                        CardFlipHero(isSelected: $isSelected, text: "card1")
                            .shadow(color: .purple.opacity(0.5), radius: 40, x: 0, y: 0)
                        
                    }
                }.scaleEffect(0.5)
                
            }
            
            HStack(alignment: .center, spacing: -20) {
                ZStack {
                    
                    if model.selectedCards[2] != nil {
                        CardFlipHero(isSelected: $isSelected, text: "card1")
                            .shadow(color: .purple.opacity(0.5), radius: 40, x: 0, y: 0)
                        
                    }
                }.scaleEffect(0.5)
                
                ZStack {
                    
                    if model.selectedCards[3] != nil {
                        CardFlipHero(isSelected: $isSelected, text: "card1")
                            .shadow(color: .purple.opacity(0.5), radius: 40, x: 0, y: 0)
                        
                    }
                }.scaleEffect(0.5)
                
            }
            ZStack {
                
                if model.selectedCards[4] != nil {
                    CardFlipHero(isSelected: $isSelected, text: "card1")
                        .shadow(color: .purple.opacity(0.5), radius: 40, x: 0, y: 0)
                    
                }
            }.scaleEffect(0.5)
            
        }).frame(width: UIScreen.main.bounds.width-100, height: 320)
    }
}

struct ThreeCardsLayouts: View {
    
    @StateObject var model: CardsTableViewModel
    @Binding var isSelected: Bool
    
    
    var body: some View {
        VStack(alignment: .center, spacing: -120, content: {
            
            HStack(alignment: .center, spacing: -20) {
                ZStack {
                    
                    if model.selectedCards[0] != nil {
                        CardFlipHero(isSelected: $isSelected, text: "card1")
                            .shadow(color: .purple.opacity(0.5), radius: 40, x: 0, y: 0)
                        
                    }
                }.scaleEffect(0.6)
                
                ZStack {
                    
                    if model.selectedCards[1] != nil {
                        CardFlipHero(isSelected: $isSelected, text: "card1")
                            .shadow(color: .purple.opacity(0.5), radius: 40, x: 0, y: 0)
                        
                    }
                }.scaleEffect(0.6)
                
            }
            
            ZStack {
                
                if model.selectedCards[2] != nil {
                    CardFlipHero(isSelected: $isSelected, text: "card1")
                        .shadow(color: .purple.opacity(0.5), radius: 40, x: 0, y: 0)
                    
                }
            }.scaleEffect(0.6)
            
        }).frame(width: UIScreen.main.bounds.width-100, height: 320)
    }
}

#Preview {
    OneCardsLayouts(model: CardsTableViewModel(cardsNum: 1), isSelected: .constant(false))
}
