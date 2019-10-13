import UIKit
import RxSwift
import RxCocoa
import SnapKit

protocol SetUpView: View {
    var setUpIntent: Observable<SetUpInfo> { get }
    var dismissIntent: Observable<Void> { get }
    var ipAddressEditedIntent: Observable<String> { get }
    func render(state: SetUpViewState)
}

final class SetUpViewController: ViewController, SetUpView {
    typealias ViewState = SetUpViewState
    
    // MARK: MVI
    private let bag = DisposeBag()
    private let presenter: SetUpPresenter
    
    // MARK: Intents
    var dismissIntent: Observable<Void> { return dismissActionButton.rx.tap.asObservable() }
    var ipAddressEditedIntent: Observable<String> { return ipAddressTextField.rx.text.asObservable().ignoreNil() }
    var setUpIntent: Observable<SetUpInfo> {
        return setUpActionButton.rx.tap
            .map { [unowned self] _ -> SetUpInfo? in
                guard let ip = self.ipAddressTextField.text else { return nil }
                return SetUpInfo(ip: ip, port: 7654)
            }
            .ignoreNil() }
    
    // MARK: UI
    private let dismissActionButton = Button.dismissButton()
    private let ipAddressTextField = TextField.create(style: .number)
    private let ipAddressErrorLabel = Label.create()
    private let setUpActionButton = Button.create(style: .basic)
    private lazy var loadingView = { return LoadingViewController() } ()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = spacing
        return stackView
    }()
    
    init(presenter: SetUpPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutView()
        presenter.bindIntents(view: self)
            .subscribe(onNext: { [weak self] state in self?.render(state: state) })
            .disposed(by: bag)
    }
    
    private func layoutView() {
        setUpActionButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .background
        [ipAddressTextField, ipAddressErrorLabel, setUpActionButton, UIView()].forEach {
            stackView.addArrangedSubview($0)
        }
        [dismissActionButton, stackView].forEach { view.addSubview($0) }
        dismissActionButton.snp.makeConstraints {
            $0.width.height.equalTo(44.0)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(spacing)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(spacing/2)
        }
        [ipAddressErrorLabel].forEach { $0.sizeToFit() }
        [ipAddressTextField, setUpActionButton].forEach { $0.snp.makeConstraints { $0.height.equalTo(4*spacing) } }
        stackView.snp.makeConstraints {
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(spacing)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(4*spacing)
        }
        setUpActionButton.snp.makeConstraints { $0.left.right.equalToSuperview() }

        ipAddressErrorLabel.textColor = .lightGray
        ipAddressTextField.textColor = .darkGray

        ipAddressTextField.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
    }
    
    func render(state: ViewState) {
        ipAddressTextField.placeholder = TextContent.SetUp.ipAddressPlaceholder
        setUpActionButton.title = TextContent.SetUp.buttonTitle
        setUpActionButton.isEnabled = state.isSetUpButtonEnabled
        ipAddressErrorLabel.text = state.ipAddressValidationErrorMessage
        state.isActivityIndicatorAnimating ? add(loadingView) : loadingView.remove()
        if let message = state.connectionErrorMessage {
            let alert = UIAlertController(title: TextContent.SetUp.Error.title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: TextContent.SetUp.Error.button, style: .default) { [weak self] _ in
                [self?.ipAddressTextField].forEach {
                    $0?.text = nil
                    $0?.resignFirstResponder()
                }
            })
            present(alert, animated: true)
        }
    }
}
