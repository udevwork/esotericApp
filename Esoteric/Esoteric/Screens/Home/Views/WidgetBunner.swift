//
//  WidgetBunner.swift
//  Esoteric
//
//  Created by Denis Kotelnikov on 01.12.2023.
//

import SwiftUI

struct WidgetBunner: View {
    var body: some View {
        ScreenContentView(color: .clear) {
            VStack(alignment: .leading, spacing: 8) {
                SectionTitleView(textColor: .white, text: Texts.HomeView.widgets, alignment: .leading)
                Image("art_delimiter8").resizable().aspectRatio(contentMode: .fill)
                ArticleView(textColor: .white, text: Texts.HomeView.widgetsSubTittle)
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
    WidgetBunner()
}
