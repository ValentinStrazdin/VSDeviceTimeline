import Foundation

protocol RootServicesContainer: AnyObject {

    var licenseStatusProvider: LicenseStatusProvidable { get }
    var deviceControlSettingsProvider: DeviceControlSettingsProvidable { get }
    var deviceUsageReportsManager: DeviceUsageReportsManager { get }
}

final class RootServicesContainerImpl: NSObject, RootServicesContainer {

    // MARK: - Internal Properties

    // MARK: RootServicesContainer

    let licenseStatusProvider: LicenseStatusProvidable
    let deviceControlSettingsProvider: DeviceControlSettingsProvidable
    let deviceUsageReportsManager: DeviceUsageReportsManager

    // MARK: - Init

    override init() {
        self.licenseStatusProvider = LicenseStatusProvider(licenseStatus: .premium)

        let settings = DeviceUsageControlSettings(forbiddenIntervals: [])
        let timelineData = DeviceUsageTimelineData(intervals: [])
        self.deviceControlSettingsProvider = DeviceControlSettingsProvider(settings: settings)
        self.deviceUsageReportsManager = DeviceUsageReportsManagerImpl(timelineData: timelineData)
    }

}
