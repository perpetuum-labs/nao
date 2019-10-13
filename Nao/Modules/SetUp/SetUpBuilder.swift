struct SetUpBuilderInput { }

protocol SetUpBuilder {
    func build(with input: SetUpBuilderInput) -> SetUp
}

final class SetUpBuilderImpl: SetUpBuilder {
    typealias Dependencies = HasAppFlowController & HasNaoDeviceBuilder
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func build(with input: SetUpBuilderInput) -> SetUp {
        let interactor = SetUpInteractorImpl(dependencies: dependencies)
        let middleware = SetUpMiddlewareImpl(dependencies: dependencies)
        let presenter = SetUpPresenterImpl(interactor: interactor, middleware: middleware, initialViewState: SetUpViewState())
        let view = SetUpViewController(presenter: presenter)
        return SetUp(view: view, callback: middleware)
    }
}
