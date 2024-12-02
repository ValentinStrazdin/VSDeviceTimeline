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
    private let timelinePositionProvider: TimelinePositionProvidable

    // MARK: - Init

    init(presenter: DeviceWorkTimelinePresenter,
         listener: DeviceWorkTimelineListener?,
         licenseStatusProvider: LicenseStatusProvidable,
         timelinePositionProvider: TimelinePositionProvidable) {

        self.presenter = presenter
        self.listener = listener
        self.licenseStatusProvider = licenseStatusProvider
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
    }

    private func stopObserving() {
        licenseStatusProvider.removeObserver(self)
    }

    private func configure() {
        switch licenseStatusProvider.licenseStatus {
        case .free:
            DispatchQueue.main.async { [weak self] in
                self?.presenter.presentFreeMode()
            }

        case .premium:
            let timelinePosition = self.timelinePositionProvider.timelinePosition
            let timelineIntervals = TimelineInterval.allIntervals
            DispatchQueue.main.async { [weak self] in
                self?.presenter.presentPremium(
                    timelinePosition: timelinePosition,
                    timelineIntervals: timelineIntervals
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
