import UIKit

// MARK: - Protocol

protocol RootRouter: ViewableRouter {

    func attachDashboard()

}

// MARK: - Implementation

final class RootRouterImpl: BaseRouter, ViewableRouter {

    // MARK: - Internal Properties

    var viewController: UIViewController {
        return controller
    }

    // MARK: - Private Properties

    private let controller: ContainerViewController
    private let rootServicesProvider: RootServicesProvider

    private var childRouter: ViewableRouter?

    // MARK: - Init

    init(interactor: RootInteractor,
         viewController: ContainerViewController,
         rootServicesProvider: RootServicesProvider) {

        self.controller = viewController
        self.rootServicesProvider = rootServicesProvider

        super.init(interactor: interactor)
    }

    // MARK: - Override BaseRouter

    override func stop() {
        detachAll()

        super.stop()
    }

    // MARK: - Private Methods

    private func attachAndEmbed(_ router: ViewableRouter) {
        attach(router)
        controller.embed(child: router.viewController)
    }

    private func attach(_ router: ViewableRouter) {
        childRouter?.stop()
        childRouter = router
        router.start()
    }

    private func detachAll() {
        childRouter?.stop()
        childRouter = nil
    }

}

// MARK: - Protocol RootRouter

extension RootRouterImpl: RootRouter {

    func attachDashboard() {
        let router = DashboardBuilder(
            factory: rootServicesProvider
        ).build()
        attachAndEmbed(router)
    }

}
