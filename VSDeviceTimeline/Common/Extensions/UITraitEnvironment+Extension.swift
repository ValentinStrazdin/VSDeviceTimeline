import UIKit

extension UITraitEnvironment {

    var isRegularHorizontal: Bool {
        traitCollection.horizontalSizeClass == .regular
    }

}
