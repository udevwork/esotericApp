//
//  TopLogoBanner.swift
//  Esoteric
//
//  Created by Denis Kotelnikov on 01.12.2023.
//

import SwiftUI

struct TopLogoBanner: View {
    
    @State var daysStreakCount: Int
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: -1) {
                Image("home_header_logo").resizable().frame(width: 120, height: 60)
                H1TitleView(textColor: .accentColor,text: "TAROT", alignment: .center)
                Image("art_delimiter9").resizable().aspectRatio(contentMode: .fit).offset(y: -6).frame(height: 10)
                ArticleView(text: "\(Texts.HomeView.cardOfDayCounter1) \(daysStreakCount) \(Texts.HomeView.cardOfDayCounter2)", alignment: .leading).bold()
            }
            Spacer()
        }
    }
}

#Preview {
    TopLogoBanner(daysStreakCount: 12)
}
