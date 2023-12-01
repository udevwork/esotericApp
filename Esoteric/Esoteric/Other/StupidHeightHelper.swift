import Foundation
import UIKit

func screenPart(_ val: CGFloat ) -> CGFloat {
    UIScreen.main.bounds.height / val
}

func screenWidthPart(_ val: CGFloat ) -> CGFloat {
    UIScreen.main.bounds.width / val
}
