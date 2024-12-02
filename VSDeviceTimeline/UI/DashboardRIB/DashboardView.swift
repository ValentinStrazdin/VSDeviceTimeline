import UIKit

// MARK: - Protocol

protocol DashboardViewEventsHandler: AnyObject {

    func didChangeLicenseType(isFreeMode: Bool)

}

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
        static let marginTop: CGFloat = 8
        static let marginLeft: CGFloat = 16

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

    private lazy var deviceWorkTimelineContainerView = makeContainer()
    private lazy var freeModeContainerView = makeContainer()
    
    private let freeModeStackView: UIStackView = {
        let stackView = UIStackView().prepareForAutoLayout()
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var freeModeLabel = makeLabel(title: Localization.freeModeTitle)
    private lazy var freeModeSwitch: UISwitch = {
        let switchView = UISwitch().prepareForAutoLayout()
        switchView.isOn = false
        switchView.addTarget(self, action: #selector(didChangeFreeModeSwitch), for: .valueChanged)
        return switchView
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

        freeModeStackView.addArrangedSubviews([
            freeModeLabel,
            freeModeSwitch
        ])
        freeModeContainerView.addSubview(freeModeStackView)

        contentView.addArrangedSubviews([
            freeModeContainerView,
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
            deviceWorkTimelineHeight,
            
            freeModeStackView.topAnchor.constraint(equalTo: freeModeContainerView.topAnchor,
                                                   constant: Constants.marginTop),
            freeModeStackView.leadingAnchor.constraint(equalTo: freeModeContainerView.leadingAnchor,
                                                       constant: Constants.marginLeft),
            freeModeStackView.trailingAnchor.constraint(equalTo: freeModeContainerView.trailingAnchor,
                                                        constant: -Constants.marginLeft),
            freeModeStackView.bottomAnchor.constraint(equalTo: freeModeContainerView.bottomAnchor,
                                                      constant: -Constants.marginTop)
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
    private func didChangeFreeModeSwitch(_ sender: UISwitch) {
        eventsHandler?.didChangeLicenseType(isFreeMode: sender.isOn)
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

    private func makeContainer() -> UIView {
        let containerView = UIView().prepareForAutoLayout()
        containerView.backgroundColor = .backgroundPrimary
        containerView.layer.cornerRadius = Constants.timelineCornerRadius
        containerView.layer.masksToBounds = true
        return containerView
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
