import UIKit
import CoreGraphics
import DGCharts

public protocol TimelineChartViewEventsHandler: AnyObject {

    func chartViewDataSetChanged()

}

final class TimelineChartView: BarLineChartViewBase {

    static let axisLabelWidth: CGFloat = 24

    // MARK: - Private types

    private enum Constant {

        static let bottomOffset: CGFloat = 1
        static let gridLineWidth: CGFloat = 1
        static let axisYOffset: CGFloat = 4

    }

    // MARK: - Internal Properties

    var mode: TimelineChartMode = .free {
        didSet {
            setupXAsix()
        }
    }
    weak var eventsHandler: TimelineChartViewEventsHandler?

    // MARK: - Init & deinit

    private let isSmallScreen: Bool

    init(frame: CGRect,
         isSmallScreen: Bool) {
        self.isSmallScreen = isSmallScreen
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func setup() {
        setupChart()
        setupXAsix()
        setupYAxis()
    }

    // MARK: - Private

    override func notifyDataSetChanged() {
        super.notifyDataSetChanged()
        eventsHandler?.chartViewDataSetChanged()
    }

    // MARK: - Chart

    private func setupChart() {
        self.renderer = TimelineChartRenderer(dataProvider: self,
                                              isLeftToRightUI: isLeftToRightUI,
                                              animator: chartAnimator,
                                              viewPortHandler: viewPortHandler)

        highlightPerTapEnabled = false
        highlightPerDragEnabled = false
        doubleTapToZoomEnabled = false
        legend.enabled = false
        setScaleEnabled(false)

        extraLeftOffset = Self.axisLabelWidth / 2
        extraRightOffset = Self.axisLabelWidth / 2
        extraBottomOffset = Constant.bottomOffset
    }

    private func setupXAsix() {
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = true
        xAxis.drawGridLinesBehindDataEnabled = false
        xAxis.drawAxisLineEnabled = false
        if isSmallScreen {
            xAxis.labelFont = .systemFont(ofSize: 6.5, weight: .semibold)
            xAxis.labelHeight = 15.0
        }
        else {
            xAxis.labelFont = .systemFont(ofSize: 8, weight: .semibold)
            xAxis.labelHeight = 18.0
        }
        xAxis.labelTextColor = .textSecondary
        xAxis.yOffset = Constant.axisYOffset
        xAxis.axisMinimum = isLeftToRightUI ? mode.axisMinimum : -mode.axisMaximum
        xAxis.axisMaximum = isLeftToRightUI ? mode.axisMaximum : -mode.axisMinimum
        xAxis.valueFormatter = TimelineMinuteValueFormatter()
        xAxis.axisMaxLabels = mode.labelsCount
        xAxis.setLabelCount(mode.labelsCount, force: true)
        xAxis.gridColor = .standardTertiary.withAlphaComponent(0.5)
        xAxis.gridLineWidth = Constant.gridLineWidth

        let transformer = getTransformer(forAxis: .left)
        // We need custom axis renderer to draw circle, pointer outside chart data visible area
        let actualTimelinePosition = isLeftToRightUI ? mode.timelinePosition : -mode.timelinePosition
        xAxisRenderer = TimelineChartXAxisRenderer(timelinePosition: actualTimelinePosition,
                                                   timelineColor: .standardSecondary,
                                                   viewPortHandler: viewPortHandler,
                                                   axis: xAxis,
                                                   transformer: transformer)
        xAxisRenderer.computeSize()
    }

    private func setupYAxis() {
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawLabelsEnabled = false
        leftAxis.drawAxisLineEnabled = false
        leftAxis.xOffset = 0
        leftAxis.yOffset = 0
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 1
        leftAxis.inverted = true
        leftAxis.enabled = false

        rightAxis.enabled = false
    }

}
