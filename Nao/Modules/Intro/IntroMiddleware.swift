import RxSwift

protocol IntroMiddleware {
    var middlewareObservable: Observable<IntroResult> { get }
    func process(result: IntroResult) -> Observable<IntroResult>
}

final class IntroMiddlewareImpl: IntroMiddleware, IntroCallback {
    typealias Dependencies = HasAppFlowController
    typealias Result = IntroResult
    
    private let dependencies: Dependencies
    private let bag = DisposeBag()

    private let middlewareSubject = PublishSubject<Result>()
    var middlewareObservable: Observable<Result> { return middlewareSubject }
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func process(result: Result) -> Observable<Result> {
        switch result {
        case .ready:
            let callback = dependencies.appFlowController.showSetUp()
            callback.connected()
                .subscribe(onNext: { [unowned self] device in
                    self.dependencies.appFlowController.showGallery(with: device)
                })
                .disposed(by: bag)
        default:
            break
        }
        return .just(result)
    }
}
