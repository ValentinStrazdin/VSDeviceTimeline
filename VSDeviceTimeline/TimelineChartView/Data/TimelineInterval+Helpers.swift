import Foundation

extension TimelineInterval {

    private static var blockIntervalStarts: [Minute] = [0, 120, 240, 360, 480, 600, 720, 840, 960, 1080, 1200, 1320]
    private static var firstIntervalStarts: [Minute] = [60, 180, 300, 420, 540, 660, 780, 900, 1020, 1140, 1260, 1380]
    private static var secondIntervalStarts: [Minute] = [90, 210, 330, 450, 570, 690, 810, 930, 1050, 1170, 1290, 1410]

    static var blockIntervals: [TimelineInterval] {
        let firstIntervals = blockIntervalStarts.map {
            TimelineInterval(start: $0, end: $0 + 40, type: .block)
        }
        let secondIntervals = blockIntervalStarts.map {
            TimelineInterval(start: $0 + 45, end: $0 + 60, type: .block)
        }
        return (firstIntervals + secondIntervals).sorted()
    }

    static var usageIntervals: [TimelineInterval] {
        let firstIntervals = firstIntervalStarts.map {
            TimelineInterval(start: $0 + 1, end: $0 + 11, type: .active)
        }
        let secondIntervals = firstIntervalStarts.map {
            TimelineInterval(start: $0 + 15, end: $0 + 20, type: .active)
        }
        let thirdIntervals = firstIntervalStarts.map {
            TimelineInterval(start: $0 + 24, end: $0 + 26, type: .active)
        }
        return (firstIntervals + secondIntervals + thirdIntervals).sorted()
    }

    static var overtimeIntervals: [TimelineInterval] {
        let firstIntervals = secondIntervalStarts.map {
            TimelineInterval(start: $0 + 1, end: $0 + 11, type: .overtime)
        }
        let secondIntervals = secondIntervalStarts.map {
            TimelineInterval(start: $0 + 14, end: $0 + 16, type: .overtime)
        }
        return (firstIntervals + secondIntervals).sorted()
    }

    static var additionalTimeIntervals: [TimelineInterval] {
        return secondIntervalStarts.map {
            TimelineInterval(start: $0 + 20, end: $0 + 23, type: .additionalTime)
        }.sorted()
    }

}
