import UIKit
import RxSwift

struct IntroBuilderInput { }

protocol IntroBuilder {
    func build(with input: IntroBuilderInput) -> Intro
}

final class IntroBuilderImpl: IntroBuilder {
    typealias Dependencies = HasAppFlowController & HasNaoDeviceBuilder
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
        
    func build(with input: IntroBuilderInput) -> Intro {
        let interactor = IntroInteractorImpl(dependencies: dependencies)
        let middleware = IntroMiddlewareImpl(dependencies: dependencies)
        let presenter = IntroPresenterImpl(interactor: interactor, middleware: middleware, initialViewState: IntroViewState())
        let view = IntroViewController(presenter: presenter)
        return Intro(view: view, callback: middleware)
    }
}
