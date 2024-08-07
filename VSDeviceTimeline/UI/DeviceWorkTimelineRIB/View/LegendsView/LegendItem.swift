import Foundation

enum LegendItem: Int, CaseIterable, Comparable {
    case active = 0
    case blocked
    case additionalTime
    case overtime

    static func < (lhs: LegendItem, rhs: LegendItem) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension LegendItem {

    var title: String {
        switch self {
        case .active:
            return "Активно"

        case .blocked:
            return "Заблокировано"

        case .additionalTime:
            return "Дополнительное время"

        case .overtime:
            return "Показываются предупреждения"
        }
    }

}
