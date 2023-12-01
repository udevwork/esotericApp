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
    init() {
      
    }
}

struct HomeView: View {
    
    @Environment(\.openURL) var openURL
    @StateObject var model: HomeModel = HomeModel()
    @State private var showingSheet = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack (alignment: .leading, spacing: 40) {
                TopLogoBanner()
                HorMenuSnap(openSubscriptionSheet: $showingSheet)
                TarotReaderResponseBanner()
                WidgetBunner()
                SubscriptionBanner(showingSheet: $showingSheet)
                ConditionsTermsView()
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
