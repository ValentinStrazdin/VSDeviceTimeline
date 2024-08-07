import UIKit

extension UICollectionView {
    func dequeue<Cell>(_ cell: Cell.Type, for indexPath: IndexPath) -> Cell where Cell: UICollectionViewCell {
        let dequeuedCell = dequeueReusableCell(withReuseIdentifier: cell.reusingIdentifier, for: indexPath)
        guard let reusableCell = dequeuedCell as? Cell else {
            assertionFailure("Trying to reuse wrong cell with type \(type(of: dequeuedCell)) (expected \(Cell.self))")
            return Cell()
        }

        return reusableCell
    }

    func dequeue<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reusingIdentifier, for: indexPath) as? T else {
            fatalError("Trying to reuse wrong cell with ReuseIdentifier \(T.reusingIdentifier)")
        }
        return cell
    }

    func dequeueHeader<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
        guard let reusableView = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: T.reusingIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("Trying to reuse wrong cell with ReuseIdentifier \(T.reusingIdentifier)")
        }
        return reusableView
    }

    func dequeueFooter<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
        guard let reusableView = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: T.reusingIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("Trying to reuse wrong cell with ReuseIdentifier \(T.reusingIdentifier)")
        }
        return reusableView
    }

    func registerCells(_ items: [UICollectionViewCell.Type]) {
        items.forEach {
            register($0,
                     forCellWithReuseIdentifier: $0.reusingIdentifier
            )
        }
    }

    func registerReusableHeaderView(_ items: [UICollectionReusableView.Type]) {
        items.forEach {
            register($0,
                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                     withReuseIdentifier: $0.reusingIdentifier
            )
        }
    }
}

extension UICollectionReusableView: Reusable {
    static var reusingIdentifier: String {
        String(describing: self)
    }
}
