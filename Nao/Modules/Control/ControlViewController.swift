import UIKit
import RxSwift
import RxCocoa
import SnapKit

protocol ControlView: View {
    var sendCommandIntent: Observable<NaoCommand> { get }
    var showQueue: Observable<Void> { get }
    func render(state: ControlViewState)
}

final class PostureViewController: ViewController, UITableViewDelegate, ControlView {
    typealias ViewState = ControlViewState

    // MARK: MVI
    private let bag = DisposeBag()
    private let presenter: ControlPresenter

    // MARK: Intents
    var showQueue: Observable<Void> { return .empty() }
    var sendCommandIntent: Observable<NaoCommand> { return sendCommandSubject }

    private let sendCommandSubject = PublishSubject<NaoCommand>()

    // MARK: UI
    private let tableViewDataSubject = BehaviorSubject<[NaoCommand]>(value: [])
    private lazy var loadingView = {
        return LoadingViewController()
    } ()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CommandCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
        return tableView
    }()

    init(presenter: ControlPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Postures"
        layoutView()
        bindControls()
        presenter.bindIntents(view: self)
            .subscribe(onNext: { [weak self] state in self?.render(state: state) })
            .disposed(by: bag)
        tableView.delegate = self
    }

    private func layoutView() {
        view.backgroundColor = UIColor.background
        [tableView].forEach { view.addSubview($0) }
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.0)
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func bindControls() {
        tableViewDataSubject
            .bind(to: tableView.rx.items(cellIdentifier: CommandCell.identifier, cellType: CommandCell.self)) { [unowned self] _, command, cell in
                cell.command = command
                cell.actionObservable
                    .flatMap { Observable.just(command) }
                    .bind(to: self.sendCommandSubject)
                    .disposed(by: cell.bag)
            }
            .disposed(by: bag)
    }

    func render(state: ViewState) {
        tableViewDataSubject.onNext(state.commands)
        if state.isActivityIndicatorAnimating {
            present(loadingView, animated: true)
        } else {
            loadingView.dismiss(animated: true)
        }
    }
}
