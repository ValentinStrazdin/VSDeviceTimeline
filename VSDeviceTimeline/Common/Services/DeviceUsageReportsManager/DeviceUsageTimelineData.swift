import Foundation

public struct DeviceUsageTimelineData: Equatable {

    static var empty: DeviceUsageTimelineData = .init()

    var intervals: [TimelineInterval]?

}
