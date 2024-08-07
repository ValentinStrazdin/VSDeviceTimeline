import UIKit

final class LegendsFlowLayout: UICollectionViewFlowLayout {

    // MARK: - Private properties

    private enum Constant {

        static let leftMargin: CGFloat = 0
        static let cellSpacing: CGFloat = 16
        
    }

    override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        true
    }
    
    private let isleftToRight: Bool

    // MARK: - Init

    init(isleftToRight: Bool) {
        self.isleftToRight = isleftToRight
        super.init()
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        itemSize = UICollectionViewFlowLayout.automaticSize
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override

    override func layoutAttributesForElements(
        in rect: CGRect
    ) -> [UICollectionViewLayoutAttributes]? {
        guard
            let attributesForElementsInRect = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        var newAttributesForElementsInRect: [UICollectionViewLayoutAttributes] = []

        var leftMargin: CGFloat = Constant.leftMargin
        var currentSection = 0

        for attributes in attributesForElementsInRect {
            if attributes.frame.origin.x == self.sectionInset.left {
                leftMargin = self.sectionInset.left
            }
            else if currentSection != attributes.indexPath.section {
                var newLeftAlignedFrame = attributes.frame
                newLeftAlignedFrame.origin.x = 0
                attributes.frame = newLeftAlignedFrame
            }
            else if attributes.frame.width + leftMargin > self.collectionViewContentSize.width
            && isleftToRight {
                leftMargin = self.sectionInset.left
                var newLeftAlignedFrame = attributes.frame
                newLeftAlignedFrame.origin.x = leftMargin
                attributes.frame = newLeftAlignedFrame
            }
            else {
                var newLeftAlignedFrame = attributes.frame
                newLeftAlignedFrame.origin.x = leftMargin
                attributes.frame = newLeftAlignedFrame
            }
            leftMargin += attributes.frame.size.width + Constant.cellSpacing
            newAttributesForElementsInRect.append(attributes)

            currentSection = attributes.indexPath.section
        }

        return newAttributesForElementsInRect
    }

}
