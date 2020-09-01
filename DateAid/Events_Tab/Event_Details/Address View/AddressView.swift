//
//  AddressView.swift
//  Date Dots
//
//  Created by Aaron Williamson on 4/29/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

protocol AddressViewDelegate {
    func didTapAddressView()
}

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
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = viewModel.addressFont
        label.textColor = viewModel.addressColor
        label.text = viewModel.addressText
        return label
    }()
    
    private lazy var regionFieldLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = viewModel.regionFont
        label.textColor = viewModel.regionColor
        label.text = viewModel.regionText
        return label
    }()

    // MARK: Properties

    let viewModel: AddressViewViewModel
    let delegate: AddressViewDelegate
    
    // MARK: Initialization
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: AddressViewViewModel, delegate: AddressViewDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(frame: .zero)
        configureView()
        constructSubviews()
        constrainSubviews()
    }

    // MARK: View Setup

    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAddressView)))
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
    
    // MARK: Actions
    
    @objc
    func didTapAddressView() {
        delegate.didTapAddressView()
    }
    
    // MARK: Public Methods
    
    public func updateAddress(_ address: Address?) {
        viewModel.updateAddress(address: address)
        updateAddressText()
    }
    
    public func updateEventType(_ eventType: EventType) {
        viewModel.updateEventType(eventType: eventType)
        updateAddressColor()
    }
}
