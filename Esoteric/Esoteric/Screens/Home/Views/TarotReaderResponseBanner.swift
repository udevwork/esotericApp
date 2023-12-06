//
//  TarotReaderResponseBanner.swift
//  Esoteric
//
//  Created by Denis Kotelnikov on 01.12.2023.
//

import SwiftUI

struct TarotReaderResponseBanner: View {
    
    @State var tarotReady: Bool
    
    var body: some View {
     
            ScreenContentView(color: .clear) {
                VStack(alignment: .leading, spacing: 28) {
                    
                    if tarotReady {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image("Vector-1").resizable().aspectRatio(contentMode: .fit).frame(height: 140)
                            }.frame(maxWidth: .infinity)
                            SectionTitleView(textColor: .white, text: Texts.HomeView.spreadReady, alignment: .leading)
                            Image("art_delimiter8").resizable().aspectRatio(contentMode: .fill)
                            ArticleView(textColor: .white, text: Texts.HomeView.seeSpreadReady)
                        }
                        NavigationLink {
                            CardsTableView(model: CardsTableViewModel(deckType: .TarotReader))
                        } label: {
                            Text(Texts.HomeView.spreadReadyRead)
                        }.DefButtonStyle()
                    } else {
                        VStack(alignment: .leading, spacing: 8) {
                            SectionTitleView(textColor: .white, text: Texts.HomeView.spreadInProgress, alignment: .leading)
                                
                            Image("art_delimiter8").resizable().aspectRatio(contentMode: .fill)
                            ArticleView(textColor: .white, text: Texts.HomeView.weSendNotification)
                        }
                    }
                    
                    
                    
                }.background {
                    Image("ScreenContentViewBG")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .opacity(0.3)
                        .scaleEffect(1.1)
                    
                }
            }
        
    }
}

#Preview {
    TarotReaderResponseBanner(tarotReady: true)
}
