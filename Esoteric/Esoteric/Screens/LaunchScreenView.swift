import Foundation
import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            BackGroundView()
            VStack(alignment: .center) {
                Text("TAROT")
                    .font(.custom("ElMessiri-Bold", size: 60))
                    .foregroundColor(.accentColor)
                    .frame(height: 90)
                ResizebleImage("home_header_logo")

            }.padding()
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView().preferredColorScheme(.dark)
    }
}
