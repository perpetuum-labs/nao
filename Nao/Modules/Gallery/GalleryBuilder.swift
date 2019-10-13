import RxSwift
import UIKit

struct GalleryBuilderInput {
    let naoDevice: NaoDevice
}

protocol GalleryBuilder {
    func build(with input: GalleryBuilderInput) -> Gallery
}

final class GalleryBuilderImpl: GalleryBuilder {
    typealias Dependencies = HasAppFlowController
    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func build(with input: GalleryBuilderInput) -> Gallery {
        let interactor = GalleryInteractorImpl(dependencies: dependencies, naoDevice: input.naoDevice)
        let middleware = GalleryMiddlewareImpl(dependencies: dependencies)
        let presenter = GalleryPresenterImpl(interactor: interactor, middleware: middleware, initialViewState: GalleryViewState(commands: Nao.Command.posture))
        return Gallery(view: makeView(with: presenter), callback: nil)
    }

    private func makeView(with presenter: GalleryPresenter) -> GalleryView {
        let storyboard = UIStoryboard(name: "Gallery", bundle: nil)
        let galleryViewController = storyboard.instantiateViewController(withIdentifier: "Gallery") as! GalleryViewController
        galleryViewController.presenter = presenter
        return galleryViewController
    }
}
