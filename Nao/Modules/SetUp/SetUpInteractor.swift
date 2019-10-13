import RxSwift

protocol SetUpInteractor: Interactor {
    func connect(info: SetUpInfo) -> Observable<SetUpResult>
    func evaluateIpAddress(_: String) -> Observable<SetUpResult>
}

final class SetUpInteractorImpl: SetUpInteractor {
    typealias Dependencies = HasNaoDeviceBuilder
    typealias Result = SetUpResult
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func connect(info: SetUpInfo) -> Observable<SetUpResult> {
        do {
            let device = try dependencies.naoDeviceBuilder.build(with: info.ip, port: info.port)
            return device.naoClient.dispatch(Nao.Command.ValidateConnection())
                .flatMap { _ in Observable.just(Result.connected(device: device)) }
                .catchError { error in Observable.just(Result.connectionError(error: error)) }
                .startWith(Result.connecting)
        } catch let error {
            return .just(Result.connectionError(error: error))
        }
    }
    
    func evaluateIpAddress(_ ip: String) -> Observable<Result> {
        do {
            try validate(ip, using: .ipAddress)
        } catch let error as ValidationError {
            return .just(.ipAddressValidation(.failure(error)))
        } catch {
            return .just(.ipAddressValidation(.failure(.unknown)))
        }
        return .just(.ipAddressValidation(.success))
    }
}
