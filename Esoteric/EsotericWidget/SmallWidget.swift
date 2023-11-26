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
            Image("BGimg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Esoterica")
                    .multilineTextAlignment(.center)
                    .font(.custom("ElMessiri-Regular", size: 12))
                    .foregroundColor(.white)
                Spacer()
                Text("Tarot\ndays:")
                    .multilineTextAlignment(.center)
                    .font(.custom("ElMessiri-Bold", size: 18))
                    .foregroundColor(.accent)
                Spacer()

                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.orange, Color.yellow]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .opacity(0.4)
                    .frame(width: 30, height: 30)
                    .overlay(
                        Text("\(DayConterService().getDayCont())")
                            .foregroundColor(.white)
                            .font(.custom("ElMessiri-Bold", size: 20))
                            .offset(y:3)
                    )

                Spacer()
            }
            .padding()
        } .ignoresSafeArea()
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
    SmallWidget().frame(width: 100, height: 100, alignment: .center)
}
