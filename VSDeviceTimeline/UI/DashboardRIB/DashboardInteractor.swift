// MARK: - Protocol

protocol DashboardListener: AnyObject {
    
    // TODO: DashboardListener is an output of Dashboard RIB
    
}

protocol DashboardInteractor: AnyObject {

    func updateLicenseStatus(_ licenseStatus: LicenseStatus)
    func addIntervals(type: TimelineInterval.IntervalType)
    func removeIntervals(type: TimelineInterval.IntervalType)

}

// MARK: - Implementation

final class DashboardInteractorImpl: BaseInteractor {

    // MARK: - Internal Properties

    weak var router: DashboardRouter?

    // MARK: - Private Properties

    private let presenter: DashboardPresenter
    private weak var listener: DashboardListener?
    private let licenseStatusProvider: LicenseStatusProvidable
    private let deviceControlSettingsProvider: DeviceControlSettingsProvidable
    private let deviceUsageReportsManager: DeviceUsageReportsManager

    private var timelineIntervals: [TimelineInterval]?
    private var forbiddenIntervals: [TimelineInterval]?

    // MARK: - Init

    init(presenter: DashboardPresenter,
         listener: DashboardListener?,
         licenseStatusProvider: LicenseStatusProvidable,
         deviceControlSettingsProvider: DeviceControlSettingsProvidable,
         deviceUsageReportsManager: DeviceUsageReportsManager) {

        self.presenter = presenter
        self.listener = listener
        self.licenseStatusProvider = licenseStatusProvider
        self.deviceControlSettingsProvider = deviceControlSettingsProvider
        self.deviceUsageReportsManager = deviceUsageReportsManager

        self.timelineIntervals = deviceUsageReportsManager.timelineData?.intervals
        self.forbiddenIntervals = deviceControlSettingsProvider.settings.forbiddenIntervals

        // TODO: Implement
    }

    // MARK: - Override Interactor

    override func start() {
        super.start()

        router?.attachDeviceWorkTimeline()
    }

    // MARK: - Private Methods

    private func updateTimelineIntervals(_ intervals: [TimelineInterval]) {
        timelineIntervals?.append(contentsOf: intervals)
        let timelineData = DeviceUsageTimelineData(intervals: timelineIntervals)
        deviceUsageReportsManager.updateTimelineData(timelineData)
    }

    private func removeTimelineIntervals(type: TimelineInterval.IntervalType) {
        timelineIntervals?.removeAll(where: { $0.type == type })
        let timelineData = DeviceUsageTimelineData(intervals: timelineIntervals)
        deviceUsageReportsManager.updateTimelineData(timelineData)
    }

    private func updateForbiddenIntervals(_ intervals: [TimelineInterval]?) {
        forbiddenIntervals = intervals
        let settings = DeviceUsageControlSettings(forbiddenIntervals: forbiddenIntervals)
        deviceControlSettingsProvider.updateSettings(settings)
    }

}

// MARK: - Protocol DashboardInteractor

extension DashboardInteractorImpl: DashboardInteractor {

    func updateLicenseStatus(_ licenseStatus: LicenseStatus) {
        licenseStatusProvider.updateLicenseStatus(licenseStatus)
    }

    func addIntervals(type: TimelineInterval.IntervalType) {
        guard licenseStatusProvider.licenseStatus == .premium else {
            return
        }

        if let timelineIntervals, !timelineIntervals.filter({ $0.type == type }).isEmpty {
            return
        }

        switch type {
        case .active:
            updateTimelineIntervals(TimelineInterval.usageIntervals)

        case .additionalTime:
            updateTimelineIntervals(TimelineInterval.additionalTimeIntervals)

        case .overtime:
            updateTimelineIntervals(TimelineInterval.overtimeIntervals)

        case .block:
            updateForbiddenIntervals(TimelineInterval.blockIntervals)
        }
    }

    func removeIntervals(type: TimelineInterval.IntervalType) {
        guard licenseStatusProvider.licenseStatus == .premium else {
            return
        }

        switch type {
        case .active, .additionalTime, .overtime:
            removeTimelineIntervals(type: type)

        case .block:
            updateForbiddenIntervals(nil)
        }
    }

}
