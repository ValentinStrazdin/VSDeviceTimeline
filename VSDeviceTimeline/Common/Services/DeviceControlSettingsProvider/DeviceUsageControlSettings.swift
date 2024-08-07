struct DeviceUsageControlSettings: Equatable {

    var forbiddenIntervals: [TimelineInterval]?

    init(forbiddenIntervals: [TimelineInterval]? = nil) {
        self.forbiddenIntervals = forbiddenIntervals
    }

}
