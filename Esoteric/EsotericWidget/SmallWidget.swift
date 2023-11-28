//
//  SwiftUIView.swift
//  Esoteric
//
//  Created by Alex on 22.11.2023.
//

import SwiftUI

struct SmallWidget: View {

    var body: some View {
        ZStack {
            Image("BGimg").resizable().aspectRatio(contentMode: .fill)
                
            VStack(alignment:.center, spacing: 0) {
          
           
                if DayConterService().isThisDayCompleted() {
                    Text("Вы молодец!")
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                } else {
                    Text("Откроем карту дня?")
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                        .foregroundColor(.accent)
                }
                
                Text("\(DayConterService().getDayStreak())")
                    .foregroundColor(.white)
                    .font(.custom("ElMessiri-Bold", size: 40))
                
                Text("серия дней")
                    .multilineTextAlignment(.center)
                    .lineLimit(4)
                    .foregroundColor(.white)
                
              
            }.padding(5)
        }
    }
}
