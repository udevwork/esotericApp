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
            Color.black.edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                Text("Esoterica")
                    .multilineTextAlignment(.center)
                    .font(.custom("ElMessiri-Regular", size: 17))
                    .foregroundColor(.white)
                Spacer()
                Text("Ваша сила")
                    .multilineTextAlignment(.center)
                    .font(.custom("ElMessiri-Regular", size: 18))
                    .foregroundColor(.white)
                Spacer()

                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.orange, Color.yellow]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .opacity(0.4)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text("2")
                            .foregroundColor(.white)
                            .font(.custom("ElMessiri-Regular", size: 18))
                    )

                Spacer()
            }
            .padding()
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
