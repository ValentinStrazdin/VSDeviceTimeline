import UIKit

// MARK: - Protocol

protocol DeviceWorkTimelineListener: AnyObject { }

protocol DeviceWorkTimelineInteractor: AnyObject { }

// MARK: - Implementation

final class DeviceWorkTimelineInteractorImpl: BaseInteractor {

    // MARK: - Internal Properties

    weak var router: DeviceWorkTimelineRouter?

    // MARK: - Private Properties

    private let presenter: DeviceWorkTimelinePresenter
    private weak var listener: DeviceWorkTimelineListener?
    private let licenseStatusProvider: LicenseStatusProvidable
    private let deviceUsageReportsManager: DeviceUsageReportsManager
    private let timelinePositionProvider: TimelinePositionProvidable

    // MARK: - Init

    init(presenter: DeviceWorkTimelinePresenter,
         listener: DeviceWorkTimelineListener?,
         licenseStatusProvider: LicenseStatusProvidable,
         deviceUsageReportsManager: DeviceUsageReportsManager,
         timelinePositionProvider: TimelinePositionProvidable) {

        self.presenter = presenter
        self.listener = listener
        self.licenseStatusProvider = licenseStatusProvider
        self.deviceUsageReportsManager = deviceUsageReportsManager
        self.timelinePositionProvider = timelinePositionProvider
    }

    // MARK: - Override Interactor

    override func start() {
        super.start()

        startObserving()
        configure()
    }

    override func stop() {
        stopObserving()

        super.stop()
    }

    // MARK: - Observing

    private func startObserving() {
        licenseStatusProvider.addObserver(self)
        deviceUsageReportsManager.addObserver(self)
    }

    private func stopObserving() {
        licenseStatusProvider.removeObserver(self)
        deviceUsageReportsManager.removeObserver(self)
    }

    private func configure() {
        switch licenseStatusProvider.licenseStatus {
        case .free:
            DispatchQueue.main.async { [weak self] in
                self?.presenter.presentFreeMode()
            }

        case .premium:
            let timelinePosition = self.timelinePositionProvider.timelinePosition
            let timelineData = deviceUsageReportsManager.timelineData
            DispatchQueue.main.async { [weak self] in
                self?.presenter.presentPremium(
                    timelinePosition: timelinePosition,
                    timelineData: timelineData
                )
            }
        }
    }

}

extension DeviceWorkTimelineInteractorImpl: DeviceWorkTimelineInteractor { }

// MARK: - Protocol LicenseStatusObserver

extension DeviceWorkTimelineInteractorImpl: LicenseStatusObserver {

    func licenseStatusChanged(_ licenseStatus: LicenseStatus) {
        configure()
    }

}

// MARK: - Protocol DeviceUsageReportsManagerObserver

extension DeviceWorkTimelineInteractorImpl: DeviceUsageReportsManagerObserver {

    func didLoadTimeline(_ timelineData: DeviceUsageTimelineData) {
        configure()
    }

}
