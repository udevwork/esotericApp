//
//  SubscriptionBanner.swift
//  Esoteric
//
//  Created by Denis Kotelnikov on 01.12.2023.
//

import SwiftUI

struct SubscriptionBanner: View {
    @Binding var showingSheet: Bool
    var body: some View {
        if User.shared.isProUser == false {
            ScreenContentView(color: .clear) {
                VStack(alignment: .leading, spacing: 28) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image("Vector").resizable().aspectRatio(contentMode: .fit).frame(height: 140)
                        }.frame(maxWidth: .infinity)
                        SectionTitleView(textColor: .white, text: Texts.HomeView.subscipt, alignment: .leading)
                        Image("art_delimiter8").resizable().aspectRatio(contentMode: .fill)
                        
                        ArticleView(textColor: .white, text: Texts.HomeView.subsciptSubTittle)
                    }
                    
                    Button {
                        Haptics.shared.play(.medium)
                        showingSheet.toggle()
                    } label: {
                        Text("Подписка")
                    }.DefButtonStyle()
                }
            }
        }
    }
}

#Preview {
    SubscriptionBanner(showingSheet: .constant(true))
}
