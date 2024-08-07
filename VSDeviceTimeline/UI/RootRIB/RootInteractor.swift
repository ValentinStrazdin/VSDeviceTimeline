final class RootInteractor: BaseInteractor {

    // MARK: - Internal Properties

    weak var router: RootRouter?

    // MARK: - Internal Methods

    override func start() {
        super.start()

        router?.attachDashboard()
    }

}
