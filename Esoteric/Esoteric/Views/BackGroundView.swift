//
//  BackGroundView.swift
//  Esoteric
//
//  Created by Denis Kotelnikov on 05.11.2023.
//

import SwiftUI

struct BackGroundView: View {
    var body: some View 
    {
        ZStack {
            Image("BGimg").resizable().aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            VStack(content: {
                HStack(content: {
                    Image("TL")
                    Spacer()
                    Image("TR")
                })
                Spacer()
                HStack(content: {
                    Image("BL")
                    Spacer()
                    Image("BR")
                })
            }).padding(30)
        }
    }
}

#Preview {
    BackGroundView()
}
