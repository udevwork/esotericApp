
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
                        SectionTitleView(text: "\("L_PremiumUppercase")", alignment: .center)
                        SubSectionTitleView(text: productDescription, alignment: .center)
                    }
                    HStack() {
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20, alignment: .center)
                                .opacity(0.3)
                        }
                    }
                }
                
              
                   
                VStack(spacing: 30) {
                    
                    ArticleView(text: "L_SubscribtionDescription", alignment: .leading).bold()
                    
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
                        
                    }.foregroundColor(.textColor)
                        .LightGrayViewStyle()
                }
                
                Button {
                   
                    showLoading = true

                    User.shared.subscribe { success in
                        showLoading = false
                    }
                
                    
                } label: {
                    Text("L_TryItForFreeLabel")
                }.BlueButtonStyle().lightShadow()


                
                Text("L_SubscribtionDetails")
                    .multilineTextAlignment(.center)
                    .font(.system(.footnote, design: .rounded, weight: .medium))
                    .foregroundColor(.textColor)
                
                
                ConditionsTermsView()
            }.padding(35)
        }.background(BGColor)
            .onAppear{
                setup()
                AnalyticsWrapper.onScreanAppear("Subscription")
            }
            .toast(isPresenting: $showLoading) {
                AlertToast(type: .loading)
            }
    }
    

    
}
