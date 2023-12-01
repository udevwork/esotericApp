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

struct ComplexBackGroundView: View {
    var body: some View
    {
        ZStack {
            Color(uiColor: UIColor(hex: "181818")!).ignoresSafeArea()
            VStack(content: {
                HStack(alignment:.top,content: {
                    Image("top_left").resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 90)
                    Spacer()
                    
                    Image("top_center").resizable().aspectRatio(contentMode: .fit)
                        .offset(y:-10)
                        .frame(width: 90)
                    Spacer()
                    Image("top_right").resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 90)
                })
                
                Spacer()
                HStack {
                    Image("midle").resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 10)
                        .offset(x:-2)
                    Spacer()
                    Image("midle").resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 10)
                        .offset(x:2)
                }
                Spacer()
                
                HStack(content: {
                    Image("bottom_left").resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 90)
                    Spacer()
                    Image("bottom_right").resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 90)
                })
            }).padding(10).foregroundColor(.accent)
        }
    }
}

struct SubscriptionBackGroundView: View {
    var body: some View
    {
        ZStack {
            Color(uiColor: UIColor(hex: "181818")!).ignoresSafeArea()
        }
    }
}

#Preview {
    ComplexBackGroundView()
}
