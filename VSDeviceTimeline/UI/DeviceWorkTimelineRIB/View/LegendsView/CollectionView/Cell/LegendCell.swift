import UIKit

struct LegendCellModel {
    let title: String
    let legendItem: LegendItem
}

final class LegendCellConfigurator: CollectionCellConfiguratorImpl<LegendCell, LegendCellModel> {

    init(model: LegendCellModel) {
        super.init(
            model: model,
            size: UICollectionViewFlowLayout.automaticSize
        )
    }

}

final class LegendCell: UICollectionViewCell {

    // MARK: - Private Types

    private enum Constant {

        static let circleWidth: CGFloat = 10
        static let titleMargin: CGFloat = 8

    }

    // MARK: - Private Properties

    private let circleView = UIView().prepareForAutoLayout()

    private lazy var circleGradientView: CustomGradientView = {
        let circleGradientView = CustomGradientView().prepareForAutoLayout()
        circleGradientView.isHidden = true
        circleGradientView.isUserInteractionEnabled = false
        return circleGradientView
    }()

    private let titleLabel = UILabel().prepareForAutoLayout()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews([
            circleView,
            titleLabel
        ])
        circleView.addSubview(circleGradientView)
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        circleGradientView.layer.cornerRadius = Constant.circleWidth / 2
        circleGradientView.clipsToBounds = true

        circleView.layer.cornerRadius = Constant.circleWidth / 2
        circleView.clipsToBounds = true
    }

    // MARK: Private methods

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            circleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            circleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            circleView.widthAnchor.constraint(equalToConstant: Constant.circleWidth),
            circleView.heightAnchor.constraint(equalTo: circleView.widthAnchor),

            titleLabel.leadingAnchor.constraint(
                equalTo: circleView.trailingAnchor,
                constant: Constant.titleMargin
            ),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            circleGradientView.leadingAnchor.constraint(equalTo: circleView.leadingAnchor),
            circleGradientView.trailingAnchor.constraint(equalTo: circleView.trailingAnchor),
            circleGradientView.topAnchor.constraint(equalTo: circleView.topAnchor),
            circleGradientView.bottomAnchor.constraint(equalTo: circleView.bottomAnchor)
        ])
    }

}

// MARK: - CellConfigurable

extension LegendCell: CellConfigurable {
    
    func configure(
        model: LegendCellModel
    ) {
        backgroundColor = .backgroundPrimary

        titleLabel.attributedText = NSAttributedString(
            string: model.title,
            font: .systemFont(ofSize: 12, weight: .regular),
            textColor: .textPrimary,
            alignment: .natural
        )

        circleView.backgroundColor = .standardDisabled.withAlphaComponent(0.4)

        switch model.legendItem {
        case .active:
            circleGradientView.configure(with: .primaryAlterMain)
            circleGradientView.isHidden = false

        case .overtime:
            circleGradientView.configure(with: .primaryAttention)
            circleGradientView.isHidden = false

        case .additionalTime:
            circleGradientView.configure(with: .primaryAuxiliary)
            circleGradientView.isHidden = false

        case .blocked:
            circleGradientView.isHidden = true
        }
    }

}
