//
//  StupidHeightHelper.swift
//  Esoteric
//
//  Created by Denis Kotelnikov on 21.11.2023.
//

import Foundation
import UIKit

func screenPart(_ val: CGFloat ) -> CGFloat {
    UIScreen.main.bounds.height / val
}

func screenWidthPart(_ val: CGFloat ) -> CGFloat {
    UIScreen.main.bounds.width / val
}
