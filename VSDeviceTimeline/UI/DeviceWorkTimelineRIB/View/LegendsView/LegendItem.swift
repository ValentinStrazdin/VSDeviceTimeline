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

    // MARK: - Private Types

    private typealias Localization = String.Localized.DeviceWorkTimeline.Legend

    var title: String {
        switch self {
        case .active:
            return Localization.activeTitle

        case .blocked:
            return Localization.blockedTitle

        case .additionalTime:
            return Localization.additionalTimeTitle

        case .overtime:
            return Localization.overtimeTitle
        }
    }

}
