import UIKit

extension UIView {

    func pin(toEdgesOf superview: UIView) {
        guard self.superview === superview else {
            assertionFailure("\(self) must be subview of \(superview)")
            return
        }

        translatesAutoresizingMaskIntoConstraints = false
        pinAnchor(superview.topAnchor, to: topAnchor)
        pinAnchor(superview.leftAnchor, to: leftAnchor)
        pinAnchor(superview.rightAnchor, to: rightAnchor)
        pinAnchor(superview.bottomAnchor, to: bottomAnchor)
    }

    // MARK: - Private

    private func pinAnchor<T: NSLayoutXAxisAnchor>(_ pinningAnchor: T, to pinnedAnchor: T) {
        pinningAnchor.constraint(equalTo: pinnedAnchor, constant: 0).isActive = true
    }

    private func pinAnchor<T: NSLayoutYAxisAnchor>(_ pinningAnchor: T, to pinnedAnchor: T) {
        pinningAnchor.constraint(equalTo: pinnedAnchor, constant: 0).isActive = true
    }
}
