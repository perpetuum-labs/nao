import Foundation
import UIKit

extension UIImage {
    static func assetName(_ name: String) -> UIImage? {
        return UIImage(named: name) ?? nil
    }
}
