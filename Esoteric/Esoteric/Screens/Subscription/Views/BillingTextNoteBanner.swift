import SwiftUI

struct BillingTextNoteBanner: View {
    var body: some View {
        Text("Periodic billing. Cancel at any time. The subscription is automatically activated.")
            .multilineTextAlignment(.center)
            .font(.system(.footnote, design: .rounded, weight: .medium))
            .foregroundColor(.textColor)
    }
}

#Preview {
    BillingTextNoteBanner()
}
