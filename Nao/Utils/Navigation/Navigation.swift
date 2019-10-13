import UIKit

protocol Navigation {
    func start(with view: View, navigationHidden: Bool)
    func show(view: View)
    func present(view: View)
    func pop()
    func dismiss()
}

protocol HasNavigation {
    var navigation: Navigation { get }
}

class NavigationImpl: Navigation {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(with view: View, navigationHidden: Bool) {
        guard let viewController = view as? UIViewController else { return }
        navigationController.setViewControllers([viewController], animated: false)
        navigationController.isNavigationBarHidden = navigationHidden
    }
    
    func show(view: View) {
        guard let viewController = view as? UIViewController else { return }
        navigationController.show(viewController, sender: nil)
    }
    
    func present(view: View) {
        guard
            let viewController = view as? UIViewController,
            let topViewController = navigationController.topViewController else { return }
        let controller = UINavigationController(rootViewController: viewController)
        topViewController.present(controller, animated: true, completion: nil)
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
    
    func dismiss() {
        guard let presentedViewController = navigationController.topViewController?.presentedViewController else { return }
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
