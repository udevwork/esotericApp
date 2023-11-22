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
    let storageService = StorageService.shared

    var body: some View {
        ZStack {
            TarotReaderSpreadBackGroundView()
            VStack(alignment: .leading, spacing: 20) {
                if !isQuestionSent {
                    SectionTitleView(textColor: .accentColor, text: "Какой вопрос вы хотите задать тарологу?", alignment: .leading)
                    ArticleView(text: "Запросить расклад прямо сейчас!", alignment: .leading).opacity(0.6)
                    
                    TextField("Ваш вопрос", text: $questionText, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                    Button(action: {
                        withAnimation {
                            isQuestionSent = true
                        }
                        notificationCenter.requestNotifications()
                        notificationCenter.sendTarotSpreadNotification(afterTime: .fiveSec)
                        let currentTimeInterval = Date().timeIntervalSince1970
                        storageService.saveQuestion(text: TarotModel(userQuestion: questionText, answer: "1", time: currentTimeInterval), key: SavingKeys.question.rawValue)
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
            }.padding(40)
        }
    }
}


#Preview {
    TarotSpread()
}
