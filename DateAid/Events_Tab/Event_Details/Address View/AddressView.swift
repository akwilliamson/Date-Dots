//
//  AddressView.swift
//  Date Dots
//
//  Created by Aaron Williamson on 4/29/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

class AddressView: UIView {

    // MARK: UI
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.layer.borderWidth = 6
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.compatibleLabel.cgColor
        view.clipsToBounds = true
        return view
    }()

    private lazy var stampImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .compatibleSecondaryLabel
        imageView.image = UIImage(named: "stamp")?.withRenderingMode(.alwaysTemplate)
        return imageView
    }()
    
    // MARK: Address UI
    
    private let addressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()

    private lazy var addressFieldLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = viewModel.addressColor
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = viewModel.addressFont
        label.textAlignment = .center
        label.text = viewModel.addressText
        return label
    }()
    
    private lazy var regionFieldLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = viewModel.regionColor
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = viewModel.regionFont
        label.textAlignment = .center
        label.text = viewModel.regionText
        return label
    }()

    // MARK: Properties

    let viewModel: AddressViewViewModel
    
    // MARK: Initialization
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: AddressViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureView()
        constructSubviews()
        constrainSubviews()
    }

    // MARK: View Setup

    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func constructSubviews() {
        addSubview(containerView)
        containerView.addSubview(stampImageView)
        containerView.addSubview(addressStackView)
        addressStackView.addArrangedSubview(addressFieldLabel)
        addressStackView.addArrangedSubview(regionFieldLabel)
    }
    
    private func constrainSubviews() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            stampImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            stampImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            stampImageView.widthAnchor.constraint(equalToConstant: 25),
            stampImageView.heightAnchor.constraint(equalToConstant: 25),
        ])
        NSLayoutConstraint.activate([
            addressStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            addressStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    private func updateAddressText() {
        addressFieldLabel.text = viewModel.addressText
        regionFieldLabel.text = viewModel.regionText
    }
    
    private func updateAddressColor() {
        addressFieldLabel.textColor = viewModel.addressColor
        regionFieldLabel.textColor = viewModel.addressColor
    }
    
    public func updateViewModel(address: Address?) {
        viewModel.setAddress(address: address)
        updateAddressText()
    }
    
    public func updateViewModel(eventType: EventType) {
        viewModel.setEventType(eventType: eventType)
        updateAddressColor()
    }
}
