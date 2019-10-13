import Foundation
import UIKit

protocol HasAppFlowController {
    var appFlowController: AppFlowController { get }
}

protocol AppFlowController {
    func start()
    func showIntro()
    func showSetUp() -> SetUpCallback
    func dismissSetUp()
    func showGallery(with: NaoDevice)
    func showControl(with: NaoDevice)
    func startOverAgain()
}

class AppFlowControllerImpl: AppFlowController {
    typealias Dependencies = HasNavigation & HasNaoDeviceBuilder
    
    private class ExtendedDependencies: Dependencies, HasAppFlowController {
        var naoDeviceBuilder: NaoDeviceBuilder { return dependencies.naoDeviceBuilder }
        var navigation: Navigation { return dependencies.navigation }
        var appFlowController: AppFlowController { return flowController }
        
        private let dependencies: Dependencies
        private let flowController: AppFlowController
        
        init(dependencies: Dependencies, flowController: AppFlowController) {
            self.dependencies = dependencies
            self.flowController = flowController
        }
    }

    private let dependencies: Dependencies
    private lazy var introBuilder: IntroBuilder = IntroBuilderImpl(dependencies: ExtendedDependencies(dependencies: dependencies, flowController: self))
    private lazy var setUpBuilder: SetUpBuilder = SetUpBuilderImpl(dependencies: ExtendedDependencies(dependencies: dependencies, flowController: self))
    private lazy var galleryBuilder: GalleryBuilder = GalleryBuilderImpl(dependencies: ExtendedDependencies(dependencies: dependencies, flowController: self))

    private lazy var postureControlBuilder: ControlBuilder = ControlBuilderImpl(dependencies: ExtendedDependencies(dependencies: dependencies, flowController: self))

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func start() {
        showIntro()
    }

    func startOverAgain() {
        dependencies.navigation.start(with: introBuilder.build(with: IntroBuilderInput()).view, navigationHidden: true)
    }
    
    func showIntro() {
        dependencies.navigation.show(view: introBuilder.build(with: IntroBuilderInput()).view)
    }
    
    func showSetUp() -> SetUpCallback {
        let setUp = setUpBuilder.build(with: SetUpBuilderInput())
        dependencies.navigation.present(view: setUp.view)
        return setUp.callback
    }
    
    func dismissSetUp() {
        dependencies.navigation.dismiss()
    }

    func showGallery(with naoDevice: NaoDevice) {
        dependencies.navigation.show(view: galleryBuilder.build(with: GalleryBuilderInput(naoDevice: naoDevice)).view)
    }
    
    func showControl(with naoDevice: NaoDevice) {
        dependencies.navigation.show(view: postureControlBuilder.build(with: ControlBuilderInput(naoDevice: naoDevice)).view)
    }
}

class NaoTabBarController: UITabBarController, View { }
