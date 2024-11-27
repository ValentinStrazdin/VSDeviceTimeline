import Foundation

protocol RootServicesContainer: AnyObject {

    var licenseStatusProvider: LicenseStatusProvidable { get }
    var deviceUsageReportsManager: DeviceUsageReportsManager { get }
}

final class RootServicesContainerImpl: NSObject, RootServicesContainer {

    // MARK: - Internal Properties

    // MARK: RootServicesContainer

    let licenseStatusProvider: LicenseStatusProvidable
    let deviceUsageReportsManager: DeviceUsageReportsManager

    // MARK: - Init

    override init() {
        self.licenseStatusProvider = LicenseStatusProvider(licenseStatus: .premium)

        let timelineData = DeviceUsageTimelineData(intervals: [])
        self.deviceUsageReportsManager = DeviceUsageReportsManagerImpl(timelineData: timelineData)
    }

}
