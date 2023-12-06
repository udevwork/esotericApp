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
    
    func sendQuestion() {
        withAnimation {
            isQuestionSent = true
        }

        let randomMinutes = Int.random(in: (4...15))
        notificationCenter.requestNotifications()
        notificationCenter.sendTarotSpreadNotification(afterTime: TimeInterval(60*randomMinutes))
        let currentTimeInterval = Date().dateByAdding(randomMinutes, .minute).date
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
                        H1TitleView(textColor: .accentColor, text: Texts.TarologsView.takeQuestion, alignment: .leading)
                        Image("art_delimiter9").resizable().aspectRatio(contentMode: .fit).frame(height: 11)
                        ArticleView(text: Texts.TarologsView.youreTGetAnswer, alignment: .leading)
                        TextField("Ваш вопрос", text: $model.questionText, axis: .vertical)
                            .textFieldStyle(.plain)
                            .padding()
                            .cornerRadius(30)
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.accentColor, lineWidth: 4))
                        
                        ArticleView(text: Texts.TarologsView.simpleExample, alignment: .leading).opacity(0.5)
                        ArticleView(text: Texts.TarologsView.timeToResponce, alignment: .leading).opacity(0.5)
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
                            H1TitleView(textColor: .accentColor,text: Texts.TarologsView.qSent, alignment: .center)
                            Image("Vector-3").resizable().aspectRatio(contentMode: .fit).frame(height: 200)
                            ArticleView(text: Texts.TarologsView.recivePush, alignment: .leading).opacity(0.6)
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
