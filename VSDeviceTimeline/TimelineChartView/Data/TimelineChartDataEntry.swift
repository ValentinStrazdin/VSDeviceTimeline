import Foundation
import DGCharts
import UIKit

public final class TimelineChartDataEntry: ChartDataEntry {

    private enum Constant {

        static let minimumEntryLength: Minute = 1

    }

    // MARK: - Types

    public typealias Minute = Double

    // MARK: - Properties

    public let length: Minute
    public let height: Double
    public let color: UIColor
    public let gradientColors: [UIColor]?

    // MARK: - Init & deinit

    public init(x: Double,
                y: Double,
                length: Minute,
                height: Double,
                color: UIColor,
                gradientColors: [UIColor]?) {
        self.length = length
        self.height = height
        self.color = color
        self.gradientColors = gradientColors

        super.init(x: x, y: y)
    }

    public convenience init(timelineInterval: TimelineInterval) {
        let length = timelineInterval.length
        let height = 0.5

        let x = timelineInterval.start
        let y = (1 - height) / 2

        let color: UIColor
        var gradientColorScheme: GradientColorScheme?

        switch timelineInterval.type {
        case .active:
            color = .clear
            gradientColorScheme = .primaryAlterMain

        case .overtime:
            color = .clear
            gradientColorScheme = .primaryAttention

        case .block:
            color = .standardDisabled.withAlphaComponent(0.3)

        case .additionalTime:
            color = .clear
            gradientColorScheme = .primaryAuxiliary
        }

        self.init(x: x, y: y, length: length, height: height, color: color, gradientColors: gradientColorScheme?.gradientColors)
    }

    public required convenience init() {
        self.init(x: 0, y: 0, length: 0, height: 0, color: .clear, gradientColors: nil)
    }

    var entryRect: CGRect {
        .init(x: x, y: y, width: max(length, Constant.minimumEntryLength), height: height)
    }
}
