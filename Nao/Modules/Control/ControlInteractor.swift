import RxSwift

protocol ControlInteractor: Interactor {
    func send(_: NaoCommand) -> Observable<ControlResult>
}

final class ControlInteractorImpl: ControlInteractor {
    typealias Dependencies = Any
    typealias Result = ControlResult
    
    private let dependencies: Dependencies
    private let naoDevice: NaoDevice
    
    init(dependencies: Dependencies, naoDevice: NaoDevice) {
        self.dependencies = dependencies
        self.naoDevice = naoDevice
    }
    
    func send(_ command: NaoCommand) -> Observable<ControlResult> {
        return naoDevice.naoClient.dispatch(command)
            .flatMap { _ in Observable.just(Result.sent) }
            .catchError { error in Observable.just(Result.error(error)) }
            .startWith(Result.sending)
    }
}
