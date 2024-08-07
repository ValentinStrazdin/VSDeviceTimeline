import Foundation

protocol DeviceControlSettingsProvidable {

    func addObserver(_ observer: DeviceControlSettingsObserver)
    func removeObserver(_ observer: DeviceControlSettingsObserver)

    var settings: DeviceUsageControlSettings { get }
    func updateSettings(_ settings: DeviceUsageControlSettings)

}

protocol DeviceControlSettingsObserver: AnyObject {

    func deviceControlSettingsChanged(_ settings: DeviceUsageControlSettings)

}

final class DeviceControlSettingsProvider: DeviceControlSettingsProvidable, Observable {

    // MARK: - Private Properties

    private let observersNotificationQueue: DispatchQueue = .main

    private(set) var settings: DeviceUsageControlSettings

    // MARK: - Internal Properties

    let observers = ObserversCollection<DeviceControlSettingsObserver>()

    // MARK: - Init

    init(settings: DeviceUsageControlSettings) {
        self.settings = settings
    }

    // MARK: - Protocol DeviceControlSettingsProvidable

    func updateSettings(_ settings: DeviceUsageControlSettings) {
        self.settings = settings
        observersNotificationQueue.async { [weak self] in
            self?.observers.notify(with: { $0.deviceControlSettingsChanged(settings) })
        }
    }

}
