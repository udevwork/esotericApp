//
//  HomeView.swift
//  esotericApp
//
//  Created by Denis Kotelnikov on 03.11.2023.
//

import Foundation
import SwiftUI
import Combine
import Shiny

class HomeModel: ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    var gpt = GPTService()

    init() {
        User.shared.$isProUser.sink {_ in
            self.objectWillChange.send()
        }.store(in: &subscriptions)
        gpt.test(promt: "Придумай мне гороскоп на день. Пара предложений.") { result in
            print(result)
        }
    }
}

struct HomeView: View {

    @Environment(\.openURL) var openURL
    @EnvironmentObject var mainModel: MainViewModel
    @StateObject var model: HomeModel = HomeModel()
    @Namespace private var namespace
    @State private var showingSheet = false
    @State var animate: Bool = false
    @State var finish: Bool = false

    var body: some View {
        ZStack {
            if animate == false {
                ScrollView(.vertical, showsIndicators: false) {
              
                    Image("home_header_logo").resizable().frame(width: 120, height: 60)
                    VStack (alignment: .leading, spacing: 40) {
                        
                        HStack {
                            Spacer()
                            VStack(spacing: -10) {
                                H1TitleView(textColor: .accentColor,text: "Tarot", alignment: .center)
                                ArticleView(text: "Вселенная у вас в кармане", alignment: .leading).opacity(0.6)
                            }.offset(y: -15)
                            Spacer()
                        }
                        
                        HorMenuSnap()
                        
                        if User.shared.isProUser == false {
                            ScreenContentView(color: .clear) {
                                VStack(alignment: .leading, spacing: 28) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        SectionTitleView(textColor: .white, text: "Гадание по одной карте", alignment: .leading)
                                            .padding(.horizontal, horPadding)
                                        ArticleView(textColor: .white, text: "самое четкое, поскольку не позволит вам отвлечься на посторонние мысли и идеи.").padding(.horizontal, horPadding)
                                    }
                                 
                                    Button {
                                        showingSheet.toggle()
                                    } label: {
                                        Text("Подписка")
                                    }.DefButtonStyle()
                                        .sheet(isPresented: $showingSheet) {
                                            SubscriptionView()
                                        }
                                        .padding(.horizontal, horPadding)
                                }.background {
                                    Image("esoteric")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .opacity(0.1)
                                        .scaleEffect(0.9)
                                }
                            }
                        }
                        VStack(alignment: .leading,spacing: 10) {
                            SectionTitleView(text: "Прогноз на будущее", alignment: .leading)

                            ArticleView(text: "Работа, отношения, путешествие, покупка, продажа и т.д", alignment: .leading)
                        }.padding(.horizontal,35)
                        ScreenContentView(color: .clear) {
                            VStack(alignment: .leading, spacing: 20) {
                                VStack(alignment: .leading, spacing: 8) {
                                    SectionTitleView(textColor: .white, text: "Есть вопросы?", alignment: .leading)
                                        .padding(.horizontal, horPadding)
                                }
                                Button {
                                    if let url = URL(string: "https://t.me/imbalanceFighter") {
                                        openURL(url)
                                    }
                                } label: {
                                    Text("Напиши нам!")
                                }.DefButtonStyle()
                                    .sheet(isPresented: $showingSheet) {
                                        SubscriptionView()
                                    }
                                    .padding(.horizontal, horPadding)
                            }.background {
                                Image("Logo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .opacity(0.2)
                                    .scaleEffect(0.9)
                            }

                        }
                        ConditionsTermsView()
                    }

                }.background(BackGroundView())
                    .navigationBarHidden(true)
                    .onAppear {
                        AnalyticsWrapper.onScreanAppear("Home")
                    }
                
            } else {

                SectionTitleView(text: "kjk", alignment: .leading)

            }
        }.animation(Animation.easeInOut(duration: 0.25), value: animate)

    }
}

struct HomeView_Previews: PreviewProvider {
    @StateObject static var model = MainViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    static var previews: some View {
        ZStack {
            NavigationStack {
                HomeView()
                    .environmentObject(model)
            }.transition(.opacity)

        }.preferredColorScheme(.dark)
            .animation(.easeInOut, value: model.screenTransitionAnimation)
    }
}
