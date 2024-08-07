import UIKit

final class LegendsCollectionView: UICollectionView {

    override var intrinsicContentSize: CGSize {
        self.collectionViewLayout.collectionViewContentSize
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if !self.bounds.size.equalTo(self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }

}
