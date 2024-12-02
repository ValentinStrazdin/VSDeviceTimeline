final class DashboardBuilder: Builder {

    // MARK: - Private Properties

    private let factory: DashboardComponentFactory
    private let listener: DashboardListener?

    // MARK: - Init

    init(factory: DashboardComponentFactory, 
         listener: DashboardListener? = nil) {

        self.factory = factory
        self.listener = listener
    }

    // MARK: - Internal Methods

    func build() -> ViewableRouter {
        let view = DashboardViewImpl.makeView()

        let presenter = DashboardPresenterImpl()
        presenter.view = view
        view.eventsHandler = presenter

        let component = factory.makeComponent()
        let interactor = DashboardInteractorImpl(
            presenter: presenter,
            listener: listener,
            licenseStatusProvider: component.licenseStatusProvider
        )
        presenter.interactor = interactor

        let router = DashboardRouterImpl(
            interactor: interactor, 
            view: view,
            rootServicesProvider: component.rootServicesProvider,
            subviewsContainer: view
        )
        interactor.router = router

        return router
    }

}

// MARK: - Component

extension DashboardBuilder {

    struct Component {
        let licenseStatusProvider: LicenseStatusProvidable
        
        let rootServicesProvider: RootServicesProvider
    }

}

// MARK: - Component Factory

protocol DashboardComponentFactory: AnyObject {

    func makeComponent() -> DashboardBuilder.Component
    
}

extension RootServicesProvider: DashboardComponentFactory {

    func makeComponent() -> DashboardBuilder.Component {
        .init(
            licenseStatusProvider: rootServicesContainer.licenseStatusProvider,
            rootServicesProvider: self
        )
    }

}
