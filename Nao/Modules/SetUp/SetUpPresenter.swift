import RxSwift

protocol SetUpPresenter: AnyObject, Presenter {
    func bindIntents(view: SetUpView) -> Observable<SetUpViewState>
}

final class SetUpPresenterImpl: SetUpPresenter {
    typealias View = SetUpView
    typealias ViewState = SetUpViewState
    typealias Middleware = SetUpMiddleware
    typealias Interactor = SetUpInteractor
    
    private let interactor: Interactor
    private let middleware: Middleware
    
    private let initialViewState: ViewState
    
    init(interactor: Interactor, middleware: Middleware, initialViewState: ViewState) {
        self.interactor = interactor
        self.middleware = middleware
        self.initialViewState = initialViewState
    }
    
    func bindIntents(view: View) -> Observable<ViewState> {
        let dismissObservable = view.dismissIntent.map { SetUpResult.dismiss }
        let ipAddressEditedObservable = view.ipAddressEditedIntent.flatMap { [unowned self] ip in self.interactor.evaluateIpAddress(ip) }
        let setUpObservable = view.setUpIntent.flatMap { [unowned self] info in self.interactor.connect(info: info) }
        return Observable.merge(middleware.middlewareObservable,
                                ipAddressEditedObservable,
                                setUpObservable,
                                dismissObservable)
            .flatMap { self.middleware.process(result: $0) }
            .scan(initialViewState, accumulator: { (previousState, result) -> ViewState in
                return result.reduce(previousState: previousState)
            })
            .startWith(initialViewState)
    }
}
