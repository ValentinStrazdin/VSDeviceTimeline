import UIKit

final class DeviceWorkTimelineBuilder: Builder {

    // MARK: - Internal Methods

    func build() -> ViewableRouter {
        let dataManager = DeviceUsageTimelineDataManager()
        let timelinePositionProvider = TimelinePositionProvider()

        let view = DeviceWorkTimelineViewImpl.makeView(
            legendsDataSource: dataManager
        )

        let presenter = DeviceWorkTimelinePresenterImpl(
            dataManager: dataManager
        )
        presenter.view = view
        view.eventsHandler = presenter

        let interactor = DeviceWorkTimelineInteractorImpl(
            presenter: presenter,
            timelinePositionProvider: timelinePositionProvider
        )
        presenter.interactor = interactor

        let router = DeviceWorkTimelineRouterImpl(
            interactor: interactor,
            view: view
        )
        interactor.router = router

        return router
    }

}
