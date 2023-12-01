import SwiftUI

struct SubscribeButton: View {
    @Binding var process: Bool
    
    var body: some View {
        Button {
            process = true
            User.shared.subscribe { success in
                process = false
            }
        } label: {
            Text("Купить Подписку").font(.custom("ElMessiri-Bold", size: 26)).padding(10)
        }.ProButtonStyle()
    }
}

#Preview {
    SubscribeButton(process: .constant(false))
}
