import UIKit
import RxSwift
import RxCocoa

class CommandCell: UITableViewCell {
    var bag = DisposeBag()
    var actionObservable: Observable<Void> { return commandButton.rx.tap.asObservable() }
    private let commandButton = Button.create(style: .command)
    
    var command: NaoCommand? {
        didSet {
            guard let command = command else { return }
            commandButton.setTitle(command.name, for: .normal)
            commandButton.backgroundColor = command.color
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setUpViews()
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    func setUpViews() {
        addSubview(commandButton)
    }
    
    func layoutView() {
        commandButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        commandButton.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview().inset(15)
            $0.height.equalTo(60)
        }
    }
}
