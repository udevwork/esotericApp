//
//  Tarologs.swift
//  Esoteric
//
//  Created by Alex on 11.11.2023.
//

import SwiftUI

struct TarotReader: Identifiable {
    var id = UUID()
    var name: String
    var photo: String
    var readingsCount: Int
    var isOnline: Bool
    var rating: Int
}

struct TarotReaderCell: View {
    var tarotReader: TarotReader
    @State private var isOnlineAnimation = false
    @State private var borderColor: Color = .white

    var body: some View {
        VStack {
            Image(tarotReader.photo)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 180, height: 180)
                .clipShape(Circle())
                .overlay(Circle().stroke(borderColor, lineWidth: 2))
                .padding(7)

            Image("art_delimiter3")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 250, height: 20)

            Text(tarotReader.name)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 5)

            Text("Сделано раскладов: \(tarotReader.readingsCount)")
                .font(.subheadline)
                .foregroundColor(.gray)

            HStack {
                Image(systemName: tarotReader.isOnline ? "circle.fill" : "circle")
                    .foregroundColor(tarotReader.isOnline ? .green : .red)
                    .overlay(
                        tarotReader.isOnline ?
                        Circle()
                            .stroke(Color.green, lineWidth: isOnlineAnimation ? 10 : 0)
                            .scaleEffect(isOnlineAnimation ? 1.3 : 1.0)
                            .opacity(isOnlineAnimation ? 0 : 0.7)
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: false)) {
                                    isOnlineAnimation.toggle()
                                }
                            } : nil
                    )

                Text(tarotReader.isOnline ? "В сети" : "Не в сети")
                    .font(.subheadline)
                    .foregroundColor(tarotReader.isOnline ? .green : .red)
                    .padding(.leading, 5)
            }

            Text("Рейтинг: \(tarotReader.rating)")
                .font(.subheadline)
                .foregroundColor(.orange)
        }
        .onAppear {
            isOnlineAnimation.toggle()
            animateBorderColorTarologImage()
        }
        .frame(width: UIScreen.main.bounds.width - 32, height: 350)
        .background(Image("BGimg"))
        .cornerRadius(10)
        .shadow(radius: 5)

    }

    func animateBorderColorTarologImage() {
        withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
            borderColor = .yellow
        }
    }
}



struct Tarologs: View {
    let tarotReaders: [TarotReader] = [
        TarotReader(name: "Joan", photo: "face1", readingsCount: 50, isOnline: true, rating: 4),
        TarotReader(name: "Jane Smith", photo: "face1", readingsCount: 30, isOnline: false, rating: 5),
        TarotReader(name: "Jane Smith", photo: "face1", readingsCount: 30, isOnline: true, rating: 5),
        TarotReader(name: "Jane Smith", photo: "face1", readingsCount: 30, isOnline: false, rating: 5),
        TarotReader(name: "Jane Smith", photo: "face1", readingsCount: 30, isOnline: true, rating: 5),
        TarotReader(name: "Jane Smith", photo: "face1", readingsCount: 30, isOnline: false, rating: 5),
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 1), spacing: 25) {
                    ForEach(tarotReaders) { tarotReader in
                        NavigationLink(
                            destination: TarotSpread(),
                            label: {
                                TarotReaderCell(tarotReader: tarotReader)
                            }
                        )
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
            }
            .background(
                Image(returnBackground())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
            .navigationBarHidden(true)

        }
    }

    func returnBackground() -> String {
        return ["1","2","3","4","5","6"].randomElement()!
    }
}

#Preview {
    Tarologs()
}
