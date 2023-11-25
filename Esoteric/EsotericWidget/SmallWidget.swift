//
//  SwiftUIView.swift
//  Esoteric
//
//  Created by Alex on 22.11.2023.
//

import SwiftUI

struct SmallWidget: View {

    //    var count: Int
    var body: some View {
        ZStack {
            Color(.black).opacity(0.7)
            VStack {
                Text("Tarot")
                    .multilineTextAlignment(.center)
                    .font(.custom("ElMessiri-Regular", size: 17))
                    .foregroundColor(.white)
                Text("Ваша сила вселенной:")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 11))
                //.font(.custom("ElMessiri-Regular", size: 18))
                    .foregroundColor(.white)
                Text("2")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 19))
                //.font(.custom("ElMessiri-Regular", size: 18))
                    .foregroundColor(.white)
            }
        }
    }
}

struct BackGView: View {
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

#Preview {
    SmallWidget()
}
