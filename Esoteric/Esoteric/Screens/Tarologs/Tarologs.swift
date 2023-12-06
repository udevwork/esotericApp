//
//  Tarologs.swift
//  Esoteric
//
//  Created by Alex on 11.11.2023.
//

import SwiftUI
import SwiftDate

struct TarotReader: Identifiable {
    
    var id = UUID()
    var name: String
    var photo: String
    var rating: Int
    // isMorning, isAfternoon ,isEvening, isNight
    var workTime: DateComparisonType
    
    internal init(_ name: String,_ photo: String, rating: Int, workTime: DateComparisonType) {
        self.name = name
        self.photo = photo
        self.rating = rating
        self.workTime = workTime
    }
    
    func isOnline() -> Bool {
        return Date().compare(workTime)
    }
}

class TarologsModel: ObservableObject {
    
    @Published var tarotReaders: [TarotReader] = [
        TarotReader(Texts.TarotReadesNames.ariana, "tarot-reader-12", rating: 4, workTime: .isMorning),
        TarotReader(Texts.TarotReadesNames.serena, "tarot-reader-11", rating: 4, workTime: .isMorning),
        TarotReader(Texts.TarotReadesNames.isabella, "tarot-reader-9", rating: 4, workTime: .isEvening),
        TarotReader(Texts.TarotReadesNames.viviana, "tarot-reader-8", rating: 3, workTime: .isEvening),
        TarotReader(Texts.TarotReadesNames.margot, "tarot-reader-7", rating: 5, workTime: .isEvening),
        TarotReader(Texts.TarotReadesNames.elizabeth, "tarot-reader-6", rating: 5, workTime: .isAfternoon),
        TarotReader(Texts.TarotReadesNames.theodora, "tarot-reader-5", rating: 4, workTime: .isAfternoon),
        TarotReader(Texts.TarotReadesNames.aurelia, "tarot-reader-4", rating: 5, workTime: .isAfternoon),
        TarotReader(Texts.TarotReadesNames.sabina, "tarot-reader-3", rating: 4, workTime: .isNight),
        TarotReader(Texts.TarotReadesNames.juliana, "tarot-reader-2", rating: 3, workTime: .isNight),
        TarotReader(Texts.TarotReadesNames.lorena, "tarot-reader-1", rating: 5, workTime: .isNight),
        TarotReader(Texts.TarotReadesNames.evelina, "tarot-reader-0", rating: 5, workTime: .isNight)
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
                                Image(systemName: tarotReader.isOnline() ? "circle.fill" : "circle")
                                    .scaleEffect(0.6)
                                    .foregroundColor(tarotReader.isOnline() ? .green : .red)
                                    .overlay(
                                        tarotReader.isOnline() ?
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
                                
                                Text(tarotReader.isOnline() ? Texts.TarologsView.onLine : Texts.TarologsView.offLine)
                                    .font(.footnote)
                                    .foregroundColor(tarotReader.isOnline() ? .green : .red)
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
                    Text("\(Texts.TarologsView.rating): \(tarotReader.rating)")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                }
                
                NavigationLink(destination: TarotSpread()) {
                    Text(Texts.TarologsView.getSpread).bold().foregroundColor(.white)
                }.frame(height: 10).DefButtonStyle()
                    .disabled(!tarotReader.isOnline())
                
             
            }.padding(.vertical,60)
                .padding(.horizontal, 40)
        }
        .onAppear {
            isOnlineAnimation.toggle()
            animateBorderColorTarologImage()
        }
        .background(TarotReaderBackGroundView())
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.borderColor, lineWidth: 4))
        .padding(.horizontal, 8)

    }

    func animateBorderColorTarologImage() {
        withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
            borderColor = .yellow
        }
    }
}



struct Tarologs: View {
    @Environment(\.openURL) var openURL
    @StateObject var model = TarologsModel()

    var body: some View {
            ScrollView {
                HStack {
                    Spacer()
                    VStack(spacing: -10) {
                        H1TitleView(textColor: .accentColor,text: Texts.TarologsView.tarologs, alignment: .center)
                        ArticleView(text: Texts.TarologsView.spreadRightNow, alignment: .leading).opacity(0.6)
                    }.offset(y: -15)
                    Spacer()
                }
                
                ScreenContentView(color: .clear) {
               
                        VStack(alignment: .leading, spacing: 8) {
                            SectionTitleView(textColor: .white, text: Texts.HomeView.haveAQuestion, alignment: .leading)

                            Button {
                                if let url = URL(string: "telegram".remote()) {
                                    openURL(url)
                                }
                            } label: {
                                Text(Texts.TarologsView.writeUs)
                            }.DefButtonStyle()
                        }
                    
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
                    ForEach(model.tarotReaders.sorted(by: { $0.isOnline() && !$1.isOnline() })) { tarotReader in
                        TarotReaderCell(tarotReader: tarotReader)
                    }
                }
             
                .padding()
            }.background(BackGroundView())

        
    }

}

#Preview {
    NavigationStack {
        Tarologs()
    }.preferredColorScheme(.dark)
}
