import RxSwift

protocol ControlMiddleware {
    var middlewareObservable: Observable<ControlResult> { get }
    func process(result: ControlResult) -> Observable<ControlResult>
}

final class ControlMiddlewareImpl: ControlMiddleware, ControlCallback {
    typealias Dependencies = HasAppFlowController
    typealias Result = ControlResult
    
    private let dependencies: Dependencies

    private let middlewareSubject = PublishSubject<Result>()
    var middlewareObservable: Observable<Result> { return middlewareSubject }
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func process(result: Result) -> Observable<Result> {
        switch result {
        default:
            break
        }
        return .just(result)
    }
}
