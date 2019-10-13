import RxSwift

protocol GalleryMiddleware {
    var middlewareObservable: Observable<GalleryResult> { get }
    func process(result: GalleryResult) -> Observable<GalleryResult>
}

final class GalleryMiddlewareImpl: GalleryMiddleware, GalleryCallback {
    typealias Dependencies = HasAppFlowController
    typealias Result = GalleryResult

    private let dependencies: Dependencies

    private let middlewareSubject = PublishSubject<Result>()
    var middlewareObservable: Observable<Result> { return middlewareSubject }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func process(result: Result) -> Observable<Result> {
        switch result {
        case .showControl(let nao):
            dependencies.appFlowController.showControl(with: nao)
        case .disconnected:
            dependencies.appFlowController.startOverAgain()
        default:
            break
        }
        return .just(result)
    }
}
