import Foundation

protocol HasIdentifier {
    static var identifier: String { get }
}

extension HasIdentifier {
    static var identifier: String { return String(describing: self) }
}
