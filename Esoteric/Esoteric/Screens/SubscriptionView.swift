
//case day = 0
///// A subscription period unit of a week.
//case week = 1
///// A subscription period unit of a month.
//case month = 2
///// A subscription period unit of a year.
//case year = 3

import SwiftUI
import RevenueCat
import AlertToast

struct SubscriptionView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var showLoading: Bool = false
    @State var priceText: String = "€ 2,99"
    @State var periodText: String = Texts.Coast.week
    @State var productTitle: String = Texts.Coast.weekSubt
    @State var productDescription: String = ""
    
    init() {
        
    }
    
    func setup(){
        guard let product = PurchasesHelper.storeProduct,
              let period = product.subscriptionPeriod else { return }
        
        productTitle = product.localizedTitle // "Weakly subscription "
        productDescription = product.localizedDescription // "Get access to premium user paid features!"
        priceText = product.localizedPriceString // "€ 2,99"
        periodText = period.periodToText().uppercased() // "week"
        
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Image("subscription_bg_top")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .ignoresSafeArea()
            VStack(alignment: .center ,spacing: 0) {
                
                ZStack{
                    VStack(alignment: .center) {
                        H1TitleView(textColor: .accentColor, text: "\(Texts.SubscriptionView.premium)", alignment: .center).frame(height: 30)
                        SubSectionTitleView(text: productDescription, alignment: .center)
                        Image("art_delimiter7").resizable().aspectRatio(contentMode: .fit).frame(height: 10)
                    }
                    
                }.padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
                
                
                
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(Texts.SubscriptionView.premiumWhatYoure)
                                .font(.custom("ElMessiri-Bold", size: 22))
                                .foregroundColor(.accent)
                            Text(Image(systemName: "star.fill")) +
                            Text(Texts.SubscriptionView.premiumDiffSpread).bold()
                            Text(Image(systemName: "star.fill")) +
                            Text(Texts.SubscriptionView.premiumExclusive).bold()
                            Text(Image(systemName: "star.fill")) +
                            Text(Texts.SubscriptionView.premiumWeekly).bold()
                        }
                        
                        HStack {
                            Text(priceText)
                                .multilineTextAlignment(.center)
                                .frame(alignment: .center)
                                .font(.custom("ElMessiri-Bold", size: 50))
                            Rectangle().foregroundColor(.textColor).frame(width: 2, height: 40, alignment: .center)
                                .rotationEffect(Angle(degrees: 10))
                            VStack(alignment: .leading) {
                                Text(Texts.SubscriptionView.per).font(.system(.body, design: .monospaced, weight: .heavy))
                                Text(periodText).font(.system(.title3, design: .monospaced, weight: .heavy))
                            }
                        }.frame(height: 50)
                            .offset(y:-20)
                        
                        Button {
                            showLoading = true
                            User.shared.subscribe { success in
                                showLoading = false
                            }
                        } label: {
                            Text("Купить Подписку").font(.custom("ElMessiri-Bold", size: 26)).padding(10)
                        }.ProButtonStyle()
                        
                        Text("Все совпадения - случайность.")
                            .multilineTextAlignment(.center)
                            .font(.system(.footnote, design: .rounded, weight: .medium))
                            .foregroundColor(.textColor)
                        
                    }.foregroundColor(.white)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 30)
                }

                ConditionsTermsView()
                
            }
            
            Image("subscription_bg_bottom")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .ignoresSafeArea()
            
        }.background(SubscriptionBackGroundView())
            .onAppear{
                setup()
                AnalyticsWrapper.onScreanAppear("Subscription")
            }
            .toast(isPresenting: $showLoading) {
                AlertToast(type: .loading)
            }
    }
}


#Preview {
    SubscriptionView().preferredColorScheme(.dark)
}
