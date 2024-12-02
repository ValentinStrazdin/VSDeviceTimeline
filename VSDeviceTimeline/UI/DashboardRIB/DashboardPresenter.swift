// MARK: - Protocol

protocol DashboardPresenter: AnyObject { }

// MARK: - Implementation

final class DashboardPresenterImpl {

    // MARK: - Internal Properties

    weak var interactor: DashboardInteractor?
    weak var view: DashboardView?

    // MARK: - Init

    init() { }

}

// MARK: - Protocol DashboardPresenter

extension DashboardPresenterImpl: DashboardPresenter { }

// MARK: - Protocol DashboardViewEventsHandler

extension DashboardPresenterImpl: DashboardViewEventsHandler {

    func didChangeLicenseType(isFreeMode: Bool) {
        let licenseStatus: LicenseStatus = isFreeMode ? .free : .premium
        interactor?.updateLicenseStatus(licenseStatus)
    }

}
