import UIKit

extension UITableViewCell: HasIdentifier { }

extension UITableView {
    func register<Cell: UITableViewCell>(_ cellType: Cell.Type) {
        register(cellType, forCellReuseIdentifier: cellType.identifier)
    }
    
    func dequeueCell<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell {
        // swiftlint:disable force_cast
        return dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as! Cell
        // swiftlint:enable force_cast
    }
}
