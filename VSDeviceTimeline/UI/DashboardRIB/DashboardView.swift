import UIKit

// MARK: - Protocol

protocol DashboardView: AnyObject { }


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

    private let emptyView = UIView().prepareForAutoLayout()

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

        contentView.addArrangedSubviews([
            deviceWorkTimelineContainerView,
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

}

// MARK: - Protocol DashboardView

extension DashboardViewImpl: DashboardView { }

// MARK: - DashboardViewImpl Factory

extension DashboardViewImpl {

    static func makeView() -> DashboardViewImpl {
        DashboardViewImpl()
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
