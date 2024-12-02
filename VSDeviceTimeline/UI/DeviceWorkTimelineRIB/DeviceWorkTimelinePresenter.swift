import Foundation

// MARK: - Protocol

protocol DeviceWorkTimelinePresenter: AnyObject {

    func present(viewModel: DeviceWorkTimeline.ViewModel)

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

    func present(viewModel: DeviceWorkTimeline.ViewModel) {
        var legendItems: [LegendItem] = [.active]
        if viewModel.intervals.contains(where: { $0.type == .block }) {
            legendItems.append(.blocked)
        }
        if viewModel.intervals.contains(where: { $0.type == .additionalTime }) {
            legendItems.append(.additionalTime)
        }
        if viewModel.intervals.contains(where: { $0.type == .overtime }) {
            legendItems.append(.overtime)
        }
        let legendsConfs = makeLegendsConfs(
            legendItems: legendItems
        )
        
        dataManager.items = legendsConfs
        view?.display(viewModel: viewModel)
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

}

// MARK: - Protocol DeviceWorkTimelineViewEventsHandler

extension DeviceWorkTimelinePresenterImpl: DeviceWorkTimelineViewEventsHandler {

}
