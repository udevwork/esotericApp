//
//  EmodjiIcon.swift
//  esotericApp
//
//  Created by Denis Kotelnikov on 03.11.2023.
//

import Foundation
import SwiftUI

struct EmodjiIcon: View {
    
    var iconText: String
    var color: Color = Color.lightGray
    
    var body: some View {
        Text(iconText)
            .font(.system(size: 30))
            .padding()
            .background(color.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 20 , style: .continuous))

    }
}

struct EmodjiIcon_Previews: PreviewProvider {
    static var previews: some View {
        EmodjiIcon(iconText: "👋")
    }
}
