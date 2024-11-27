import UIKit
import DGCharts

final class TimelineChartRenderer: BarLineScatterCandleBubbleRenderer {

    // MARK: - Private Properties

    private weak var dataProvider: BarLineScatterCandleBubbleChartDataProvider?
    private let isLeftToRightUI: Bool

    // MARK: - Init & deinit

    init(dataProvider: BarLineScatterCandleBubbleChartDataProvider,
         isLeftToRightUI: Bool,
         animator: Animator,
         viewPortHandler: ViewPortHandler) {
        self.dataProvider = dataProvider
        self.isLeftToRightUI = isLeftToRightUI
        super.init(animator: animator, viewPortHandler: viewPortHandler)
    }

    // MARK: - Overrides

    override func drawData(context: CGContext) {
        guard let data = dataProvider?.data,
              let dataSets = data.dataSets as? [BarLineScatterCandleBubbleChartDataSet],
              let dataSet = dataSets.first(where: { $0.isVisible }),
              !dataSet.isEmpty,
              let dataProvider = dataProvider else {
            return
        }

        let transformer = dataProvider.getTransformer(forAxis: dataSet.axisDependency)

        for entryIndex in 0..<dataSet.count {
            guard let entry = dataSet[entryIndex] as? TimelineChartDataEntry else {
                continue
            }
            
            drawInterval(for: entry, with: transformer, in: context)
        }
    }

    override func drawExtras(context: CGContext) { /* Not supported */ }
    override func drawValues(context: CGContext) { /* Not supported */ }
    override func drawHighlighted(context: CGContext, indices: [Highlight]) { /* Not supported */ }

    // MARK: - Private

    private func drawInterval(for entry: TimelineChartDataEntry,
                              with transformer: Transformer,
                              in context: CGContext) {
        context.saveGState()
        defer { context.restoreGState() }

        var entryRect = entry.entryRect
        transformer.rectValueToPixel(&entryRect)

        if let gradientColors = entry.gradientColors {
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colors = gradientColors.map { $0.cgColor }
            let locations: [CGFloat] = [0.0, 1.0]
            guard let gradient = CGGradient(colorsSpace: colorSpace,
                                            colors: colors as CFArray,
                                            locations: locations) else {
                return
            }
            let startPoint = isLeftToRightUI ? entryRect.bottomLeftCorner : entryRect.bottomRightCorner
            let endPoint = isLeftToRightUI ? entryRect.topRightCorner : entryRect.topLeftCorner

            let options = CGGradientDrawingOptions()
            context.addRect(entryRect)
            context.clip()
            context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: options)
        }
        else {
            context.setFillColor(entry.color.cgColor)
            context.fill(entryRect)
        }
    }

}

private extension CGRect {

    var topLeftCorner: CGPoint {
        origin
    }

    var topRightCorner: CGPoint {
        .init(x: origin.x + size.width, y: origin.y)
    }

    var bottomLeftCorner: CGPoint {
        .init(x: origin.x, y: origin.y + size.height)
    }

    var bottomRightCorner: CGPoint {
        .init(x: origin.x + size.width, y: origin.y + size.height)
    }
}
