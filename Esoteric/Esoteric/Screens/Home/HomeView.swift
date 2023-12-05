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
    let gpt = GPTService()
    init() {
      
    }
}

struct HomeView: View {
    
    @Environment(\.openURL) var openURL
    @StateObject var model: HomeModel = HomeModel()
    @State private var showingSheet = false
    
    @State var testTest: String = "test request"
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack (alignment: .leading, spacing: 40) {
                TopLogoBanner()
                HorMenuSnap(openSubscriptionSheet: $showingSheet)
                TarotReaderResponseBanner()
                WidgetBunner()
                SubscriptionBanner(showingSheet: $showingSheet)
                ConditionsTermsView()
                Button {
                    model.gpt.test { result in
                        switch result {
                            case .success(let success):
                                testTest = success
                            case .failure(let failure):
                                testTest = failure.localizedDescription
                        }
                    }
                } label: {
                    Text(testTest)
                }

            }
        }.background(BackGroundView())
            .navigationBarHidden(true)
            .sheet(isPresented: $showingSheet) {
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
