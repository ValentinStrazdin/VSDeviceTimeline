//
//  CustomButton.swift
//  VSDeviceTimeline
//
//  Created by Valentin Strazdin on 08.08.2024.
//

import UIKit

class CustomButton: UIButton {

    let padding = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        setupConstraints()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupConstraints()
    }

    private func commonInit() {
        backgroundColor = .backgroundPrimary
        layer.cornerRadius = 10
        layer.masksToBounds = true
        titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel?.numberOfLines = 0
        titleLabel?.textAlignment = .center
        setTitleColor(.mainPrimary, for: .normal)
        setTitleColor(.mainTertiary, for: .highlighted)
    }

    private func setupConstraints() {
        guard let titleLabel else {
            return
        }
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding.left),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding.right),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom)
        ])
        invalidateIntrinsicContentSize()
    }

}
