import UIKit

enum ButtonStyle {
    case command
    case basic
    case image
    case link
}

class Button: UIButton {
    var style: ButtonStyle = .basic {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    var title: String? = "" {
        didSet {
            setTitle(title, for: .normal)
            setTitle(title, for: .highlighted)
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            self.alpha = isEnabled ? 1.0 : 0.5
        }
    }
    
    convenience init(style: ButtonStyle) {
        self.init()
        self.style = style
    }
    
    static func dismissButton() -> Button {
        let button = Button(style: .image)
        button.setImage(.assetName(ImageContent.dismiss), for: .normal)
        button.tintColor = .text
        return button
    }
    
    static func queueButton() -> Button {
        let button = Button(style: .image)
        button.setImage(.assetName(ImageContent.queue), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets.init(top: 10.0, left: 10.0, bottom: -10.0, right: -10.0)
        button.tintColor = .text
        return button
    }
    
    static func create(with title: String = "",
                       style: ButtonStyle = .basic) -> Button {
        let button = Button(style: style)
        button.setTitle(title, for: .normal)
        return button
    }
    
    private func updateStyle() {
        switch style {
        case .command:
            break
        case .basic:
            backgroundColor = Pallete.mayaBlue
        case .image, .link:
            backgroundColor = .clear
            setTitleColor(tintColor, for: .normal)
        }
        
        clipsToBounds = true
        layer.cornerRadius = 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateStyle()
    }
}
