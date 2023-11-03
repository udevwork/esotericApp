//
//  OnboardingView.swift
//  esotericApp
//
//  Created by Denis Kotelnikov on 03.11.2023.
//

import Foundation
import SwiftUI

struct OnboardingView: View {
    typealias Page = OnboardingPageView
    @EnvironmentObject var model: MainViewModel
    
    let tabs: [(String, String, String, Int)] = [
        ("animation1",
         "L_Onboard_Title_1",
         "L_Onboard_SubTitle_1", 0),
        ("animation2",
         "L_Onboard_Title_2",
         "L_Onboard_SubTitle_2", 1),
        ("animation3",
         "L_Onboard_Title_3",
         "L_Onboard_SubTitle_3", 2)
    ]
    
    var body: some View {
        OnboardingTabsView {
            ForEach(tabs, id: \.3) { Page($0) }
        }.environmentObject(model)
    }
}

struct OnboardingTabsView<Content: View>: View {
    @ViewBuilder let content: Content
    
    @EnvironmentObject var model: MainViewModel
    @State private var selectedTab = 0
    @State private var buttonText = "L_NEXT"
    
    var body: some View {
        VStack() {
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    content
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                
                HStack {
                    Spacer()
                    Button(action: buttonPressed) {
                        Text(buttonText)
                    }.BlueButtonStyle()
                }.padding(.horizontal, 30)
            }
        }
        .onChange(of: selectedTab, perform: change)
        .onAppear(perform: exampleFunction())
        .background(BGColor)
    }
    
    private func exampleFunction() -> (() -> Void)? {
        return {
            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(hex: "5A9CFF")!
            UIPageControl.appearance().pageIndicatorTintColor = UIColor(hex: "5A9CFF")!.withAlphaComponent(0.2)
            AnalyticsWrapper.onScreanAppear("Onboarding")
        }
    }
 
    private func change(newValue: (any Equatable)) {
        if (newValue as! Int) < 2 {
            buttonText = "L_NEXT"
        }
        if (newValue as! Int) == 2 {
            buttonText = "L_FINISH"
        }
    }
    
    private func buttonPressed() {
        if selectedTab == 2 {
            UserDefaults.standard.set(true, forKey: "OnboardingWasShowed")
 
                model.needToPresentOnboarding = false
                model.screenTransitionAnimation.toggle()
            
            return
        }
        
        var _temp = selectedTab
        
        if _temp < 2 {
            _temp += 1
            withAnimation {
                selectedTab = _temp
            }
        }
    }
}

struct OnboardingPageView: View {
    public var index: Int
    public var imageName: String
    public var title: String
    public  var subtitle: String
    private var size = UIScreen.main.bounds.width/1.2
    
    public init(_ tuple: (String, String, String, Int)) {
        self.imageName = tuple.0
        self.title = tuple.1
        self.subtitle = tuple.2
        self.index = tuple.3
    }
    
    var body: some View {
        VStack(alignment:.center, spacing: 10) {
            Image(imageName)
                .opacity(0.5)
                .frame(width: size, height: size)
            VStack(alignment:.center, spacing: 20) {
                SectionTitleView(text: title, alignment: .center)
                ArticleView(text: subtitle, alignment: .center)
            }.padding(.vertical, 30)
                .padding(.horizontal, 20)
                .LightGrayViewStyle()
            Spacer()
        }.padding(35).tag(index)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView().environmentObject(MainViewModel())
    }
}
