//
//  ResizebleImage.swift
//  Esoteric
//
//  Created by Denis Kotelnikov on 01.12.2023.
//

import SwiftUI

struct ResizebleImage: View {
    
    var name: String
    var contentMode: ContentMode
    
    init(_ name: String, contentMode: ContentMode = .fit) {
        self.name = name
        self.contentMode = contentMode
    }
    
    var body: some View {
        Image(name).resizable().aspectRatio(contentMode: contentMode)
    }
}

#Preview {
    ResizebleImage("art_delimiter7")
}
