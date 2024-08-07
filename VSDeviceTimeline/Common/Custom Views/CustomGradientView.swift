import UIKit

class CustomGradientView: UIView {

    // MARK: - Public properties

    public override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    // MARK: - Private properties

    private var gradientLayer: CAGradientLayer? {
        guard let gradientLayer = layer as? CAGradientLayer else {
            assertionFailure("View's layer is not 'CAGradientLayer'. Layer: \(layer)")
            return nil
        }
        return gradientLayer
    }

    // MARK: - Public methods

    public func configure(with gradientColorScheme: GradientColorScheme) {
        gradientLayer?.configure(with: gradientColorScheme.gradientColors)
        if isRightToLeftUI {
            gradientLayer?.mirrorDirectionRightLeft()
        }
    }

}
