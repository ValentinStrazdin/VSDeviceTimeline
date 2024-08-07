import UIKit

extension UIView {

    @discardableResult
    func prepareForAutoLayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }

    var isRightToLeftUI: Bool {
        return UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft
    }

    var isLeftToRightUI: Bool {
        return UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .leftToRight
    }

    func addSubviews(_ subviews: [UIView]) {
        for subview in subviews {
            addSubview(subview)
        }
    }

}
