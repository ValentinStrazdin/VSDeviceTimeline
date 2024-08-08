import Foundation

// MARK: - Protocol

protocol DeviceWorkTimelinePresenter: AnyObject {

    func presentFreeMode()
    func presentPremium(
        timelinePosition: CGFloat,
        settings: DeviceUsageControlSettings,
        timelineData: DeviceUsageTimelineData?
    )

}

// MARK: - Implementation

final class DeviceWorkTimelinePresenterImpl: DeviceWorkTimelinePresenter {

    // MARK: - Private Types

    private typealias ViewModel = DeviceWorkTimeline.ViewModel

    // MARK: - Internal Properties

    weak var interactor: DeviceWorkTimelineInteractor?
    weak var view: DeviceWorkTimelineView?

    var dataManager: BaseCollectionDataManager

    // MARK: - Init

    init(
        dataManager: BaseCollectionDataManager
    ) {
        self.dataManager = dataManager
    }

    // MARK: - Internal Methods

    func presentFreeMode() {
        let viewModel = ViewModel()
        present(
            chartMode: .free,
            viewModel: viewModel
        )
    }

    func presentPremium(
        timelinePosition: CGFloat,
        settings: DeviceUsageControlSettings,
        timelineData: DeviceUsageTimelineData?
    ) {
        let viewModel: ViewModel
        let legendsConfs: [LegendCellConfigurator]
        if let usageIntervals = timelineData?.intervals {
            var intervals: [TimelineInterval] = []
            var legendItems: [LegendItem] = [.active]
            if let forbiddenIntervals = settings.forbiddenIntervals {
                // We should draw forbiddenIntervals before usageIntervals
                intervals.append(contentsOf: forbiddenIntervals)
                legendItems.append(.blocked)
            }
            intervals.append(contentsOf: usageIntervals)
            if intervals.contains(where: { $0.type == .additionalTime }) {
                legendItems.append(.additionalTime)
            }
            if intervals.contains(where: { $0.type == .overtime }) {
                legendItems.append(.overtime)
            }
            legendsConfs = makeLegendsConfs(
                legendItems: legendItems
            )
            viewModel = ViewModel(
                intervals: intervals,
                isLegendsHidden: false
            )
        }
        else {
            legendsConfs = []
            viewModel = ViewModel()
        }

        dataManager.items = legendsConfs
        present(
            chartMode: .premium(timelinePosition: timelinePosition),
            viewModel: viewModel
        )
    }

    // MARK: - Private Methods

    private func makeLegendsConfs(
        legendItems: [LegendItem]
    ) -> [LegendCellConfigurator] {
        legendItems
            .map {
                let model = LegendCellModel(
                    title: $0.title,
                    legendItem: $0
                )
                return LegendCellConfigurator(
                    model: model
                )
            }
    }

    private func present(
        chartMode: TimelineChartMode,
        viewModel: ViewModel
    ) {
        view?.display(
            chartMode: chartMode,
            viewModel: viewModel
        )
    }

}

// MARK: - Protocol DeviceWorkTimelineViewEventsHandler

extension DeviceWorkTimelinePresenterImpl: DeviceWorkTimelineViewEventsHandler {

}
