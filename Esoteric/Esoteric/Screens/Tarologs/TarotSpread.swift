//
//  TarotSpread.swift
//  Esoteric
//
//  Created by Alex on 11.11.2023.
//

import SwiftUI

struct TarotWaitingCardView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: 200, height: 300)
            .background(Image("5")
                .resizable()
                .frame(width: 200, height: 300)
                        )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(LinearGradient(gradient: Gradient(colors: [
                        Color.brown,
                        Color.red,
                        Color.yellow,
                        Color.blue
                    ]), startPoint: .bottomLeading, endPoint: .topTrailing), lineWidth: 4)
            )
            .opacity(0.4)
    }
}


struct TarotSpread: View {
    @State private var questionText: String = ""
    @State private var isQuestionSent: Bool = false
    let notificationCenter = UserNotifications.shared

    var body: some View {
        ZStack {
            BackGroundView()
//                .frame(width: .infinity, height: .infinity)

            VStack {
                if !isQuestionSent {
                    Text("Какой вопрос вы хотите задать тарологу?")
                        .font(.custom("ElMessiri-Bold", size: 25))
                        .foregroundColor(.white)
                        .padding()

                    TextField("Ваш вопрос", text: $questionText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: UIScreen.main.bounds.width - 42)
                        .padding()

                    Button(action: {
                        withAnimation {
                            isQuestionSent = true
                        }
                        notificationCenter.requestNotifications()
                        notificationCenter.sendTarotSpreadNotification(afterTime: .fiveSec)
                    }) {
                        Text("Отправить вопрос")
                    }.DefButtonStyle()
                } else {
                    VStack {
                        Text("Когда таролог ответит, мы пришлем вам уведомление")
                            .font(.custom("ElMessiri-Bold", size: 25))
                            .foregroundColor(.white)
                            .padding()

                        HStack {
                            TarotWaitingCardView()
                        }

                    }
                }
            }
        }
    }
}


#Preview {
    TarotSpread()
}
