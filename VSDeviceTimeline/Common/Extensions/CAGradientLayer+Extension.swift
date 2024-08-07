import UIKit

extension CAGradientLayer {

    // MARK: - Internal Methods

    func configure(with gradientColors: [UIColor]) {
        colors = gradientColors.map { $0.cgColor }
        startPoint = CGPoint(x: 0, y: 1)
        endPoint = CGPoint(x: 1, y: 0)
    }

    func mirrorDirectionRightLeft() {
        let mirrorStart = CGPoint(x: endPoint.x, y: startPoint.y)
        let mirrorEnd = CGPoint(x: startPoint.x, y: endPoint.y)
        self.startPoint = mirrorStart
        self.endPoint = mirrorEnd
    }

}
