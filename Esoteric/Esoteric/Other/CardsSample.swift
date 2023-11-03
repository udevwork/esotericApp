//
//  CardsSample.swift
//  Esoteric
//
//  Created by Denis Kotelnikov on 03.11.2023.
//

import Foundation
import SwiftUI

import SwiftUI


struct CardFlipHero: View {
    @State var isFlip: Bool = false
    var text : String
    
    var body : some View {

  
        
        return FlipView(
                front: CardFace(text: "press here for flip", colorBg: .gray),
                back: CardBack(text: text),
                showBack: $isFlip)
            .shadow(color: .black.opacity(0.5), radius: 30, x: 0, y: 20)
         
        
    }
}


struct FlipView<FrontView: View, BackView: View>: View {

      let front: FrontView
      let back: BackView

      @Binding var showBack: Bool

      var body: some View {
          ZStack() {
                front
                  .modifier(FlipOpacity(percentage: showBack ? 0 : 1))
                  .rotation3DEffect(Angle.degrees(showBack ? 180 : 360), axis: (0,1,0))
                back
                  .modifier(FlipOpacity(percentage: showBack ? 1 : 0))
                  .rotation3DEffect(Angle.degrees(showBack ? 0 : 180), axis: (0,1,0))
          }
          .onTapGesture {
                withAnimation {
                      self.showBack.toggle()
                }
          }
      }
}

private struct FlipOpacity: AnimatableModifier {
   var percentage: CGFloat = 0
   
   var animatableData: CGFloat {
      get { percentage }
      set { percentage = newValue }
   }
   
   func body(content: Content) -> some View {
      content
           .opacity(Double(percentage.rounded()))
   }
}

struct CardFace : View {
    var text : String
    var colorBg: Color

    var body: some View {
          Text(text)
                .multilineTextAlignment(.center)
                .padding(5)
                .frame(width: 220, height: 320)
                .background(colorBg, in: RoundedRectangle(cornerRadius: 20))
    }
}


struct CardBack: View {
    var text : String
    var body: some View {
        VStack() {
            Image(text)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
        }
        .frame(width: 220, height: 320)
        .background(.orange, in: RoundedRectangle(cornerRadius: 20))

    }
}


struct CardFlipHero_Preview: PreviewProvider {
    static var previews: some View {
        CardFlipHero(text: "card1")
    }
}
