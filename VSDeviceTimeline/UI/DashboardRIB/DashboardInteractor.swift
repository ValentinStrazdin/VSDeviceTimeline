// MARK: - Protocol

protocol DashboardInteractor: AnyObject { }

// MARK: - Implementation

final class DashboardInteractorImpl: BaseInteractor {

    // MARK: - Internal Properties

    weak var router: DashboardRouter?

    // MARK: - Private Properties

    private let presenter: DashboardPresenter

    // MARK: - Init

    init(presenter: DashboardPresenter) {

        self.presenter = presenter
    }

    // MARK: - Override Interactor

    override func start() {
        super.start()

        router?.attachDeviceWorkTimeline()
    }

}

// MARK: - Protocol DashboardInteractor

extension DashboardInteractorImpl: DashboardInteractor { }
