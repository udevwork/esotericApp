//
//  HomeView.swift
//  esotericApp
//
//  Created by Denis Kotelnikov on 03.11.2023.
//

import Foundation
import SwiftUI
import Combine

class HomeModel: ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    
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
                    
                    Image("homescreenheader")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: 30)
                    
                    VStack (alignment: .leading, spacing: 20) {
                        
                            HStack(spacing: 16) {
                                EmodjiIcon(iconText: "👋")
                                VStack(alignment: .leading, spacing: 1) {
                                    SectionTitleView(text: "L_HomeSectionCreateTitle", alignment: .leading)
                                    ArticleView(text: "L_HomeSectionCreateSubtitle", alignment: .leading)
                                }
                            }.padding(.horizontal,16)
                        
                      
                        
                        if User.shared.isProUser == false {
                            ScreenContentView(color: .buttonBlue) {
                         
                                    VStack(alignment: .leading, spacing: 28) {
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            SectionTitleView(textColor: .white, text: "L_HomeSectionMainTitle", alignment: .leading)
                                                .padding(.horizontal, horPadding)
                                            
                                            ArticleView(textColor: .white, text: "L_HomeSectionMainSubtitle").padding(.horizontal, horPadding)
                                        }
                                        Button {
                                            showingSheet.toggle()
                                        } label: {
                                            Text("L_PremiumUppercase")
                                        }.WhiteButtonStyle()
                                            .sheet(isPresented: $showingSheet) {
                                                SubscriptionView()
                                            }
                                            .padding(.horizontal, horPadding)
                                    }.background {
                                        Image("whiteFigures")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .opacity(0.4)
                                            .scaleEffect(0.9)
                                    }
                                
                            }
                          
                        }
                        
                    
                            
                            
                            VStack(alignment: .leading,spacing: 10) {
                                SectionTitleView(text: "L_HomeAuthorWeLove", alignment: .leading)
                                
                                ArticleView(text: "L_HomeExploreAuthor", alignment: .leading)
                            }.padding(.horizontal,16)
                            if let git = mainModel.git {
                              //  FavoriteCreatorsView(creators: git.favoriteCreators)
                            }
                            
                            SectionTitleView(text: "L_HomeSectionTemplates", alignment: .leading)
                                .padding(.horizontal,16)
                            
                        
                        
                 
                        ScreenContentView(color: .buttonBlue) {
                     
                                VStack(alignment: .leading, spacing: 20) {
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        SectionTitleView(textColor: .white, text: "L_HaveQuastions", alignment: .leading)
                                            .padding(.horizontal, horPadding)
                               
                                    }
                                    Button {
                                        if let url = URL(string: "https://t.me/imbalanceFighter") {
                                            openURL(url)
                                        }
                                    } label: {
                                        Text("L_MailToTelegram")
                                    }.WhiteButtonStyle()
                                        .sheet(isPresented: $showingSheet) {
                                            SubscriptionView()
                                        }
                                        .padding(.horizontal, horPadding)
                                }.background {
                                    Image("emailus")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .opacity(0.4)
                                        .scaleEffect(0.9)
                                }
                            
                        }
                        
                    
                            ConditionsTermsView()
                        
                    }
                    
                }  .background(BGColor)
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
            
        }.preferredColorScheme(.light)
            .animation(.easeInOut, value: model.screenTransitionAnimation)
    }
}
