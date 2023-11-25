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

class TarotSpreadModel: ObservableObject {
    
    @Published var questionText: String = ""
    @Published var isQuestionSent: Bool = false
    let notificationCenter = UserNotifications.shared
    let storageService = StorageService.shared
    
    init() {
        
    }
    
    func sendQuestion(){
        withAnimation {
            isQuestionSent = true
        }
        notificationCenter.requestNotifications()
        notificationCenter.sendTarotSpreadNotification(afterTime: .oneMin)
        let currentTimeInterval = Date().dateByAdding(1, .minute).date
        let tarotToSave = TarotModel(userQuestion: questionText, answer: "1", time: currentTimeInterval)
        storageService.saveQuestion(text: tarotToSave, key: SavingKeys.question.rawValue)
        
        print(tarotToSave)
    }
}

struct TarotSpread: View {
    @StateObject var model: TarotSpreadModel = TarotSpreadModel()
   
    var body: some View {
        ZStack {
            TarotReaderSpreadBackGroundView()
            VStack(alignment: .leading, spacing: 20) {
                if model.isQuestionSent == false {
                    SectionTitleView(textColor: .accentColor, text: "Какой вопрос вы хотите задать тарологу?", alignment: .leading)
                    ArticleView(text: "Запросить расклад прямо сейчас!", alignment: .leading).opacity(0.6)
                    ArticleView(text: "Ваш таролог сделает расклад по вашему запросу и ответит вам. ", alignment: .leading).opacity(0.6)
                    TextField("Ваш вопрос", text: $model.questionText, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                    Button(action: model.sendQuestion) {
                        Text("Отправить вопрос")
                    }.DefButtonStyle()
                    
                } else {
                    
                    VStack {
                        HStack {
                            Spacer()
                            VStack(spacing: -10) {
                                H1TitleView(textColor: .accentColor,text: "Запрос отправлен!", alignment: .center)
                                ArticleView(text: "Когда таролог ответит, мы пришлем вам уведомление", alignment: .leading).opacity(0.6)
                            }.offset(y: -15)
                            Spacer()
                        }
                       

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
