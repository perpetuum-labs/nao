import UIKit

extension UIColor {
    static let background: UIColor = .white
    static let buttonBackground: UIColor = Pallete.mayaBlue
    static let text: UIColor = .darkText
}

enum Pallete {
    static let purple: UIColor = .hex("#7A6CA3")
    static let mayaBlue: UIColor = .hex("#5FC9F8")
    static let sunglow: UIColor = .hex("#FECB2E")
    static let radicalRed: UIColor = .hex("#FC3158")
    static let blue: UIColor = .hex("#147EFB")
    static let emerald: UIColor = .hex("#53D769")
    static let coralRed: UIColor = .hex("#FC3D39")
}

extension UIColor {
    static func hex(_ string: String) -> UIColor {
        return hexStringToUIColor(hex: string)
    }
}
