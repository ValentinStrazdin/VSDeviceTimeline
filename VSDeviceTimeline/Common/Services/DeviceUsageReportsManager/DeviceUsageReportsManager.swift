import Combine
import Foundation

protocol DeviceUsageReportsManagerObserver: AnyObject {

    func didLoadTimeline(_ timelineData: DeviceUsageTimelineData)

}

protocol DeviceUsageReportsManager {
    func addObserver(_ observer: DeviceUsageReportsManagerObserver)
    func removeObserver(_ observer: DeviceUsageReportsManagerObserver)

    var timelineData: DeviceUsageTimelineData? { get }
    func updateTimelineData(_ timelineData: DeviceUsageTimelineData)
}

final class DeviceUsageReportsManagerImpl: DeviceUsageReportsManager, Observable {

    // MARK: - Private Properties

    private let observersNotificationQueue: DispatchQueue = .main

    private(set) var timelineData: DeviceUsageTimelineData?

    // MARK: - Internal Properties

    let observers = ObserversCollection<DeviceUsageReportsManagerObserver>()

    // MARK: - Init

    init(timelineData: DeviceUsageTimelineData? = nil) {
        self.timelineData = timelineData
    }

    // MARK: - Protocol DeviceUsageReportsManager

    func updateTimelineData(_ timelineData: DeviceUsageTimelineData) {
        self.timelineData = timelineData
        observersNotificationQueue.async { [weak self] in
            self?.observers.notify(with: { $0.didLoadTimeline(timelineData) })
        }
    }

}
