
//  UserGroupHeaderView.swift
//  PanModal
//
//  Created by Tosin Afolabi on 2/26/19.
//  Copyright © 2019 PanModal. All rights reserved.


import UIKit

class UserGroupHeaderView: UIView {

    struct Constants {
        static let contentInsets = UIEdgeInsets(top: 0, left: 0.0, bottom: 0.0, right: 0.0)
    }

    // MARK: - Views

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Lato-Bold", size: 17.0)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = #colorLiteral(red: 0.7019607843, green: 0.7058823529, blue: 0.7137254902, alpha: 1)
        label.font = UIFont(name: "Lato-Regular", size: 13.0)
        return label
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        if #available(iOS 13.0, *) {
            backgroundColor = .lightGray
        } else {
            backgroundColor = .gray
        }

        addSubview(stackView)
        addSubview(seperatorView)

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    func setupConstraints() {

        stackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.contentInsets.top).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.contentInsets.left).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.contentInsets.right).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.contentInsets.bottom).isActive = true

        seperatorView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        seperatorView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        seperatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
    }

    // MARK: - View Configuration

    func configure(with presentable: UserGroupHeaderPresentable) {
        titleLabel.text = presentable.handle
        subtitleLabel.text = presentable.description
    }

}
