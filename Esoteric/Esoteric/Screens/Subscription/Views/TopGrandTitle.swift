import SwiftUI

struct TopGrandTitle: View {
    
    var title: String
    var subtitle: String
    
    var body: some View {
        VStack(alignment: .center) {
            H1TitleView(textColor: .accentColor, text: title, alignment: .center).frame(height: 30)
            SubSectionTitleView(text: subtitle, alignment: .center)
            Image("art_delimiter7").resizable().aspectRatio(contentMode: .fit).frame(height: 10)
        }
    }
}

#Preview {
    TopGrandTitle(title: "Premium", subtitle: "subscribe")
}
