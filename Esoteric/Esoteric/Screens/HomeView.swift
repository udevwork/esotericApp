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
              
                   
                    VStack (alignment: .leading, spacing: 40) {
                        
                        HStack {
                            Spacer()
                            VStack(spacing: -1) {
                                Image("home_header_logo").resizable().frame(width: 120, height: 60)
                                H1TitleView(textColor: .accentColor,text: "ESOTERICA", alignment: .center)
                                Image("art_delimiter9").resizable().aspectRatio(contentMode: .fit).offset(y: -6).frame(height: 10)
                                ArticleView(text: "\(Texts.HomeView.cardOfDayCounter1) \(DayConterService().getDayStreak()) \(Texts.HomeView.cardOfDayCounter2)", alignment: .leading).bold()
                            }
                            Spacer()
                        }
                  
                        HorMenuSnap()
                        
                        if User.shared.isProUser == false {
                            
                            if let reader = StorageService.shared.loadQuestion(key: SavingKeys.question.rawValue) {
                                ScreenContentView(color: .clear) {
                                    VStack(alignment: .leading, spacing: 28) {
                                        
                                        if reader.time <= Date() {
                                            VStack(alignment: .leading, spacing: 8) {
                                                HStack {
                                                    Image("Vector-1").resizable().aspectRatio(contentMode: .fit).frame(height: 140)
                                                }.frame(maxWidth: .infinity)
                                                SectionTitleView(textColor: .white, text: Texts.HomeView.spreadReady, alignment: .leading)
                                                Image("art_delimiter8").resizable().aspectRatio(contentMode: .fill)
                                                ArticleView(textColor: .white, text: Texts.HomeView.seeSpreadReady)
                                            }
                                            NavigationLink {
                                                CardsTableView(model: CardsTableViewModel(deckType: .TarotReader))
                                            } label: {
                                                Text(Texts.HomeView.spreadReadyRead)
                                            }.DefButtonStyle()
                                        } else {
                                            VStack(alignment: .leading, spacing: 8) {
                                                SectionTitleView(textColor: .white, text: Texts.HomeView.spreadInProgress, alignment: .leading)
                                                    .padding(.horizontal, horPadding)
                                                Image("art_delimiter8").resizable().aspectRatio(contentMode: .fill)
                                                ArticleView(textColor: .white, text: Texts.HomeView.weSendNotification).padding(.horizontal, horPadding)
                                            }
                                        }
                                       
                                        
                                        
                                    }.background {
                                        Image("ScreenContentViewBG")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .opacity(0.3)
                                            .scaleEffect(1.1)
                     
                                    }
                                }
                            }
                            
                            ScreenContentView(color: .clear) {
                                VStack(alignment: .leading, spacing: 28) {
                                        VStack(alignment: .leading, spacing: 8) {
                                            SectionTitleView(textColor: .white, text: Texts.HomeView.widgets, alignment: .leading)
                                            Image("art_delimiter8").resizable().aspectRatio(contentMode: .fill)
                                            ArticleView(textColor: .white, text: Texts.HomeView.widgetsSubTittle)
                                        }
                                       
                                }.background {
                                    Image("ScreenContentViewBG")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .opacity(0.3)
                                        .scaleEffect(1.1)
                                }
                            }
                            
                            ScreenContentView(color: .clear) {
                                VStack(alignment: .leading, spacing: 28) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Image("Vector").resizable().aspectRatio(contentMode: .fit).frame(height: 140)
                                        }.frame(maxWidth: .infinity)
                                        SectionTitleView(textColor: .white, text: Texts.HomeView.subscipt, alignment: .leading)
                                        Image("art_delimiter8").resizable().aspectRatio(contentMode: .fill)
                    
                                        ArticleView(textColor: .white, text: Texts.HomeView.subsciptSubTittle)
                                    }
                                    
                                    Button {
                                        Haptics.shared.play(.medium)
                                        showingSheet.toggle()
                                    } label: {
                                        Text("Подписка")
                                    }.DefButtonStyle()
                                        .sheet(isPresented: $showingSheet) {
                                            SubscriptionView()
                                        }
                                       
                                }
                            }
                        }
                   
                       
                        ConditionsTermsView()
                    }

                }.background(BackGroundView())
                    .navigationBarHidden(true)
                    .onAppear {
                        AnalyticsWrapper.onScreanAppear("Home")
                    }
                    .sheet(isPresented: $showingSheet) {
                        SubscriptionView()
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
