import UIKit

// MARK: - Protocol

protocol DashboardViewEventsHandler: AnyObject {

    func didTapFreeMode()
    func didTapPremiumMode()
    func didTapAddIntervals(type: TimelineInterval.IntervalType)
    func didTapRemoveIntervals(type: TimelineInterval.IntervalType)

}

protocol DashboardView: AnyObject {

    // TODO: DashboardView contract for DashboardPresenter

}


protocol DashboardEmbedable: AnyObject {

    func embedDeviceWorkTimelineView(_ deviceWorkTimelineView: UIView)

}

// MARK: - Implementation

final class DashboardViewImpl: UIViewController {

    // MARK: - Private Types

    private typealias Localization = String.Localized.Dashboard

    private enum Constants {

        static let timelineCornerRadius: CGFloat = 13

        enum Regular {

            static let widthMultiplier: CGFloat = 0.6

        }

        enum Compact {

            static let margin: CGFloat = 24

        }

    }

    // MARK: - Internal Properties

    weak var eventsHandler: DashboardViewEventsHandler?

    // MARK: - Private Properties

    private let contentView: UIStackView = {
        let stackView = UIStackView().prepareForAutoLayout()
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()

    private lazy var deviceWorkTimelineContainerView: UIView = {
        let containerView = UIView().prepareForAutoLayout()
        containerView.backgroundColor = .backgroundPrimary
        containerView.layer.cornerRadius = Constants.timelineCornerRadius
        containerView.layer.masksToBounds = true
        return containerView
    }()

    private let buttonsContainerView: UIStackView = {
        let stackView = UIStackView().prepareForAutoLayout()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()

    private let emptyView = UIView().prepareForAutoLayout()

    private lazy var licenseButtonsContainerView = makeButtonsContainer()

    private lazy var freeModeButton: CustomButton = {
        let button = CustomButton().prepareForAutoLayout()
        button.setTitle(Localization.Button.freeModeTitle, for: .normal)
        button.addTarget(self, action: #selector(didTapFreeModeButton), for: .touchUpInside)
        return button
    }()

    private lazy var premiumModeButton: CustomButton = {
        let button = CustomButton().prepareForAutoLayout()
        button.setTitle(Localization.Button.premiumModeTitle, for: .normal)
        button.addTarget(self, action: #selector(didTapPremiumModeButton), for: .touchUpInside)
        return button
    }()

    private lazy var usageIntervalsLabel = makeLabel(title: Localization.usageIntervals)
    private lazy var usageIntervalsButtonsContainerView = makeButtonsContainer()

    private lazy var addUsageIntervalsButton: CustomButton = {
        let button = CustomButton().prepareForAutoLayout()
        button.setTitle(Localization.Button.addTitle, for: .normal)
        button.addTarget(self, action: #selector(didTapAddUsageIntervalsButton), for: .touchUpInside)
        return button
    }()

    private lazy var removeUsageIntervalsButton: CustomButton = {
        let button = CustomButton().prepareForAutoLayout()
        button.setTitle(Localization.Button.removeTitle, for: .normal)
        button.addTarget(self, action: #selector(didTapRemoveUsageIntervalsButton), for: .touchUpInside)
        return button
    }()

    private lazy var blockIntervalsLabel = makeLabel(title: Localization.blockIntervals)
    private lazy var blockIntervalsButtonsContainerView = makeButtonsContainer()

    private lazy var addBlockIntervalsButton: CustomButton = {
        let button = CustomButton().prepareForAutoLayout()
        button.setTitle(Localization.Button.addTitle, for: .normal)
        button.addTarget(self, action: #selector(didTapAddBlockIntervalsButton), for: .touchUpInside)
        return button
    }()

    private lazy var removeBlockIntervalsButton: CustomButton = {
        let button = CustomButton().prepareForAutoLayout()
        button.setTitle(Localization.Button.removeTitle, for: .normal)
        button.addTarget(self, action: #selector(didTapRemoveBlockIntervalsButton), for: .touchUpInside)
        return button
    }()

    private lazy var overTimeIntervalsLabel = makeLabel(title: Localization.overtimeIntervals)
    private lazy var overtimeIntervalsButtonsContainerView = makeButtonsContainer()

    private lazy var addOvertimeIntervalsButton: CustomButton = {
        let button = CustomButton().prepareForAutoLayout()
        button.setTitle(Localization.Button.addTitle, for: .normal)
        button.addTarget(self, action: #selector(didTapAddOvertimeIntervalsButton), for: .touchUpInside)
        return button
    }()

    private lazy var removeOvertimeIntervalsButton: CustomButton = {
        let button = CustomButton().prepareForAutoLayout()
        button.setTitle(Localization.Button.removeTitle, for: .normal)
        button.addTarget(self, action: #selector(didTapRemoveOvertimeIntervalsButton), for: .touchUpInside)
        return button
    }()

    private lazy var additionalTimeIntervalsLabel = makeLabel(title: Localization.additionalTimeIntervals)
    private lazy var additionalTimeIntervalsButtonsContainerView = makeButtonsContainer()

    private lazy var addAdditionalTimeIntervalsButton: CustomButton = {
        let button = CustomButton().prepareForAutoLayout()
        button.setTitle(Localization.Button.addTitle, for: .normal)
        button.addTarget(self, action: #selector(didTapAddAdditionalTimeIntervalsButton), for: .touchUpInside)
        return button
    }()

    private lazy var removeAdditionalTimeIntervalsButton: CustomButton = {
        let button = CustomButton().prepareForAutoLayout()
        button.setTitle(Localization.Button.removeTitle, for: .normal)
        button.addTarget(self, action: #selector(didTapRemoveAdditionalTimeIntervalsButton), for: .touchUpInside)
        return button
    }()

    private var contentRegularConstraints: [NSLayoutConstraint] = []
    private var contentCompactConstraints: [NSLayoutConstraint] = []

    // MARK: - Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func loadView() {
        view = UIView()
        view.backgroundColor = .backgroundSecondary

        view.addSubview(contentView)

        licenseButtonsContainerView.addArrangedSubviews([
            freeModeButton,
            premiumModeButton
        ])

        usageIntervalsButtonsContainerView.addArrangedSubviews([
            addUsageIntervalsButton,
            removeUsageIntervalsButton
        ])

        blockIntervalsButtonsContainerView.addArrangedSubviews([
            addBlockIntervalsButton,
            removeBlockIntervalsButton
        ])

        overtimeIntervalsButtonsContainerView.addArrangedSubviews([
            addOvertimeIntervalsButton,
            removeOvertimeIntervalsButton
        ])

        additionalTimeIntervalsButtonsContainerView.addArrangedSubviews([
            addAdditionalTimeIntervalsButton,
            removeAdditionalTimeIntervalsButton
        ])

        buttonsContainerView.addArrangedSubviews([
            licenseButtonsContainerView,
            makeSpacerView(height: 10),
            usageIntervalsLabel,
            usageIntervalsButtonsContainerView,
            makeSpacerView(height: 10),
            blockIntervalsLabel,
            blockIntervalsButtonsContainerView,
            makeSpacerView(height: 10),
            overTimeIntervalsLabel,
            overtimeIntervalsButtonsContainerView,
            makeSpacerView(height: 10),
            additionalTimeIntervalsLabel,
            additionalTimeIntervalsButtonsContainerView
        ])

        contentView.addArrangedSubviews([
            deviceWorkTimelineContainerView,
            buttonsContainerView,
            emptyView
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateSizeDependantConstraints()
    }

    // MARK: - Private methods

    private func setupConstraints() {
        let deviceWorkTimelineHeight = deviceWorkTimelineContainerView.heightAnchor.constraint(equalToConstant: 0)
        deviceWorkTimelineHeight.priority = .defaultLow

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            deviceWorkTimelineHeight
        ])

        contentRegularConstraints = [
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor, 
                                               multiplier: Constants.Regular.widthMultiplier)
        ]

        contentCompactConstraints = [
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                 constant: Constants.Compact.margin),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                  constant: -Constants.Compact.margin)
        ]

        updateSizeDependantConstraints()
    }

    private func updateSizeDependantConstraints() {
        let toActivate = isRegularHorizontal ? contentRegularConstraints : contentCompactConstraints
        let toDeactivate = isRegularHorizontal ? contentCompactConstraints : contentRegularConstraints

        NSLayoutConstraint.deactivate(toDeactivate)
        NSLayoutConstraint.activate(toActivate)
    }

    // MARK: - Actions

    @objc
    private func didTapFreeModeButton() {
        eventsHandler?.didTapFreeMode()
    }

    @objc
    private func didTapPremiumModeButton() {
        eventsHandler?.didTapPremiumMode()
    }

    @objc
    private func didTapAddUsageIntervalsButton() {
        eventsHandler?.didTapAddIntervals(type: .active)
    }

    @objc
    private func didTapRemoveUsageIntervalsButton() {
        eventsHandler?.didTapRemoveIntervals(type: .active)
    }

    @objc
    private func didTapAddBlockIntervalsButton() {
        eventsHandler?.didTapAddIntervals(type: .block)
    }

    @objc
    private func didTapRemoveBlockIntervalsButton() {
        eventsHandler?.didTapRemoveIntervals(type: .block)
    }

    @objc
    private func didTapAddOvertimeIntervalsButton() {
        eventsHandler?.didTapAddIntervals(type: .overtime)
    }

    @objc
    private func didTapRemoveOvertimeIntervalsButton() {
        eventsHandler?.didTapRemoveIntervals(type: .overtime)
    }

    @objc
    private func didTapAddAdditionalTimeIntervalsButton() {
        eventsHandler?.didTapAddIntervals(type: .additionalTime)
    }

    @objc
    private func didTapRemoveAdditionalTimeIntervalsButton() {
        eventsHandler?.didTapRemoveIntervals(type: .additionalTime)
    }

}

// MARK: - Protocol DashboardView

extension DashboardViewImpl: DashboardView { }

// MARK: - DashboardViewImpl Factory

extension DashboardViewImpl {

    static func makeView() -> DashboardViewImpl {
        DashboardViewImpl()
    }

}

extension DashboardViewImpl {

    private func makeSpacerView(height: CGFloat) -> UIView {
        let view = UIView().prepareForAutoLayout()
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        return view
    }

    private func makeLabel(title: String) -> UILabel {
        let titleLabel = UILabel().prepareForAutoLayout()
        titleLabel.attributedText = NSAttributedString(
            string: title,
            font: .systemFont(ofSize: 16, weight: .medium),
            textColor: .textPrimary,
            alignment: .natural
        )
        return titleLabel
    }

    private func makeButtonsContainer() -> UIStackView {
        let stackView = UIStackView().prepareForAutoLayout()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }

}

// MARK: - Protocol ParentDashboardSheetEmbedable

extension DashboardViewImpl: DashboardEmbedable {

    func embedDeviceWorkTimelineView(_ deviceWorkTimelineView: UIView) {
        embed(deviceWorkTimelineView, into: deviceWorkTimelineContainerView)
    }

    private func embed(_ childView: UIView, into parentView: UIView) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(childView)

        NSLayoutConstraint.activate([
            childView.topAnchor.constraint(equalTo: parentView.topAnchor),
            childView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            childView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            childView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor)
        ])
    }

}
