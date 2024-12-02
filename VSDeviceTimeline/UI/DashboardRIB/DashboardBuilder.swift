final class DashboardBuilder: Builder {

    // MARK: - Internal Methods

    func build() -> ViewableRouter {
        let view = DashboardViewImpl.makeView()

        let presenter = DashboardPresenterImpl()
        presenter.view = view

        let interactor = DashboardInteractorImpl(
            presenter: presenter
        )
        presenter.interactor = interactor

        let router = DashboardRouterImpl(
            interactor: interactor, 
            view: view,
            subviewsContainer: view
        )
        interactor.router = router

        return router
    }

}
