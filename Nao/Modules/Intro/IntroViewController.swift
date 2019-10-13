import UIKit
import RxSwift
import RxCocoa
import SnapKit

let spacing: CGFloat = 15.0

protocol IntroView: View {
    var swipeIntent: Observable<Int> { get }
    var actionIntent: Observable<Int> { get }
    func render(state: IntroViewState)
}

final class IntroViewController: ViewController, IntroView {
    typealias ViewState = IntroViewState
    
    // MARK: MVI
    private let bag = DisposeBag()
    private let presenter: IntroPresenter
    
    // MARK: Intents
    var swipeIntent: Observable<Int> {
        return collectionView.rx.didEndDecelerating.map { [unowned self] _ in return self.getCurrentPage() }
    }
    var actionIntent: Observable<Int> {
        return actionButton.rx.tap.map { [unowned self] _ in return self.getCurrentPage() + 1 }
    }
    
    // MARK: UI
    private let collectionViewDataSubject = PublishSubject<[IntroSlideViewModel]>()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(IntroSlideCell.self, forCellWithReuseIdentifier: IntroSlideCell.identifier)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        return collectionView
    }()
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.text
        return pageControl
    }()
    
    private let actionButton = Button .create(style: .basic)
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = spacing
        return stackView
    }()
    
    init(presenter: IntroPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutView()
        bindControls()
        presenter.bindIntents(view: self)
            .subscribe(onNext: { [weak self] state in self?.render(state: state) })
            .disposed(by: bag)
    }
    
    private func layoutView() {
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        actionButton.backgroundColor = Pallete.mayaBlue
        view.backgroundColor = .background
        [collectionView, pageControl, actionButton].forEach { stackView.addArrangedSubview($0) }
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide).inset(2*spacing)
        }
        collectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
        }
        pageControl.snp.makeConstraints {
            $0.height.equalTo(spacing)
        }
        [actionButton].forEach {
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview().inset(spacing)
                $0.height.equalTo(4*spacing)
            }
        }
    }
    
    private func bindControls() {
        collectionViewDataSubject
            .bind(to: collectionView.rx.items(cellIdentifier: IntroSlideCell.identifier)) { _, element, cell in
                guard let cell = cell as? IntroSlideCell else { return }
                cell.setUp(with: element)
            }
            .disposed(by: bag)
    }
    
    func render(state: ViewState) {
        actionButton.title = state.currentSlide?.buttonTitle
        pageControl.numberOfPages = state.slides.count
        collectionViewDataSubject.onNext(state.slides)
        pageControl.currentPage = state.index
        collectionView.setContentOffset(CGPoint(x: CGFloat(state.index) * collectionView.frame.width, y: 0), animated: true)
    }
    
    private func getCurrentPage() -> Int {
        let collectionViewWidth = collectionView.frame.width
        let scrollViewWidth = collectionView.contentOffset.x + collectionViewWidth / 2
        return Int(scrollViewWidth / collectionViewWidth)
    }
}

extension IntroViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
