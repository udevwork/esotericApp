import SwiftUI

struct SubscriptionPriceBunner: View {
    
    @State var priceText: String = "€ 2,99"
    @State var periodText: String = Texts.Coast.week
    
    func getPrice() {
        guard let product = PurchasesHelper.storeProduct,
              let period = product.subscriptionPeriod else { return }
        priceText = product.localizedPriceString // "€ 2,99"
        periodText = period.periodToText().uppercased() // "week"
    }
    
    var body: some View {
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
            .onAppear(perform: getPrice)
    }
}

#Preview {
    SubscriptionPriceBunner()
}
