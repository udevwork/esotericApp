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
                front: CardBack(text: "tarot"),
                back: CardBack(text: text),
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
                  .modifier(FlipOpacity(percentage: showBack ? 1 : 0))
                  .rotation3DEffect(Angle.degrees(showBack ? 180 : 360), axis: (0,1,0))
                back
                  .modifier(FlipOpacity(percentage: showBack ? 0 : 1))
                  .rotation3DEffect(Angle.degrees(showBack ? 0 : 180), axis: (0,1,0))
          }
          .onTapGesture {
              if showBack == false {
                  withAnimation {
                      self.showBack.toggle()
                  }
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
        CardFlipHero(isSelected: .constant(true), text: "card1")
    }
}
