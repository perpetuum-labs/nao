import UIKit

protocol View {}

protocol Presenter {}

protocol Interactor {}

class ViewController: UIViewController {
    deinit {
        print("Deinit: \(self)")
    }
}
