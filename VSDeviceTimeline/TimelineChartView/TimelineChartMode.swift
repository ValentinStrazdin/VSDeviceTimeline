import UIKit

enum TimelineChartMode {
    case free
    case premium(timelinePosition: CGFloat)

    var axisMinimum: Double {
        switch self {
        case .free:
            return 7 * 60 // 7 hours

        case .premium:
            return 0 // 0 hours
        }
    }

    var axisMaximum: Double {
        switch self {
        case .free:
            return 9 * 60 // 9 hours

        case .premium:
            return 24 * 60 // 24 hours
        }
    }

    // We should display timeline position both in free and premium mode
    var timelinePosition: CGFloat {
        switch self {
        case .free:
            return 9 * 60 // 9 hours

        case .premium(let timelinePosition):
            return timelinePosition
        }
    }

    var labelsCount: Int {
        Int((axisMaximum - axisMinimum) / 15) + 1 // every 15 minutes
    }
}
