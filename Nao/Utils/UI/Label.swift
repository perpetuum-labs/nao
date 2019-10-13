import UIKit

enum LabelStyle {
    case basic(_ textStyle: UIFont.TextStyle)
    case heading
    case body
}

class Label: UILabel {
    var style: LabelStyle = .basic(UIFont.TextStyle.paragraph) {
        didSet {
            self.setNeedsLayout()
        }
    }

    static func create(with text: String = "",
                       style: LabelStyle = .basic(UIFont.TextStyle.paragraph),
                       textAlignment: NSTextAlignment = .left) -> Label {
        let label = Label(style: style)
        label.text = text
        label.textAlignment = textAlignment
        return label
    }
    
    convenience init(style: LabelStyle) {
        self.init()
        self.style = style
    }
    
    private func updateStyle() {
        numberOfLines = 0
        switch style {
        case .body:
            font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        case .heading:
            font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        default:
            break
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateStyle()
    }
    
    func embeddedInView() -> UIView {
        let view = UIView()
        view.addSubview(self)
        return view
    }
}
