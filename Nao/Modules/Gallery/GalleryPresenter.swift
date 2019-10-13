import RxSwift

protocol GalleryPresenter: AnyObject, Presenter {
    func bindIntents(view: GalleryView) -> Observable<GalleryViewState>
}

final class GalleryPresenterImpl: GalleryPresenter {
    typealias View = GalleryView
    typealias ViewState = GalleryViewState
    typealias Middleware = GalleryMiddleware
    typealias Interactor = GalleryInteractor

    private let interactor: Interactor
    private let middleware: Middleware

    private let initialViewState: ViewState

    init(interactor: Interactor, middleware: Middleware, initialViewState: ViewState) {
        self.interactor = interactor
        self.middleware = middleware
        self.initialViewState = initialViewState
    }

    func bindIntents(view: View) -> Observable<ViewState> {
        let disconnectObservable = view.disconnectAction.map { GalleryResult.disconnected }
        let seeAllObservable = view.showControl.flatMap { [unowned self] command in self.interactor.showControl() }
        let commandObservable = view.sendCommandIntent.flatMap { [unowned self] command in self.interactor.send(command) }
        return Observable.merge(disconnectObservable, middleware.middlewareObservable, commandObservable, seeAllObservable)
            .flatMap { self.middleware.process(result: $0) }
            .scan(initialViewState, accumulator: { (previousState, result) -> ViewState in
                return result.reduce(previousState: previousState)
            })
            .startWith(initialViewState)
    }
}
