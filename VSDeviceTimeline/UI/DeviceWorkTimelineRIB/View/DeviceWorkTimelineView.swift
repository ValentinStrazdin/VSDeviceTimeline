import UIKit
import DGCharts

// MARK: - Protocol

protocol DeviceWorkTimelineViewEventsHandler: AnyObject { }

protocol DeviceWorkTimelineView: AnyObject {

    func display(
        chartMode: TimelineChartMode,
        viewModel: DeviceWorkTimeline.ViewModel?
    )

}

// MARK: - Implementation

final class DeviceWorkTimelineViewImpl: UIViewController {

    // MARK: - Private Types

    private typealias TimelineChartDataSet = BarLineScatterCandleBubbleChartDataSet
    private typealias ViewModel = DeviceWorkTimeline.ViewModel

    private enum Constant {

        static let margins: UIEdgeInsets = .init(top: 14, left: 16, bottom: 14, right: 16)

        static let badgeHeight: CGFloat = 24

        static let chartViewHeight: CGFloat = 102
        static let chartViewLeft: CGFloat = 16
        static let chartImageHeight: CGFloat = 40
        static let chartImageOffsetLeft: CGFloat = 8
        static let chartImageOffsetRight: CGFloat = 9

        static let loadingViewsSpacing: CGFloat = 16
        static let loadingViewsCornerRadius: CGFloat = 8

        static let arrowWidth: CGFloat = 7
        static let arrowHeight: CGFloat = 12
        static let arrowYOffset: CGFloat = -2

        static let twoHours: CGFloat = 2 * 60
        static let twentyFourHours: CGFloat = 24 * 60

    }

    private enum Icon {

        static let arrowLeft = UIImage(named: "timelineArrowLeft")
        static let arrowRight = UIImage(named: "timelineArrowRight")
        static let chartFreeLeft = UIImage(named: "timelineFreeLeft")
        static let chartFreeRight = UIImage(named: "timelineFreeRight")

    }

    // MARK: - Internal Properties

    weak var eventsHandler: DeviceWorkTimelineViewEventsHandler?

    // MARK: - Private Properties

    private lazy var contentStackView: UIStackView = {
        makeContainer(subviews: [
            titleLabel,
            mainContainer
        ])
    }()

    private lazy var mainContainer: UIStackView = {
        let mainContainer = makeContainer(subviews: [
            makeSpacerView(height: 7),
            chartContainerView,
            makeSpacerView(height: 3),
            legendsContainer,
            makeSpacerView(height: Constant.margins.bottom)
        ])
        mainContainer.isHidden = false
        return mainContainer
    }()

    private lazy var legendsContainer: UIStackView = {
        let legendsContainer = makeContainer(subviews: [
            makeSpacerView(height: 7),
            legendsView
        ])
        return legendsContainer
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel().prepareForAutoLayout()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.attributedText = NSAttributedString(
            string: "График работы устройства",
            font: .systemFont(ofSize: 16, weight: .medium),
            textColor: .textPrimary,
            alignment: .natural
        )
        return titleLabel
    }()

    // MARK: - Chart views

    private let chartContainerView = UIView().prepareForAutoLayout()

    private lazy var chartScrollView: UIScrollView = {
        let scrollView = UIScrollView().prepareForAutoLayout()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        scrollView.delegate = self
        return scrollView
    }()

    private lazy var chartView: TimelineChartView = {
        let isSmallScreen = UIScreen.main.bounds.width <= 320
        let chartView = TimelineChartView(
            frame: view.bounds,
            isSmallScreen: isSmallScreen
        )
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.eventsHandler = self
        return chartView
    }()

    private lazy var chartImageView: UIImageView = {
        let imageView = UIImageView().prepareForAutoLayout()
        imageView.image = view.isLeftToRightUI ? Icon.chartFreeLeft : Icon.chartFreeRight
        imageView.isHidden = true
        return imageView
    }()

    private lazy var legendsView = LegendsView(
        dataSource: legendsDataSource
    )

    // MARK: - Arrows

    private lazy var arrows: [UIView] = [
        leftArrow,
        rightArrow
    ]

    private lazy var leftArrow: UIImageView = {
        let imageView = UIImageView().prepareForAutoLayout()
        imageView.image = Icon.arrowLeft
        imageView.tintColor = .standardDisabled
        return imageView
    }()

    private lazy var rightArrow: UIImageView = {
        let imageView = UIImageView().prepareForAutoLayout()
        imageView.image = Icon.arrowRight
        imageView.tintColor = .standardDisabled
        return imageView
    }()

