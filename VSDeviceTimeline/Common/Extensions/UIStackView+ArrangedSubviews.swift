import UIKit

extension UIStackView {

    public func removeArrangedSubviews() {
        let subviewsToRemove = arrangedSubviews
        subviewsToRemove.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    public func addArrangedSubviews(_ views: [UIView]) {
        views.forEach {
            addArrangedSubview($0)
        }
    }

}
