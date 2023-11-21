//
//  TarotSpreadReady().swift
//  Esoteric
//
//  Created by Alex on 11.11.2023.
//

import SwiftUI

struct TarotSpreadReady: View {

    @StateObject var model: CardsTableViewModel
    @State var isSelected = false

    var storageService = StorageService.shared

    init(model: CardsTableViewModel) {
        self._model = StateObject(wrappedValue: model)
        model.addRandomCards()
    }

    var body: some View {
        ZStack {
            BackGroundView()
            VStack(spacing: 20) {
                Spacer()
                ThreeCardsLayouts(model: model, isSelected: $isSelected)
                Spacer()
                Spacer()
            }
        }
        .sheet(isPresented: $isSelected, content: {
            ScrollView(.vertical, content: {
                VStack(alignment: .leading, content: {
                    Image("art_delimiter2").resizable().aspectRatio(contentMode: .fill)
                    ForEach((model.selectedCards.map({ (key: Int, value: Tarot?) in
                        return value
                    }) as! [Tarot]), id: \.id) { card in
                        ShineTitleView(text: card.name)
                    }

                    let answer = storageService.loadQuestion(key: SavingKeys.question.rawValue)
                    ArticleView(text: answer?.answer ?? "")
                        .onAppear(perform: {
                            model.getTaroInfo()
                        })
                }).padding(30)
            })
            .presentationBackground(alignment: .bottom) {
                Color.buttonDefColor.opacity(0.0).background(.ultraThinMaterial)
            }
            .presentationCornerRadius(50)
            .presentationDetents([.medium, .height(300)])
        })
    }

}

#Preview {
    NavigationStack {
        TarotSpreadReady(model: CardsTableViewModel(cardsNum: 3))
    }.preferredColorScheme(.dark)
}
