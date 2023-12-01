import SwiftUI

struct AdvantagesBanner: View {
    var body: some View {
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
    }
}

#Preview {
    AdvantagesBanner()
}
