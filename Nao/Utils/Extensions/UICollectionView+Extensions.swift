import UIKit

extension UICollectionViewCell: HasIdentifier { }

extension UICollectionView {
    func register<Cell: UICollectionViewCell>(_ cellType: Cell.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.identifier)
    }

    func dequeueCell<Cell: UICollectionViewCell>(for indexPath: IndexPath) -> Cell {
        // swiftlint:disable force_cast
        return dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as! Cell
        // swiftlint:enable force_cast
    }
}
