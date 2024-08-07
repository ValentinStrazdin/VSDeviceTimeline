import DGCharts
import Foundation

final class TimelineChartXAxisRenderer: XAxisRenderer {

    private enum Constant {

        static let timelineWidth: CGFloat = 2
        static let circleRadius: CGFloat = 6
        static let pointerHeight: CGFloat = 10
        static let pointerWidth: CGFloat = 12

    }

    // MARK: - Properties

    private let timelinePosition: CGFloat
    private let timelineColor: UIColor

    init(timelinePosition: CGFloat,
         timelineColor: UIColor,
         viewPortHandler: ViewPortHandler,
         axis: XAxis,
         transformer: Transformer?) {
        self.timelinePosition = timelinePosition
        self.timelineColor = timelineColor
        super.init(viewPortHandler: viewPortHandler, axis: axis, transformer: transformer)
    }

    // MARK: - Override Methods

    override func renderGridLines(context: CGContext) {
        super.renderGridLines(context: context)
        // Here we can draw elements on top of data
        drawTimelinePosition(in: context)
    }

    override func renderAxisLine(context: CGContext) {
        // Here we can draw elements outside visible graph area
        drawCircle(in: context)
        drawPointer(in: context)
        drawTimelinePosition(in: context)
    }

    private func drawTimelinePosition(in context: CGContext) {
        guard let transformer = transformer else {
            return
        }

        context.saveGState()
        defer { context.restoreGState() }

        var lineStart = CGPoint(x: timelinePosition, y: 0)
        var lineEnd = CGPoint(x: timelinePosition, y: 1)
        transformer.pointValueToPixel(&lineStart)
        transformer.pointValueToPixel(&lineEnd)

        context.setStrokeColor(timelineColor.cgColor)
        context.setFillColor(timelineColor.cgColor)

        context.setLineWidth(Constant.timelineWidth)

        // Draw line
        context.move(to: lineStart)
        context.addLine(to: CGPoint(x: lineEnd.x, y: lineEnd.y - Constant.pointerHeight / 2))
        context.strokePath()
    }

    private func drawCircle(in context: CGContext) {
        guard let transformer = transformer else {
            return
        }

        context.saveGState()
        defer { context.restoreGState() }

        var lineStart = CGPoint(x: timelinePosition, y: 0)
        transformer.pointValueToPixel(&lineStart)

        context.setFillColor(timelineColor.cgColor)
        context.addEllipse(in: CGRect(x: lineStart.x - Constant.circleRadius,
                                      y: lineStart.y - Constant.circleRadius,
                                      width: Constant.circleRadius * 2,
                                      height: Constant.circleRadius * 2))
        context.fillPath()
    }

    private func drawPointer(in context: CGContext) {
        guard let transformer = transformer else {
            return
        }

        context.saveGState()
        defer { context.restoreGState() }

        var lineEnd = CGPoint(x: timelinePosition, y: 1)
        transformer.pointValueToPixel(&lineEnd)

        context.setFillColor(timelineColor.cgColor)
        context.move(to: lineEnd)
        context.addLine(to: CGPoint(x: lineEnd.x - Constant.pointerWidth / 2,
                                    y: lineEnd.y - Constant.pointerHeight))
        context.addLine(to: CGPoint(x: lineEnd.x + Constant.pointerWidth / 2,
                                    y: lineEnd.y - Constant.pointerHeight))
        context.addLine(to: lineEnd)
        context.fillPath()
    }

}
