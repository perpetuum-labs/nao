import UIKit

struct AppDependencies: HasNavigation, HasNaoDeviceBuilder {
    let navigation: Navigation
    let naoDeviceBuilder: NaoDeviceBuilder
    init(navigationController: UINavigationController) {
        navigation = NavigationImpl(navigationController: navigationController)
        naoDeviceBuilder = NaoDeviceBuilderImpl()
    }
}
