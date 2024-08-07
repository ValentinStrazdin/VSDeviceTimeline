import UIKit

final class LegendsView: UIView {

    private lazy var collectionView: LegendsCollectionView = {
        let collectionView = LegendsCollectionView(
            frame: .zero,
            collectionViewLayout: LegendsFlowLayout(isleftToRight: isLeftToRightUI)
        )
        collectionView.prepareForAutoLayout()
        collectionView.registerCells([
            LegendCell.self
        ])
        collectionView.dataSource = dataSource
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .backgroundPrimary
        return collectionView
    }()

    private let dataSource: UICollectionViewDataSource?

    // MARK: - Init

    init(
        dataSource: UICollectionViewDataSource?
    ) {
        self.dataSource = dataSource
        super.init(frame: .zero)
        addSubview(collectionView)
        setupConstraints()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reload() {
        collectionView.reloadData()
    }

    func invalidateLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
    }

    // MARK: - Private methods

    private func setupConstraints() {
        collectionView.pin(toEdgesOf: self)
    }

}
