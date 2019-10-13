import UIKit

enum TextFieldStyle {
    case normal
    case number
}

class TextField: UITextField {
    private var inset: CGFloat = 0.0
    var style: TextFieldStyle = .normal {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    static func create(style: TextFieldStyle = .normal,
                       textAlignment: NSTextAlignment = .center) -> TextField {
        let textField = TextField(style: style)
        textField.textAlignment = textAlignment
        return textField
    }
    
    convenience init(style: TextFieldStyle) {
        self.init()
        self.style = style
    }
    
    private func updateStyle() {
        clipsToBounds = false
        autocapitalizationType = .none
        tintColor = .text
        font = UIFont(name: "Avenir-Medium", size: 24.0)
        textColor = UIColor.text
        switch style {
        case .normal:
            break
        case .number:
            keyboardType = .numbersAndPunctuation
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect { return bounds.insetBy(dx: inset, dy: inset) }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect { return textRect(forBounds: bounds) }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool { return false }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateStyle()
    }
}
