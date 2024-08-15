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

    func didTapFreeMode() {
        interactor?.updateLicenseStatus(.free)
    }
    
    func didTapPremiumMode() {
        interactor?.updateLicenseStatus(.premium)
    }

    func didTapAddIntervals(type: TimelineInterval.IntervalType) {
        interactor?.addIntervals(type: type)
    }

    func didTapRemoveIntervals(type: TimelineInterval.IntervalType) {
        interactor?.removeIntervals(type: type)
    }

}
