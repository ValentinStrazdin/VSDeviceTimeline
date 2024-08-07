// MARK: - Protocol

protocol DashboardPresenter: AnyObject {

    // TODO: DashboardPresenter contract for DashboardInteractor

}

// MARK: - Implementation

final class DashboardPresenterImpl {

    // MARK: - Internal Properties

    weak var interactor: DashboardInteractor?
    weak var view: DashboardView?

    // MARK: - Private Properties

    // TODO: Implement

    // MARK: - Init

    init() {
        // TODO: Implement
    }

}

// MARK: - Protocol DashboardPresenter

extension DashboardPresenterImpl: DashboardPresenter {

    // TODO: Implement DashboardPresenter protocol

}

// MARK: - Protocol DashboardViewEventsHandler

extension DashboardPresenterImpl: DashboardViewEventsHandler {

    // TODO: Implement DashboardViewEventsHandler protocol

}
