// MARK: - Protocol

protocol DashboardListener: AnyObject {
    
    // TODO: DashboardListener is an output of Dashboard RIB
    
}

protocol DashboardInteractor: AnyObject {

    // TODO: DashboardInteractor contract for DashboardPresenter

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

        // TODO: Implement
    }

    // MARK: - Override Interactor

    override func start() {
        super.start()

        router?.attachDeviceWorkTimeline()
    }

    override func stop() {
        // TODO: Implement

        super.stop()
    }

}

// MARK: - Protocol DashboardInteractor

extension DashboardInteractorImpl: DashboardInteractor {

    // TODO: Implement DashboardInteractor protocol

}
