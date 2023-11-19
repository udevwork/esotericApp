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

class TarologsModel: ObservableObject {
    
    @Published var tarotReaders: [TarotReader] = [
        TarotReader(name: "Joan", photo: "face1", readingsCount: 50, isOnline: true, rating: 4),
        TarotReader(name: "Jane Smith", photo: "face1", readingsCount: 30, isOnline: false, rating: 5),
        TarotReader(name: "Jane Smith", photo: "face1", readingsCount: 30, isOnline: true, rating: 5),
        TarotReader(name: "Jane Smith", photo: "face1", readingsCount: 30, isOnline: false, rating: 5),
        TarotReader(name: "Jane Smith", photo: "face1", readingsCount: 30, isOnline: true, rating: 5),
        TarotReader(name: "Jane Smith", photo: "face1", readingsCount: 30, isOnline: false, rating: 5),
    ]

    init() {
       
      
    }
}


struct TarotReaderCell: View {
    
    var tarotReader: TarotReader
    @State private var isOnlineAnimation = false
    @State private var borderColor: Color = .white

    var body: some View {
        VStack {
            VStack(spacing: 15) {
                ZStack {
                    Image(tarotReader.photo)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 180, height: 180)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(borderColor, lineWidth: 2))
                        .padding(7)
                    Image("avatar_border")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 180, height: 180)
                        .opacity(0.6)
            
                        HStack {
                            HStack(spacing:0) {
                                Image(systemName: tarotReader.isOnline ? "circle.fill" : "circle")
                                    .scaleEffect(0.6)
                                    .foregroundColor(tarotReader.isOnline ? .green : .red)
                                    .overlay(
                                        tarotReader.isOnline ?
                                        Circle()
                                            .stroke(Color.green, lineWidth: isOnlineAnimation ? 10 : 0)
                                            .scaleEffect(isOnlineAnimation ? 0.9 : 0.6)
                                            .opacity(isOnlineAnimation ? 0 : 0.7)
                                            .onAppear {
                                                withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: false)) {
                                                    isOnlineAnimation.toggle()
                                                }
                                            } : nil
                                    )
                                
                                Text(tarotReader.isOnline ? "В сети" : "Не в сети")
                                    .font(.footnote)
                                    .foregroundColor(tarotReader.isOnline ? .green : .red)
                                    .padding(.leading, 5)
                            }.padding(EdgeInsets(top: 5, leading: 6, bottom: 5, trailing: 14))
                            
                        }.background(.ultraThinMaterial).cornerRadius(16)
         
                            .overlay(
                                RoundedRectangle(cornerRadius: 16).stroke(Color.borderColor, lineWidth: 1))
                            .offset(x: 80, y: -60)
                    

                }
                
                SectionTitleView(textColor: .accent, text: tarotReader.name, alignment: .center)
                Image("art_delimiter3")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .padding(.horizontal, 40)
                
                
                VStack(spacing: 0) {
                    Text("Рейтинг: \(tarotReader.rating)")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                    Text("Сделано раскладов: \(tarotReader.readingsCount)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                   
                }
                
                NavigationLink(destination: TarotSpread()) {
                    Text("Заказать расклад").bold().foregroundColor(.white)
                }.frame(height: 10).DefButtonStyle()
                
             
            }.padding(.vertical,60)
                .padding(.horizontal, 40)
        }
        .onAppear {
            isOnlineAnimation.toggle()
            animateBorderColorTarologImage()
        }
        .background(TarotReaderBackGroundView())
        .cornerRadius(40)
        .shadow(radius: 5)

    }

    func animateBorderColorTarologImage() {
        withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
            borderColor = .yellow
        }
    }
}



struct Tarologs: View {
  
    @StateObject var model = TarologsModel()

    var body: some View {
            ScrollView {
                HStack {
                    Spacer()
                    VStack(spacing: -10) {
                        H1TitleView(textColor: .accentColor,text: "Тарологи", alignment: .center)
                        ArticleView(text: "Запросить расклад прямо сейчас!", alignment: .leading).opacity(0.6)
                    }.offset(y: -15)
                    Spacer()
                }
                
                ScreenContentView(color: .clear) {
               
                        VStack(alignment: .leading, spacing: 8) {
                            SectionTitleView(textColor: .white, text: "Есть вопросы?", alignment: .leading)
                              
                            Button {
                                
                            } label: {
                                Text("Напиши нам!")
                            }.DefButtonStyle()
                        }.padding(.horizontal, 40)
                    
                      .background {
                        Image("Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .opacity(0.2)
                            .scaleEffect(0.9)
                            .offset(x: 140, y: -60.0)
                    }

                }
                
                LazyVGrid(columns: Array(repeating: GridItem(), count: 1), spacing: 25) {
                    ForEach(model.tarotReaders) { tarotReader in
                        
                        TarotReaderCell(tarotReader: tarotReader)
                        
                        
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
            }.background(BackGroundView())

        
    }

    func returnBackground() -> String {
        return ["1","2","3","4","5","6"].randomElement()!
    }
}

#Preview {
    NavigationStack {
        Tarologs()
    }.preferredColorScheme(.dark)
        
}
