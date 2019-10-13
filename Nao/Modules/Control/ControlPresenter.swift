import RxSwift

protocol ControlPresenter: AnyObject, Presenter {
    func bindIntents(view: ControlView) -> Observable<ControlViewState>
}

final class ControlPresenterImpl: ControlPresenter {
    typealias View = ControlView
    typealias ViewState = ControlViewState
    typealias Middleware = ControlMiddleware
    typealias Interactor = ControlInteractor
    
    private let interactor: Interactor
    private let middleware: Middleware
    
    private let initialViewState: ViewState
    
    init(interactor: Interactor, middleware: Middleware, initialViewState: ViewState) {
        self.interactor = interactor
        self.middleware = middleware
        self.initialViewState = initialViewState
    }
    
    func bindIntents(view: View) -> Observable<ViewState> {
        let commandObservable = view.sendCommandIntent.flatMap { [unowned self] command in self.interactor.send(command) }
        return Observable.merge(middleware.middlewareObservable, commandObservable)
            .flatMap { self.middleware.process(result: $0) }
            .scan(initialViewState, accumulator: { (previousState, result) -> ViewState in
                return result.reduce(previousState: previousState)
            })
            .startWith(initialViewState)
    }
}
