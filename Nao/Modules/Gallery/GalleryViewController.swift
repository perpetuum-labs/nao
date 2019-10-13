import UIKit
import RxSwift

protocol GalleryView: View {
    var disconnectAction: Observable<Void> { get }
    var sendCommandIntent: Observable<NaoCommand> { get }
    var showControl: Observable<Void> { get }
    func render(state: GalleryViewState)
}

final class GalleryViewController: UITableViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private let bag = DisposeBag()
    var presenter: GalleryPresenter!
    private let sendCommandSubject = PublishSubject<NaoCommand>()
    private let showControlSubject = PublishSubject<Void>()
    private let disconnectActionSubject = PublishSubject<Void>()
    @IBOutlet weak var card: UIView!

    private var state: GalleryViewState = GalleryViewState(commands: Nao.Command.posture)
    lazy var loadingView = { return LoadingViewController() } ()

    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var downButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutView()
        presenter.bindIntents(view: self)
            .subscribe(onNext: { [weak self] state in self?.render(state: state) })
            .disposed(by: bag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    @IBAction func disconnectAction(_ sender: Any) {
        disconnectActionSubject.onNext(())
    }

    @IBAction func seeAllButton(_ sender: Any) {
        showControlSubject.onNext(())
    }
    @IBAction func saySomethingButton(_ sender: Any) {
        var inputTextField: UITextField?
        let actionSheetController: UIAlertController = UIAlertController(title: "Speaking", message: "Type in what you Nao should say!", preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheetController.addAction(cancelAction)
        let sayAction: UIAlertAction = UIAlertAction(title: "Speak", style: .default) { _ -> Void in
            inputTextField?.text.map { [weak self] text in
                print(text)
                self?.sendCommandSubject.onNext(Nao.Command.Say(text: text))
            }
        }
        actionSheetController.addAction(sayAction)
        actionSheetController.addTextField { textField -> Void in
            inputTextField = textField
        }
        self.present(actionSheetController, animated: true, completion: nil)
    }

    @IBAction func up(_ sender: Any) {
        sendCommandSubject.onNext(Nao.Command.GoForward())
    }

    @IBAction func down(_ sender: Any) {
        sendCommandSubject.onNext(Nao.Command.GoBackward())
    }
    @IBAction func left(_ sender: Any) {
        sendCommandSubject.onNext(Nao.Command.GoLeft())
    }

    @IBAction func right(_ sender: Any) {
        sendCommandSubject.onNext(Nao.Command.GoRight())
    }

    private func layoutView() {
        [upButton, leftButton, rightButton, downButton].forEach {
            $0?.backgroundColor = Pallete.blue
        }
        card.backgroundColor = Pallete.purple
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isNavigationBarHidden = false
    }
}

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return Nao.Command.posture.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostureCell", for: indexPath) as! PostureCell
        cell.command = state.commands[indexPath.row]
        return cell
    }
}

extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        sendCommandSubject.onNext(Nao.Command.posture[indexPath.row])
    }
}

class PostureCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var background: UIView!

    var command: NaoCommand? = nil {
        didSet {
            command.map {
                background.backgroundColor = $0.color
                nameLabel.text = $0.name
            }
        }
    }

    var gradientLayer: CALayer? = nil {
        didSet {
            gradientLayer.map { self.background.layer.addSublayer($0) }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        gradientLayer?.removeFromSuperlayer()
    }
}

extension GalleryViewController: GalleryView {
    var disconnectAction: Observable<Void> {
        return disconnectActionSubject.asObservable()
    }

    var showControl: Observable<Void> {
        return showControlSubject.asObservable()
    }

    var sendCommandIntent: Observable<NaoCommand> {
        return sendCommandSubject.asObservable()
    }

    func render(state: GalleryViewState) {
        self.state = state
        if state.isActivityIndicatorAnimating {
            present(loadingView, animated: true)
        } else {
            loadingView.dismiss(animated: true)
        }
    }
}

protocol Gradientable {
    func gradientLayer(from: UIColor) -> CALayer
}
