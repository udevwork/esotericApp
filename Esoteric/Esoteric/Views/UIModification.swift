//
//  UIModification.swift
//  esotericApp
//
//  Created by Denis Kotelnikov on 03.11.2023.
//

import Foundation
import SwiftUI

struct ThemeButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical)
            .padding(.horizontal,25)
            .background(Color(UIColor(hex: "333333")!))
            .clipShape(RoundedRectangle(cornerRadius: 24 , style: .continuous))
    }
}

struct ButtonModifier: ViewModifier {
    
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .padding(.vertical)
            .padding(.horizontal,25)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 24 , style: .continuous))
    }
}

struct RoundedViewModifier: ViewModifier {
    
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .padding(.vertical,10)
            .padding(.horizontal,20)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 24 , style: .continuous))
    }
}

struct GradientViewModifier: ViewModifier {
    
    let colors = [Color(uiColor: UIColor(hex: "FF6A6A")!),Color(uiColor: UIColor(hex: "FFD25F")!)]
    
    func body(content: Content) -> some View {
        content
            .padding(.vertical,4)
            .padding(.horizontal,10)
            .background(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
            .clipShape(RoundedRectangle(cornerRadius: 10 , style: .continuous))
    }
}

struct LightShadow: ViewModifier {
    func body(content: Content) -> some View {
        content.shadow(color: Color.shadowColor, radius: 14, x: 0, y: 10)
    }
}

struct ButtonFont: ViewModifier {
    
    var color: Color = .white
    
    func body(content: Content) -> some View {
        content.font(.system(.body, design: .monospaced, weight: .black)).foregroundColor(color)
    }
}

struct FooterFont: ViewModifier {
    
    var color: Color = .white
    
    func body(content: Content) -> some View {
        content.font(.system(.footnote, design: .monospaced, weight: .black)).foregroundColor(color)
    }
}

extension View {
    
    // Button
    func GrayButtonStyle() -> some View {
        modifier(ButtonModifier(color: .buttonGray)).modifier(ButtonFont())
    }
    
    func BlueButtonStyle() -> some View {
        modifier(ButtonModifier(color: .buttonBlue)).modifier(ButtonFont())
    }
    
    func RedButtonStyle() -> some View {
        modifier(ButtonModifier(color: .buttonRed)).modifier(ButtonFont())
    }
    
    func GreenButtonStyle() -> some View {
        modifier(ButtonModifier(color: .buttonGreen)).modifier(ButtonFont())
    }
    
    func WhiteButtonStyle() -> some View {
        modifier(ButtonModifier(color: .white)).modifier(ButtonFont(color: Color.buttonBlue))
    }
    
    func ProButtonStyle() -> some View {
        modifier(GradientViewModifier()).modifier(FooterFont())
    }
    
    // shadow
    func lightShadow() -> some View {
        modifier(LightShadow())
    }

    // Views
    func LightGrayViewStyle() -> some View {
        modifier(RoundedViewModifier(color: .lightGray)).modifier(ButtonFont(color: Color.textColor))
    }
    
}
