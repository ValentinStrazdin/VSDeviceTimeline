import Foundation

public struct TimelineInterval: Comparable, Equatable {

    // MARK: - Types

    public typealias Minute = Double

    public let start: Minute
    public let end: Minute
    public let type: IntervalType

    public init(start: Minute, end: Minute, type: IntervalType = .active) {
        self.start = start
        self.end = end
        self.type = type
    }

    var length: Minute {
        end - start
    }

    /// Inverted interval for right to left orientation
    var inverted: TimelineInterval {
        .init(start: -end, end: -start, type: type)
    }

    func contains(time: Double) -> Bool {
        time >= start && time <= end
    }

    func isAfter(time: Double) -> Bool {
        start > time
    }

    // MARK: - Protocol Comparable

    public static func < (lhs: TimelineInterval, rhs: TimelineInterval) -> Bool {
        lhs.start < rhs.start
    }

}

// MARK: - Extensions

public extension TimelineInterval {

    enum IntervalType {
        case active
        case additionalTime
        case overtime
        case block
    }

}
