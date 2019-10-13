import RxSwift

protocol IntroInteractor: Interactor { }

final class IntroInteractorImpl: IntroInteractor {
    typealias Dependencies = Any
    typealias Result = IntroResult
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}
