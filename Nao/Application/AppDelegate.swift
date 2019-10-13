import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    lazy var dependencies = AppDependencies(navigationController: navigationController)
    lazy var flowController = AppFlowControllerImpl(dependencies: dependencies)
    private let navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        return navigationController
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        flowController.start()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}
