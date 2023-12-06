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
    @Published var showingSheet = false
   
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            if DayConterService().getDayStreak() == 0 {
                self.showingSheet.toggle()
            }
        })
    }
}

struct HomeView: View {
    
    @Environment(\.openURL) var openURL
    @StateObject var model: HomeModel = HomeModel()
            
    init() {
        
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack (alignment: .leading, spacing: 40) {
                
                HStack {
                    Spacer()
                    VStack(spacing: -1) {
                        Image("home_header_logo").resizable().frame(width: 120, height: 60)
                        H1TitleView(textColor: .accentColor,text: "TAROT", alignment: .center)
                        Image("art_delimiter9").resizable().aspectRatio(contentMode: .fit).offset(y: -6).frame(height: 10)
                        ArticleView(text: "\(Texts.HomeView.cardOfDayCounter1) \(DayConterService().getDayStreak()) \(Texts.HomeView.cardOfDayCounter2)", alignment: .center).bold()
                    }
                    Spacer()
                }
                
                HorMenuSnap(openSubscriptionSheet: $model.showingSheet)
                if let reader = StorageService.shared.loadQuestion(key: SavingKeys.question.rawValue) {
                    TarotReaderResponseBanner(tarotReady: reader.time <= Date() )
                }
                WidgetBunner()
                SubscriptionBanner(showingSheet: $model.showingSheet)
                ConditionsTermsView()
            }
        }.background(BackGroundView())
            .navigationBarHidden(true)
            .sheet(isPresented: $model.showingSheet) {
                SubscriptionView()
            }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView().preferredColorScheme(.dark)
        }.transition(.opacity)
    }
}
