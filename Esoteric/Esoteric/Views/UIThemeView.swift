//
//  UIThemeView.swift
//  esotericApp
//
//  Created by Denis Kotelnikov on 03.11.2023.
//

import Foundation
import SwiftUI

struct H1TitleView: View {
    let textColor: Color
    let text: String
    var alignment: TextAlignment

    init(textColor: Color = .textColor, text: String, alignment: TextAlignment = .center) {
        self.text = text
        self.textColor = textColor
        self.alignment = alignment
    }

    var body: some View {
        Text(text)
            .multilineTextAlignment(alignment)
            .font(.custom("ElMessiri-Regular", size: 42))
            .foregroundColor(textColor)
    }
}

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
            .font(.system(size: 19))
            //.font(.custom("ElMessiri-Regular", size: 18))
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
                    .font(.custom("ElMessiri-Bold", size: 28))
                    .foregroundColor(textColor)
                Spacer()
            } else if alignment == .center {
                Spacer()
                Text(text)
                    .multilineTextAlignment(.center)
                    .frame(alignment: .center)
                    .font(.custom("ElMessiri-Bold", size: 28))
                    .foregroundColor(.accentColor)
                Spacer()
            } else {
                Spacer()
                Text(text)
                    .multilineTextAlignment(.leading)
                    .frame(alignment: .leading)
                    .font(.custom("ElMessiri-Bold", size: 28))
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
                    .font(.custom("ElMessiri-Medium", size: 24))
                    .foregroundColor(textColor)
                Spacer()
            } else if alignment == .center {
                Text(text)
                    .multilineTextAlignment(.center)
                    .frame(alignment: .center)
                    .font(.custom("ElMessiri-Medium", size: 24))
                    .foregroundColor(textColor)
            } else {
                Spacer()
                Text(text)
                    .multilineTextAlignment(.leading)
                    .frame(alignment: .leading)
                    .font(.custom("ElMessiri-Medium", size: 24))
                    .foregroundColor(textColor)
            }
        }
    }
}

struct ShineTitleView: View {

    let textColor: CommodityColor
    let text: String
    let alignment: Alignment

    init(textColor: CommodityColor = .gold,
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
                    .font(.custom("ElMessiri-Bold", size: 28))
                    .multilineTextAlignment(.leading)
                    .lineSpacing(0)
                    .overlay {
                        textColor.linearGradient
                            .mask(
                                Text(text)
                                    .font(.custom("ElMessiri-Bold", size: 28))
                                    .multilineTextAlignment(.leading)
                                    .lineSpacing(0)
                            )
                    }
                Spacer()
            } else if alignment == .center {
                Spacer()
                Text(text)
                    .font(.custom("ElMessiri-Bold", size: 28))
                    .multilineTextAlignment(.leading)
                    .overlay {
                        textColor.linearGradient
                            .mask(
                                Text(text)
                                    .font(.custom("ElMessiri-Bold", size: 28))
                                    .multilineTextAlignment(.leading)
                            )
                    }
                Spacer()
            } else {
                Spacer()
                Text(text)
                    .font(.custom("ElMessiri-Bold", size: 28))
                    .multilineTextAlignment(.leading)
                    .overlay {
                        textColor.linearGradient
                            .mask(
                                Text(text)
                                    .font(.custom("ElMessiri-Bold", size: 28))
                                    .multilineTextAlignment(.leading)
                            )
                    }
            }
        }
    }
}