    private var chartMode: TimelineChartMode = .free {
        didSet {
            guard isViewLoaded else {
                return
            }
            updateViews(chartMode: chartMode)
        }
    }

    private var viewModel: ViewModel? {
        didSet {
            guard
                isViewLoaded,
                let viewModel = viewModel
            else {
                return
            }
            presentViewModel(viewModel)
            updateSizeClassDependentConstraints()
        }
    }

    private var chartViewWidth: NSLayoutConstraint?

    private let legendsDataSource: UICollectionViewDataSource?

    // MARK: - Init

    init(
        legendsDataSource: UICollectionViewDataSource?
    ) {
        self.legendsDataSource = legendsDataSource
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle

    override func loadView() {
        view = UIView()
        view.backgroundColor = .backgroundPrimary
        view.addSubview(contentStackView)
        chartContainerView.addSubviews([
            leftArrow,
            chartImageView,
            chartScrollView,
            rightArrow
        ])
        chartScrollView.addSubview(chartView)
        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateSizeClassDependentConstraints()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { [weak self] _ in
                self?.updateSizeClassDependentConstraints()
            }
        )
    }

    // MARK: - Private Methods

    private func setupConstraints() {
        let chartViewWidth = chartView.widthAnchor.constraint(
            equalTo: chartScrollView.widthAnchor
        )
        self.chartViewWidth = chartViewWidth

        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constant.margins.left
            ),
            contentStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constant.margins.right
            ),
            contentStackView.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: Constant.margins.top
            ),
            contentStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            chartContainerView.heightAnchor.constraint(equalToConstant: Constant.chartViewHeight),

            chartScrollView.topAnchor.constraint(equalTo: chartContainerView.topAnchor),
            chartScrollView.leadingAnchor.constraint(
                equalTo: chartContainerView.leadingAnchor,
                constant: Constant.chartViewLeft
            ),
            chartScrollView.trailingAnchor.constraint(
                equalTo: chartContainerView.trailingAnchor,
                constant: -Constant.chartViewLeft
            ),
            chartScrollView.bottomAnchor.constraint(equalTo: chartContainerView.bottomAnchor),

            chartView.topAnchor.constraint(equalTo: chartScrollView.topAnchor),
            chartView.leadingAnchor.constraint(equalTo: chartScrollView.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: chartScrollView.trailingAnchor),
            chartView.bottomAnchor.constraint(equalTo: chartScrollView.bottomAnchor),
            chartView.heightAnchor.constraint(equalTo: chartScrollView.heightAnchor),
            chartViewWidth,

            chartImageView.leftAnchor.constraint(
                equalTo: leftArrow.rightAnchor,
                constant: Constant.chartImageOffsetLeft
            ),
            chartImageView.centerYAnchor.constraint(
                equalTo: chartContainerView.centerYAnchor,
                constant: Constant.arrowYOffset
            ),
            chartImageView.rightAnchor.constraint(
                equalTo: rightArrow.leftAnchor,
                constant: -Constant.chartImageOffsetRight
            ),
            chartImageView.heightAnchor.constraint(equalToConstant: Constant.chartImageHeight),

            leftArrow.leftAnchor.constraint(equalTo: chartContainerView.leftAnchor),
            leftArrow.centerYAnchor.constraint(
                equalTo: chartContainerView.centerYAnchor,
                constant: Constant.arrowYOffset
            ),
            leftArrow.widthAnchor.constraint(equalToConstant: Constant.arrowWidth),
            leftArrow.heightAnchor.constraint(equalToConstant: Constant.arrowHeight),

            rightArrow.rightAnchor.constraint(equalTo: chartContainerView.rightAnchor),
            rightArrow.centerYAnchor.constraint(
                equalTo: chartContainerView.centerYAnchor,
                constant: Constant.arrowYOffset
            ),
            rightArrow.widthAnchor.constraint(equalToConstant: Constant.arrowWidth),
            rightArrow.heightAnchor.constraint(equalToConstant: Constant.arrowHeight)
        ])
    }

    private func presentViewModel(_ viewModel: ViewModel) {
        setupChartView(intervals: viewModel.intervals)
        updateChartViewConstraints()

        legendsContainer.isHidden = viewModel.isLegendsHidden
    }

    private func updateViews(chartMode: TimelineChartMode) {
        switch chartMode {
        case .demo:
            chartImageView.isHidden = false
            chartScrollView.isScrollEnabled = false
            arrows.forEach { $0.isHidden = false }

        case .free:
            chartImageView.isHidden = false
            chartScrollView.isScrollEnabled = false
            arrows.forEach { $0.isHidden = false }

        case .premium:
            chartImageView.isHidden = true
            chartScrollView.isScrollEnabled = true
        }
    }

    private func setupChartView(
        intervals: [TimelineInterval] = []
    ) {
        chartView.mode = chartMode
        switch chartMode {
        case .premium:
            var intervals = intervals
            if view.isRightToLeftUI {
                intervals = intervals
                    .map { $0.inverted }
                    .sorted()
            }
            let values: [TimelineChartDataEntry] = intervals.map {
                .init(
                    timelineInterval: $0
                )
            }
            let dataSet = TimelineChartDataSet(values)
            chartView.data = ChartData(dataSets: [dataSet])

        case .demo, .free:
            chartView.data = ChartData(dataSets: [])
        }
    }

    private func updateChartViewConstraints() {
        chartViewWidth?.isActive = false
        switch chartMode {
        case .premium:
            // We display 2 hours from 24 hours
            let multiplier = Constant.twentyFourHours / Constant.twoHours
            // We need extra space on scroll view to display first and last label
            let extraSpace: CGFloat = multiplier * TimelineChartView.axisLabelWidth
            chartViewWidth = chartView.widthAnchor.constraint(
                equalTo: chartScrollView.widthAnchor,
                multiplier: multiplier,
                constant: -extraSpace
            )

        case .demo, .free:
            chartViewWidth = chartView.widthAnchor.constraint(
                equalTo: chartScrollView.widthAnchor
            )
        }
        chartViewWidth?.isActive = true
    }

    private func updateSizeClassDependentConstraints() {
        guard case .premium = chartMode else {
            return
        }
        legendsView.invalidateLayout()
    }

    private func scrollToCurrentTime() {
        guard case .premium(let timelinePosition) = chartMode else {
            return
        }
        let offsetX = getScrollOffset(for: timelinePosition)
        chartScrollView.contentOffset = .init(x: offsetX, y: 0)
        showArrowsIfNeeded()
    }

    private func getScrollOffset(
        for timelinePosition: CGFloat
    ) -> CGFloat {
        let offsetInMinutes: CGFloat
        if view.isLeftToRightUI {
            offsetInMinutes = max(timelinePosition - Constant.twoHours, 0)
        }
        else {
            offsetInMinutes = min(
                Constant.twentyFourHours - timelinePosition,
                Constant.twentyFourHours - Constant.twoHours
            )
        }
        let maxWidth = chartView.bounds.size.width - TimelineChartView.axisLabelWidth
        return (offsetInMinutes / Constant.twentyFourHours) * maxWidth
    }

    private func showArrowsIfNeeded() {
        let offset = chartScrollView.contentOffset.x
        let contentWidth = chartScrollView.contentSize.width
        let visibleWidth = chartScrollView.visibleSize.width

        leftArrow.isHidden = offset <= 0
        rightArrow.isHidden = (contentWidth - visibleWidth - offset) <= 0
    }

}

