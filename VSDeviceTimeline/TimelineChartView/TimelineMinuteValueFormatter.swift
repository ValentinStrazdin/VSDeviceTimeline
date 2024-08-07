import Foundation
import DGCharts

final class TimelineMinuteValueFormatter: NSObject, AxisValueFormatter {

    // MARK: - Private Properties

    private let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()

    // MARK: - Formatting

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let timeInterval = abs(value.rounded(.up) * 60)
        return formatter.string(from: timeInterval) ?? ""
    }
}
