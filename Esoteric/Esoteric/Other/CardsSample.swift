//
//  CardsSample.swift
//  Esoteric
//
//  Created by Denis Kotelnikov on 03.11.2023.
//

import Foundation
import SwiftUI

struct CardFlipHero: View {
    @Binding var isSelected: Bool
    var text : String

    var body : some View {
        return FlipView(
                front: AmazingCardBack(text: text),
                back: CardBack(text: "card-backward"),
                showBack: $isSelected)
    }
}


struct FlipView<FrontView: View, BackView: View>: View {

      let front: FrontView
      let back: BackView

  
      @Binding var showBack: Bool

      var body: some View {
          ZStack() {
                front
                  .frame(width: screenWidthPart(2.5), height: screenPart(3))
                  .scaleEffect(x: -1, y: 1)
                  .modifier(FlipOpacity(percentage: showBack ? 1 : 0))
                  .rotation3DEffect(Angle.degrees(showBack ? 180 : 360), axis: (0,1,0))
                back
                  .frame(width: screenWidthPart(2.5), height: screenPart(3))
                  .modifier(FlipOpacity(percentage: showBack ? 0 : 1))
                  .rotation3DEffect(Angle.degrees(showBack ? 0 : 180), axis: (0,1,0))
          }
//          .onTapGesture {
//              if showBack == false {
//                  withAnimation {
//                      self.showBack.toggle()
//                  }
//              }
//          }
      }
}

private struct FlipOpacity: AnimatableModifier {
   var percentage: CGFloat = 0
   
   var animatableData: CGFloat {
      get { percentage }
      set { percentage = newValue }
   }
   
   func body(content: Content) -> some View {
      content.opacity(Double(percentage.rounded()))
   }
}


struct CardBack: View {
    var text : String
    var body: some View {
        VStack() {
            Image(text)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
        }
       
        .background(.orange, in: RoundedRectangle(cornerRadius: 20))

    }
}


struct CardFlipHero_Preview: PreviewProvider {
    static var previews: some View {
        CardFlipHero(isSelected: .constant(true), text: "card1")
    }
}
