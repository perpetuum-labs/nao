import RxSwift

protocol SetUpMiddleware {
    var middlewareObservable: Observable<SetUpResult> { get }
    func process(result: SetUpResult) -> Observable<SetUpResult>
}

final class SetUpMiddlewareImpl: SetUpMiddleware, SetUpCallback {
    typealias Dependencies = HasAppFlowController
    typealias Result = SetUpResult
    
    private let dependencies: Dependencies
    private let deviceSubject = PublishSubject<NaoDevice>()
    private let middlewareSubject = PublishSubject<Result>()
    var middlewareObservable: Observable<Result> { return middlewareSubject }
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func process(result: Result) -> Observable<Result> {
        switch result {
        case .dismiss:
            dependencies.appFlowController.dismissSetUp()
        case .connected(let device):
            deviceSubject.onNext(device)
            dependencies.appFlowController.dismissSetUp()
        default:
            break
        }
        return .just(result)
    }
    
    func connected() -> Observable<NaoDevice> { return deviceSubject }
}
