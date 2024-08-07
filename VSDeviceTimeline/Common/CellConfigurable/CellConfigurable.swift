import Foundation

protocol CellConfigurable {

    associatedtype CellModel
    func configure(model: CellModel)

}
