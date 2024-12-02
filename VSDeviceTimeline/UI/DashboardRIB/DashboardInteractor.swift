// MARK: - Protocol

protocol DashboardListener: AnyObject { }

protocol DashboardInteractor: AnyObject {

    func updateLicenseStatus(_ licenseStatus: LicenseStatus)

}

// MARK: - Implementation

final class DashboardInteractorImpl: BaseInteractor {

    // MARK: - Internal Properties

    weak var router: DashboardRouter?

    // MARK: - Private Properties

    private let presenter: DashboardPresenter
    private weak var listener: DashboardListener?
    private let licenseStatusProvider: LicenseStatusProvidable

    // MARK: - Init

    init(presenter: DashboardPresenter,
         listener: DashboardListener?,
         licenseStatusProvider: LicenseStatusProvidable) {

        self.presenter = presenter
        self.listener = listener
        self.licenseStatusProvider = licenseStatusProvider
    }

    // MARK: - Override Interactor

    override func start() {
        super.start()

        router?.attachDeviceWorkTimeline()
    }

}

// MARK: - Protocol DashboardInteractor

extension DashboardInteractorImpl: DashboardInteractor {

    func updateLicenseStatus(_ licenseStatus: LicenseStatus) {
        licenseStatusProvider.updateLicenseStatus(licenseStatus)
    }

}
