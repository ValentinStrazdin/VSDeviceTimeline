import Foundation

public struct TimelineInterval: Comparable, Equatable {

    // MARK: - Public Types

    public enum IntervalType {
        case active
        case additionalTime
        case overtime
        case block
    }

    public typealias Minute = Double

    // MARK: - Public Properties

    public let start: Minute
    public let end: Minute
    public let type: IntervalType

    // MARK: - Internal Properties

    var length: Minute {
        end - start
    }

    /// Inverted interval for right to left orientation
    var inverted: TimelineInterval {
        .init(start: -end, end: -start, type: type)
    }

    // MARK: - Init

    public init(start: Minute, end: Minute, type: IntervalType = .active) {
        self.start = start
        self.end = end
        self.type = type
    }

    // MARK: - Protocol Comparable

    public static func < (lhs: TimelineInterval, rhs: TimelineInterval) -> Bool {
        lhs.start < rhs.start
    }

}
