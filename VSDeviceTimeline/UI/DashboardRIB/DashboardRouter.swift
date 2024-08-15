import UIKit

// MARK: - Protocol

protocol DashboardRouter: AnyObject {

    func attachDeviceWorkTimeline()

}

// MARK: - Implementation

final class DashboardRouterImpl: BaseRouter, ViewableRouter {

    // MARK: - Internal Properties

    let viewController: UIViewController

    // MARK: - Private Properties

    private let rootServicesProvider: RootServicesProvider
    private let subviewsContainer: DashboardEmbedable

    private var childRouter: ViewableRouter?

    // MARK: - Init

    init(interactor: Interactor, 
         view: UIViewController,
         rootServicesProvider: RootServicesProvider,
         subviewsContainer: DashboardEmbedable) {
        self.viewController = view
        self.rootServicesProvider = rootServicesProvider
        self.subviewsContainer = subviewsContainer

        super.init(interactor: interactor)
    }

    // MARK: - Override BaseRouter

    override func stop() {
        detachAll()

        super.stop()
    }

    // MARK: - Private Methods

    private func detachAll() {
        childRouter?.stop()
        childRouter = nil
    }

}

// MARK: - Protocol DashboardRouter

extension DashboardRouterImpl: DashboardRouter {

    func attachDeviceWorkTimeline() {
        let router = DeviceWorkTimelineBuilder(
            factory: rootServicesProvider
        ).build()
        guard let deviceWorkTimeView = router.viewController.view else {
            assertionFailure("DeviceWorkTimelineView should be created")
            return
        }
        childRouter = router
        subviewsContainer.embedDeviceWorkTimelineView(deviceWorkTimeView)
        router.start()
    }

}
