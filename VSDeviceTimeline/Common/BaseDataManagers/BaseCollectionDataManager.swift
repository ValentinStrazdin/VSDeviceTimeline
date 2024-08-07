import UIKit

protocol BaseCollectionDataManager: UICollectionViewDataSource {

    var items: [CollectionCellConfigurator] { get set }

}

class BaseCollectionDataManagerImpl: NSObject, BaseCollectionDataManager {

    var items: [CollectionCellConfigurator] = []

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let item = items[indexPath.row]

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: type(of: item).reuseID,
            for: indexPath
        )
        item.configure(cell: cell)

        return cell
    }
}
