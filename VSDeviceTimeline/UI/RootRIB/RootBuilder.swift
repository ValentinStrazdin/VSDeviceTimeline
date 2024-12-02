final class RootBuilder: Builder {

    // MARK: - Methods

    func build() -> ViewableRouter {
        let viewController = ContainerViewController()

        let interactor = RootInteractor()
        let router = RootRouterImpl(interactor: interactor,
                                    viewController: viewController)
        interactor.router = router

        return router
    }

}
