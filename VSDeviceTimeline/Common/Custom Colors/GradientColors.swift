import UIKit

enum GradientColorScheme {

    case primaryAlterMain
    case primaryAttention
    case primaryAuxiliary

    var gradientColors: [UIColor] {
        switch self {
        case .primaryAlterMain:
            return [
                UIColor.color(from: "23D1ADFF"),
                UIColor.color(from: "5AED64FF")
            ]

        case .primaryAttention:
            return [
                UIColor.color(from: "FF8E3FFF"),
                UIColor.color(from: "FFE41AFF")
            ]

        case .primaryAuxiliary:
            return [
                UIColor.color(from: "27B7FFFF"),
                UIColor.color(from: "9985F5FF")
            ]
        }
    }

}
