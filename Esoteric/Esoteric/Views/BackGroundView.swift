//
//  BackGroundView.swift
//  Esoteric
//
//  Created by Denis Kotelnikov on 05.11.2023.
//

import SwiftUI

struct TaroDeckBackGroundView: View {
    var body: some View
    {
        ZStack(alignment: .center) {
            Image("BGimg_TaroDeck")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
        }
    }
}

struct BackGroundView: View {
    var body: some View
    {
        ZStack {
            Image("BGimg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
        }
    }
}

struct TarotReaderSpreadBackGroundView: View {
    var body: some View
    {
        ZStack {
            Image("BGimg_tarotReaderSpread")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
        }
    }
}

struct TarotReaderBackGroundView: View {
    var body: some View
    {
        ZStack {
            Color(uiColor: UIColor(hex: "181818")!)
            VStack(content: {
                HStack(content: {
                    Image("TL")
                    Spacer()
                    Image("TR")
                })
                Spacer()
                HStack(content: {
                    Image("BL")
                    Spacer()
                    Image("BR")
                })
            }).padding(30)
        }
    }
}

#Preview {
    BackGroundView()
}
