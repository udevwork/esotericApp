//
//  TarotSpread.swift
//  Esoteric
//
//  Created by Alex on 11.11.2023.
//

import SwiftUI


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
    }
}

struct TarotSpread: View {
    @StateObject var model: TarotSpreadModel = TarotSpreadModel()
   
    var body: some View {
        ZStack {

            if model.isQuestionSent == false {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        H1TitleView(textColor: .accentColor, text: "Задай вопрос тарологу", alignment: .leading)
                        Image("art_delimiter9").resizable().aspectRatio(contentMode: .fit).frame(height: 11)
                        ArticleView(text: "Ваш таролог сделает расклад по вашему запросу и ответит вам. ", alignment: .leading)
                        TextField("Ваш вопрос", text: $model.questionText, axis: .vertical)
                            .textFieldStyle(.plain)
                            .padding()
                            .cornerRadius(30)
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.accentColor, lineWidth: 4))
                        
                        ArticleView(text: "Например: \"Хочу сменить работу\", \"Стоит ли сейчас уезжать в отпуск?\" или \"Подходящее время что бы рассказать секрет?\"", alignment: .leading).opacity(0.5)
                        ArticleView(text: "Обычно ответ приходит через 10-15 минут. Вам прийдет уведомление!", alignment: .leading).opacity(0.5)
                        Button(action: model.sendQuestion) {
                            Text("Отправить вопрос")
                        }.DefButtonStyle()
                        
                    }.padding(40)
                }
            } else {
                VStack {
                    HStack {
                        Spacer()
                        VStack(spacing: 30) {
                            H1TitleView(textColor: .accentColor,text: "Запрос отправлен!", alignment: .center)
                            Image("Vector-3").resizable().aspectRatio(contentMode: .fit).frame(height: 200)
                            ArticleView(text: "Когда таролог ответит, мы пришлем вам уведомление", alignment: .leading).opacity(0.6)
                        }
                        Spacer()
                    }
                }.padding(40)
            }
        }.background(  Image("BGimg_tarotReaderSpread")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea())
    }
}


#Preview {
    NavigationStack {
        TarotSpread().preferredColorScheme(.dark)
    }
}
