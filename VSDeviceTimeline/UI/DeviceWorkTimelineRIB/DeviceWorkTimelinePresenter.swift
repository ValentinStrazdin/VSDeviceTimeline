import Foundation

// MARK: - Protocol

protocol DeviceWorkTimelinePresenter: AnyObject {

    func presentFreeMode()
    func presentPremium(
        timelinePosition: CGFloat,
        timelineIntervals: [TimelineInterval]
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
        timelineIntervals: [TimelineInterval]
    ) {
        var legendItems: [LegendItem] = [.active]
        if timelineIntervals.contains(where: { $0.type == .block }) {
            legendItems.append(.blocked)
        }
        if timelineIntervals.contains(where: { $0.type == .additionalTime }) {
            legendItems.append(.additionalTime)
        }
        if timelineIntervals.contains(where: { $0.type == .overtime }) {
            legendItems.append(.overtime)
        }
        let legendsConfs = makeLegendsConfs(
            legendItems: legendItems
        )
        let viewModel = ViewModel(
            intervals: timelineIntervals,
            isLegendsHidden: false
        )

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
