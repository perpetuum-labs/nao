import RxSwift

protocol GalleryInteractor: Interactor {
    func send(_: NaoCommand) -> Observable<GalleryResult>
    func showControl() -> Observable<GalleryResult>
}

final class GalleryInteractorImpl: GalleryInteractor {
    typealias Dependencies = Any
    typealias Result = GalleryResult

    private let dependencies: Dependencies
    let naoDevice: NaoDevice

    init(dependencies: Dependencies, naoDevice: NaoDevice) {
        self.dependencies = dependencies
        self.naoDevice = naoDevice
    }

    func send(_ command: NaoCommand) -> Observable<GalleryResult> {
        return naoDevice.naoClient.dispatch(command)
            .flatMap { _ in Observable.just(Result.sent) }
            .catchError { error in Observable.just(Result.error(error)) }
            .startWith(Result.sending)
    }

    func showControl() -> Observable<GalleryResult> {
        return .just(.showControl(naoDevice))
    }
}
