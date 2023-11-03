//
//  UIThemeView.swift
//  esotericApp
//
//  Created by Denis Kotelnikov on 03.11.2023.
//

import Foundation
import SwiftUI

struct ArticleView: View {
    let textColor: Color
    let text: String
    var alignment: TextAlignment
    
    init(textColor: Color = .textColor, text: String, alignment: TextAlignment = .leading) {
        self.text = text
        self.textColor = textColor
        self.alignment = alignment
    }
    
    var body: some View {
        Text(text)
            .multilineTextAlignment(alignment)
            .font(.system(.body, design: .rounded, weight: .medium))
            .foregroundColor(textColor)
    }
}

struct SectionTitleView: View {
    
    let textColor: Color
    let text: String
    let alignment: Alignment
    
    init(textColor: Color = .textColor,
         text: String,
         alignment: Alignment = .leading) {
        
        self.text = text
        self.textColor = textColor
        self.alignment = alignment
        
    }
    
    var body: some View {
        HStack(spacing: 0) {
            if alignment == .leading {
                Text(text)
                    .multilineTextAlignment(.leading)
                    .frame(alignment: .leading)
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .foregroundColor(textColor)
                Spacer()
            } else if alignment == .center {
                Spacer()
                Text(text)
                    .multilineTextAlignment(.center)
                    .frame(alignment: .center)
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .foregroundColor(textColor)
                Spacer()
            } else {
                Spacer()
                Text(text)
                    .multilineTextAlignment(.leading)
                    .frame(alignment: .leading)
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .foregroundColor(textColor)
            }
        }
    }
}

struct SubSectionTitleView: View {
    
    let textColor: Color
    let text: String
    let alignment: Alignment
    
    init(textColor: Color = .textColor,
         text: String,
         alignment: Alignment = .leading) {
        
        self.text = text
        self.textColor = textColor
        self.alignment = alignment
        
    }
    
    var body: some View {
        HStack(spacing: 0) {
            if alignment == .leading {
                Text(text)
                    .multilineTextAlignment(.leading)
                    .frame(alignment: .leading)
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundColor(textColor)
                Spacer()
            } else if alignment == .center {
                Text(text)
                    .multilineTextAlignment(.center)
                    .frame(alignment: .center)
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundColor(textColor)
            } else {
                Spacer()
                Text(text)
                    .multilineTextAlignment(.leading)
                    .frame(alignment: .leading)
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundColor(textColor)
            }
        }
    }
}
