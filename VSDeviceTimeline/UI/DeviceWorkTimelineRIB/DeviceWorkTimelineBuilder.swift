import UIKit

final class DeviceWorkTimelineBuilder: Builder {

    // MARK: - Private Properties

    private let factory: DeviceWorkTimelineComponentFactory
    private let listener: DeviceWorkTimelineListener?

    // MARK: - Init

    init(
        factory: DeviceWorkTimelineComponentFactory,
        listener: DeviceWorkTimelineListener? = nil
    ) {
        self.factory = factory
        self.listener = listener
    }

    // MARK: - Internal Methods

    func build() -> ViewableRouter {
        let component = factory.makeComponent()

        let dataManager = DeviceUsageTimelineDataManager()

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
            listener: listener,
            licenseStatusProvider: component.licenseStatusProvider,
            deviceControlSettingsProvider: component.deviceControlSettingsProvider,
            deviceUsageReportsManager: component.deviceUsageReportsManager,
            timelinePositionProvider: component.timelinePositionProvider
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

// MARK: - Component

extension DeviceWorkTimelineBuilder {

    struct Component {
        let licenseStatusProvider: LicenseStatusProvidable
        let deviceControlSettingsProvider: DeviceControlSettingsProvidable
        let deviceUsageReportsManager: DeviceUsageReportsManager
        let timelinePositionProvider: TimelinePositionProvidable
    }

}

// MARK: - Component Factory

protocol DeviceWorkTimelineComponentFactory: AnyObject {

    func makeComponent() -> DeviceWorkTimelineBuilder.Component

}

extension RootServicesProvider: DeviceWorkTimelineComponentFactory {

    func makeComponent() -> DeviceWorkTimelineBuilder.Component {
        .init(
            licenseStatusProvider: rootServicesContainer.licenseStatusProvider,
            deviceControlSettingsProvider: rootServicesContainer.deviceControlSettingsProvider,
            deviceUsageReportsManager: rootServicesContainer.deviceUsageReportsManager,
            timelinePositionProvider: TimelinePositionProvider()
        )
    }

}
