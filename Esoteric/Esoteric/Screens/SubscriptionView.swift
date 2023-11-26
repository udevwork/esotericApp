
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
    @State var periodText: String = "WEEK"
    @State var productTitle: String = "Weakly subscription"
    @State var productDescription: String = "Get access to premium user paid features!"
    
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
            
            VStack(alignment: .center ,spacing: 20) {
                
                ZStack{
                    VStack(alignment: .center) {
                        H1TitleView(textColor: .accentColor, text: "\("ПРЕМИУМ")", alignment: .center).frame(height: 30)
                            
                        Image("art_delimiter7").resizable().aspectRatio(contentMode: .fit).frame(height: 10)
                        SubSectionTitleView(text: productDescription, alignment: .center)
                    }
//                    HStack() {
//                        Spacer()
//                        Button {
//                            dismiss()
//                        } label: {
//                            Image(systemName: "xmark.circle.fill")
//                                .resizable()
//                                .frame(width: 20, height: 20, alignment: .center)
//                                .opacity(0.3)
//                        }
//                    }
                }.padding(EdgeInsets(top: 160, leading: 0, bottom: 0, trailing: 0))
                
              
                   
                VStack(spacing: 30) {
                    VStack(spacing: 10) {
                        ArticleView(text: """
🔮 Что тебя ждет:

✨ Разнообразные расклады: от любовных до карьерных - выбирай то, что трогает твою душу.

✨ Эксклюзивные интерпретации: узнай глубинный смысл каждой карты от наших экспертов по таро.

✨ Ежедневные прогнозы: держи руку на пульсе своей судьбы с персонализированными прогнозами каждый день.

""", alignment: .leading).bold()
         
                    }.padding(.horizontal,20)
                    HStack {

                        Text(priceText)
                            .multilineTextAlignment(.leading)
                            .frame(alignment: .leading)
                            .font(.system(size: 50, weight: .heavy, design: .rounded))
                            
                        
                        Rectangle().foregroundColor(.textColor).frame(width: 4, height: 40, alignment: .center)
                        
                        VStack(alignment: .leading) {
                            Text("L_PER").font(.system(.body, design: .monospaced, weight: .heavy))
                            Text(periodText).font(.system(.title3, design: .monospaced, weight: .heavy))
                        }
                        
                    }.foregroundColor(.white)
                        .padding(.vertical, 70)
                        .padding(.horizontal, 60)
                        .background(TarotReaderBackGroundView())
                        .cornerRadius(20)
                        .shadow(radius: 20)
                    
                }
                
                Button {
                   
                    showLoading = true

                    User.shared.subscribe { success in
                        showLoading = false
                    }
                
                    
                } label: {
                    Text("Купить сейчас")
                }.DefButtonStyle()


                
                Text("Нам вообще все всеравно что там у вас случилось. Все совпадения - случайность.")
                    .multilineTextAlignment(.center)
                    .font(.system(.footnote, design: .rounded, weight: .medium))
                    .foregroundColor(.textColor)
                
                
                ConditionsTermsView()
            }.padding(5)
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
    SubscriptionView()
}
