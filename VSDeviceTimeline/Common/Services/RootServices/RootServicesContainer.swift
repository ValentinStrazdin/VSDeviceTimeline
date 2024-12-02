import Foundation

protocol RootServicesContainer: AnyObject {

    var licenseStatusProvider: LicenseStatusProvidable { get }
}

final class RootServicesContainerImpl: NSObject, RootServicesContainer {

    // MARK: - Internal Properties

    // MARK: RootServicesContainer

    let licenseStatusProvider: LicenseStatusProvidable

    // MARK: - Init

    override init() {
        self.licenseStatusProvider = LicenseStatusProvider(licenseStatus: .premium)
    }

}
