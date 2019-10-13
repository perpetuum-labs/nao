import RxSwift

struct ControlBuilderInput {
    let naoDevice: NaoDevice
}

protocol ControlBuilder {
    func build(with input: ControlBuilderInput) -> ControlModule
}

final class ControlBuilderImpl: ControlBuilder {
    typealias Dependencies = HasAppFlowController
    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func build(with input: ControlBuilderInput) -> ControlModule {
        let interactor = ControlInteractorImpl(dependencies: dependencies, naoDevice: input.naoDevice)
        let middleware = ControlMiddlewareImpl(dependencies: dependencies)
        let presenter = ControlPresenterImpl(interactor: interactor, middleware: middleware, initialViewState: ControlViewState(commands: Nao.Command.posture))
        return ControlModule(view: PostureViewController(presenter: presenter), callback: middleware)
    }
}
