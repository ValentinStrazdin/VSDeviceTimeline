import UIKit

protocol CollectionCellConfigurator {

    static var reuseID: String { get }
    var size: CGSize { get set }
    func configure(cell: UIView)

}

class CollectionCellConfiguratorImpl<
    CellType: CellConfigurable,
    CellModel
>: CollectionCellConfigurator where CellType.CellModel == CellModel {

    static var reuseID: String { String(describing: CellType.self) }
    var model: CellModel
    var size: CGSize

    init(model: CellModel, size: CGSize) {
        self.model = model
        self.size = size
    }

    func configure(cell: UIView) {
        (cell as? CellType)?.configure(model: model)
    }

}
