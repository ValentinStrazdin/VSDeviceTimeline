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
