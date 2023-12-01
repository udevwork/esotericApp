import SwiftUI
import AlertToast

struct SubscriptionView: View {
    @Environment(\.dismiss) var dismiss
    @State var showLoading: Bool = false
    @State var productDescription: String = ""
    
    func setup(){
        guard let product = PurchasesHelper.storeProduct else { return }
        productDescription = product.localizedDescription
        AnalyticsWrapper.onScreanAppear("Subscription")
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ResizebleImage("subscription_bg_top")
            VStack(alignment: .center, spacing: 20) {
                TopGrandTitle(title: Texts.SubscriptionView.premium, subtitle: productDescription)
                AdvantagesBanner()
                SubscriptionPriceBunner()
                SubscribeButton(process: $showLoading)
                BillingTextNoteBanner()
            }.padding(.horizontal, 30)
            ConditionsTermsView()
            ResizebleImage("subscription_bg_bottom")
        }.background(SubscriptionBackGroundView())
            .onAppear(perform: setup)
            .toast(isPresenting: $showLoading) { AlertToast(type: .loading) }
    }
}

#Preview {
    SubscriptionView().preferredColorScheme(.dark)
}
