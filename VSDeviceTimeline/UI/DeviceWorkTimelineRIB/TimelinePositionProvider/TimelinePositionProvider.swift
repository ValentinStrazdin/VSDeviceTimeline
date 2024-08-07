import Foundation

protocol TimelinePositionProvidable {

    var timelinePosition: CGFloat { get }
    var currentTime: Double { get }

}

extension TimelinePositionProvidable {

    var timelinePosition: CGFloat {
        CGFloat(currentTime)
    }

}

final class TimelinePositionProvider: TimelinePositionProvidable {

    var currentTime: Double {
        let date = Date.now
        let startOfDay = Calendar.current.startOfDay(for: date)
        let secondsSinceMidnight = date.timeIntervalSince(startOfDay)
        return secondsSinceMidnight / 60
    }

}
