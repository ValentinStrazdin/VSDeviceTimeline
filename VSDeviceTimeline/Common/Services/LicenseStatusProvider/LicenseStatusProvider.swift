import Foundation

protocol LicenseStatusProvidable {

    func addObserver(_ observer: LicenseStatusObserver)
    func removeObserver(_ observer: LicenseStatusObserver)

    var licenseStatus: LicenseStatus { get }
    func updateLicenseStatus(_ licenseStatus: LicenseStatus)

}

protocol LicenseStatusObserver: AnyObject {

    func licenseStatusChanged(_ licenseStatus: LicenseStatus)

}

final class LicenseStatusProvider: LicenseStatusProvidable, Observable {

    // MARK: - Private Properties

    private let observersNotificationQueue: DispatchQueue = .main

    private(set) var licenseStatus: LicenseStatus

    // MARK: - Internal Properties

    let observers = ObserversCollection<LicenseStatusObserver>()

    // MARK: - Init

    init(licenseStatus: LicenseStatus) {
        self.licenseStatus = licenseStatus
    }

    // MARK: - Protocol LicenseStatusProvidable

    func updateLicenseStatus(_ licenseStatus: LicenseStatus) {
        self.licenseStatus = licenseStatus
        observersNotificationQueue.async { [weak self] in
            self?.observers.notify(with: { $0.licenseStatusChanged(licenseStatus) })
        }
    }
}
