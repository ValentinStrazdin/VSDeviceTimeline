import Foundation

enum DeviceWorkTimeline {

    struct ViewModel {

        let intervals: [TimelineInterval]
        let isLegendsHidden: Bool

        init(
            intervals: [TimelineInterval] = [],
            isLegendsHidden: Bool = true
        ) {
            self.intervals = intervals
            self.isLegendsHidden = isLegendsHidden
        }

    }

}
