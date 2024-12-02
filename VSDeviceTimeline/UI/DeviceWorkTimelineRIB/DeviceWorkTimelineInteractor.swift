import UIKit

// MARK: - Protocol

protocol DeviceWorkTimelineInteractor: AnyObject { }

// MARK: - Implementation

final class DeviceWorkTimelineInteractorImpl: BaseInteractor {

    // MARK: - Internal Properties

    weak var router: DeviceWorkTimelineRouter?

    // MARK: - Private Properties

    private let presenter: DeviceWorkTimelinePresenter
    private let timelinePositionProvider: TimelinePositionProvidable

    // MARK: - Init

    init(presenter: DeviceWorkTimelinePresenter,
         timelinePositionProvider: TimelinePositionProvidable) {

        self.presenter = presenter
        self.timelinePositionProvider = timelinePositionProvider
    }

    // MARK: - Override Interactor

    override func start() {
        super.start()

        configure()
    }

    private func configure() {
        let viewModel = DeviceWorkTimeline.ViewModel(
            intervals: TimelineInterval.allIntervals,
            timelinePosition: timelinePositionProvider.timelinePosition
        )
        DispatchQueue.main.async { [weak self] in
            self?.presenter.present(viewModel: viewModel)
        }
    }

}

extension DeviceWorkTimelineInteractorImpl: DeviceWorkTimelineInteractor { }
