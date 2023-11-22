//
//  ChooseYourCardArtView.swift
//  Esoteric
//
//  Created by Denis Kotelnikov on 21.11.2023.
//

import SwiftUI

struct ChooseYourCardArtView: View {
    var body: some View {
        VStack(spacing:0) {
            Text("Выберите карту")
                .lineLimit(1)
                .font(.custom("ElMessiri-Bold", size: 18))
            Image("Arrow 2")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }.frame(height: 55)
    }
}

struct SwipeCardsCardArtView: View {
    var body: some View {
        ZStack {
            Image("Arrow 1")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text("Свайп колоды")
                .lineLimit(1)
                .font(.custom("ElMessiri-Bold", size: 18))
                .offset(y:20)
        }.frame(height: 25)
    }
}

#Preview {
    ChooseYourCardArtView()
}
