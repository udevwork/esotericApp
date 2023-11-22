//
//  LoadingIndicator.swift
//  Esoteric
//
//  Created by Denis Kotelnikov on 22.11.2023.
//

import SwiftUI

struct LoadingIndicator: View {
    
    @State private var isRotating1 = 0.0
    @State private var isRotating2 = 0.0
    @State private var isRotating3 = 0.0
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.7)
                .ignoresSafeArea()
            VStack {
                ZStack(alignment: .center, content: {
                    
                    Image("loading_orbit_1").resizable()
                        .rotationEffect(.degrees(isRotating1))
                        .onAppear {
                            withAnimation(.linear(duration: 1)
                                .speed(0.05)
                                .repeatForever(autoreverses: false)) {
                                    isRotating1 = 360.0
                                }
                        }
                    
                    Image("loading_orbit_2").resizable()
                        .rotationEffect(.degrees(isRotating2))
                        .onAppear {
                            withAnimation(.linear(duration: 1)
                                .speed(0.03)
                                .repeatForever(autoreverses: false)) {
                                    isRotating2 = 360.0
                                }
                        }
                    
                    Image("loading_orbit_3").resizable()
                        .rotationEffect(.degrees(isRotating3))
                        .onAppear {
                            withAnimation(.linear(duration: 1)
                                .speed(0.01)
                                .repeatForever(autoreverses: false)) {
                                    isRotating3 = 360.0
                                }
                        }
                    
                    Image("loading_top").resizable().offset(y:-7)
                }).frame(width: 200, height: 200, alignment: .center)
                    .onAppear {
                        isRotating1 = 360.0
                        isRotating2 = 360.0
                        isRotating3 = 360.0
                    }
                HStack {
              
                    VStack(spacing: -10) {
                       
                        ArticleView(text: "Открываем двери к магии", alignment: .leading).opacity(0.6)
                      
                    }
           
                }
            }
            .padding(.horizontal,50)
            .padding(.vertical, 80)
            .background(TarotReaderBackGroundView()).cornerRadius(20)
           //.padding()
            
        }
    }
}

#Preview {
    LoadingIndicator()
}
