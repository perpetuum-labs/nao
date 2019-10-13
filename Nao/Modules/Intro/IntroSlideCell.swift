import UIKit
import SnapKit
import RxSwift

final class IntroSlideCell: UICollectionViewCell {
    private let titleLabel = Label.create(style: .heading)
    private let descriptionLabel = Label.create(style: .body)
    private let imageView = UIImageView()
    private var link: String?
    private var bag = DisposeBag()
    private var showsLink: Bool = false
    
    private let button = Button.create(with: TextContent.Intro.Slide.Two.link, style: .link)
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = spacing
        stackView.alignment = .center
        return stackView
    }()
    
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutView()
    }
    
    func setUp(with viewModel: IntroSlideViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        imageView.image = viewModel.image
        showsLink = viewModel.showsLink
        button.title = showsLink ? TextContent.Intro.Slide.Two.link : ""
        button.snp.removeConstraints()
        button.snp.makeConstraints { $0.height.equalTo(showsLink ? 44.0 : 0.0) }
    }
    
    override func prepareForReuse() {
        self.bag = DisposeBag()
        button.rx.tap
            .bind {
                guard let url = URL(string: "https://github.com/perpetuum-labs/nao/blob/master/nao.py") else { return }
                UIApplication.shared.open(url)
            }
            .disposed(by: bag)
    }
    
    private func layoutView() {
        descriptionLabel.textColor = .darkGray
        titleLabel.textColor = .darkText
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        [button, descriptionLabel.embeddedInView()].forEach { bottomStackView.addArrangedSubview($0) }
        [titleLabel.embeddedInView(), imageView, bottomStackView].forEach { stackView.addArrangedSubview($0) }
        addSubview(stackView)
        button.backgroundColor = Pallete.mayaBlue
        stackView.snp.makeConstraints { $0.edges.equalToSuperview().inset(spacing) }
        [titleLabel, descriptionLabel].forEach { $0.snp.makeConstraints { $0.edges.equalToSuperview() } }
    }
}
