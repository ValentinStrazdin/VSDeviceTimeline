final class RootBuilder: Builder {

    // MARK: - Private Properties

    private let factory: RootComponentFactory

    // MARK: - Init

    init(factory: RootComponentFactory) {
        self.factory = factory
    }

    // MARK: - Methods

    func build() -> ViewableRouter {
        let component = factory.makeComponent()
        let viewController = ContainerViewController()

        let interactor = RootInteractor()
        let router = RootRouterImpl(interactor: interactor,
                                    viewController: viewController,
                                    rootServicesProvider: component.rootServicesProvider)
        interactor.router = router

        return router
    }

}

// MARK: - Component

extension RootBuilder {

    struct Component {
        let rootServicesProvider: RootServicesProvider
    }

}

// MARK: - Component Factory

protocol RootComponentFactory: AnyObject {

    func makeComponent() -> RootBuilder.Component

}

extension RootServicesProvider: RootComponentFactory {

    func makeComponent() -> RootBuilder.Component {
        .init(rootServicesProvider: self)
    }

}
