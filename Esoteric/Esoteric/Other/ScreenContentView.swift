//
//  ScreenContentView.swift
//  esotericApp
//
//  Created by Denis Kotelnikov on 03.11.2023.
//

import Foundation
import SwiftUI

struct ScreenContentView<Content: View>: View {
    var color: Color
    let content: Content
    
    init(color: Color = .white, @ViewBuilder content: () -> Content) {
        self.color = color
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            content.padding(.horizontal, 40)
                .padding(.vertical, 24)
        }
 
        .background(Color.contentBlock)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.borderColor, lineWidth: 4))
        .padding(.horizontal, 24)
    
    }
}

struct Previews_ScreenContentView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ScreenContentView {
                Text("Hello, World!").padding(.horizontal,30)
            }
        }.frame(width: 1000, height: 500).background(BGColor)
    }
}
