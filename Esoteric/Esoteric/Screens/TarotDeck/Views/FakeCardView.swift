import SwiftUI

struct FakeCardView: View {
    
    var body: some View {
        GeometryReader(content: { geo in
            Image("card-backward")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .background(.orange, in: RoundedRectangle(cornerRadius: 20))
                .rotation3DEffect(.degrees(self.rotationAngle(for: geo.frame(in: .global).midX)),
                                                           axis: (x: 0, y: 2, z: -1))
            
                .offset(x: 0, y: self.offset(for: geo.frame(in: .global).midX))
                
        }) .frame(width: 80, height: 110)
            .shadow(color: .black.opacity(0.6), radius: 5, x: -20, y: 0)
    }
    
    func rotationAngle(for xPosition: CGFloat) -> Double {
        let scrollWidth = 110 + -20 // Ширина элемента плюс промежуток между ними
        let midX = UIScreen.main.bounds.width / 2
        let offset = Double(xPosition - midX)
        return -offset / Double(scrollWidth) * 20 // Измените угол поворота здесь
    }
    
    func offset(for xPosition: CGFloat) -> CGFloat {
        let midX = UIScreen.main.bounds.width / -3
           let offset = xPosition - midX
           let maxOffset: CGFloat = -70
           return maxOffset * sin(offset / 200) + 60
       }
    
}

#Preview {
    FakeCardView()
}
