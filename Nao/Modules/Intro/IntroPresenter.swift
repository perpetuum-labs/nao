import RxSwift

protocol IntroPresenter: AnyObject, Presenter {
    func bindIntents(view: IntroView) -> Observable<IntroViewState>
}

final class IntroPresenterImpl: IntroPresenter {
    typealias View = IntroView
    typealias ViewState = IntroViewState
    typealias Middleware = IntroMiddleware
    typealias Interactor = IntroInteractor
    
    private let interactor: Interactor
    private let middleware: Middleware
    
    private let initialViewState: ViewState
    
    init(interactor: Interactor, middleware: Middleware, initialViewState: ViewState) {
        self.interactor = interactor
        self.middleware = middleware
        self.initialViewState = initialViewState
    }
    
    func bindIntents(view: View) -> Observable<ViewState> {
        let swipeObservable = view.swipeIntent.map { IntroResult.swiped($0) }
        let actionObservable = view.actionIntent.map { index -> IntroResult in
            index == IntroSlideViewModel.numberOfSlides ? .ready : .swiped(index)
        }
        return Observable.merge(middleware.middlewareObservable,
                                swipeObservable,
                                actionObservable)
            .flatMap { self.middleware.process(result: $0) }
            .scan(initialViewState, accumulator: { (state, result) -> ViewState in return result.reduce(state) })
            .startWith(initialViewState)
    }
}