// MARK: - Protocol DeviceWorkTimelineView

extension DeviceWorkTimelineViewImpl: DeviceWorkTimelineView {

    func display(
        chartMode: TimelineChartMode,
        viewModel: DeviceWorkTimeline.ViewModel?
    ) {
        self.chartMode = chartMode
        self.viewModel = viewModel
        legendsView.reload()
    }

}

// MARK: - DeviceWorkTimelineViewImpl Factory

extension DeviceWorkTimelineViewImpl {

    static func makeView(
        legendsDataSource: UICollectionViewDataSource?
    ) -> DeviceWorkTimelineViewImpl {
        DeviceWorkTimelineViewImpl(
            legendsDataSource: legendsDataSource
        )
    }

}

extension DeviceWorkTimelineViewImpl {

    private func makeSpacerView(height: CGFloat) -> UIView {
        let view = UIView().prepareForAutoLayout()
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        return view
    }

    /// Create vertical stack view with spacing
    private func makeContainer(
        subviews: [UIView],
        spacing: CGFloat = 0
    ) -> UIStackView {
        let container = UIStackView().prepareForAutoLayout()
        container.axis = .vertical
        container.spacing = spacing
        container.addArrangedSubviews(subviews)
        return container
    }

}

// MARK: - UIScrollViewDelegate

extension DeviceWorkTimelineViewImpl: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        showArrowsIfNeeded()
    }

}

// MARK: - TimelineChartViewEventsHandler

extension DeviceWorkTimelineViewImpl: TimelineChartViewEventsHandler {

    func chartViewDataSetChanged() {
        scrollToCurrentTime()
    }

}
