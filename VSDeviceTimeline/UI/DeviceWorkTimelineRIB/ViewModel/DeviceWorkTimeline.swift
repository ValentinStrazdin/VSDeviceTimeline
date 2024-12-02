import Foundation

enum DeviceWorkTimeline {

    struct ViewModel {

        let intervals: [TimelineInterval]
        let timelinePosition: CGFloat

        init(
            intervals: [TimelineInterval] = [],
            timelinePosition: CGFloat
        ) {
            self.intervals = intervals
            self.timelinePosition = timelinePosition
        }

    }

}
