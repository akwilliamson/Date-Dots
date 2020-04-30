//
//  AddressView.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/29/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

class AddressView: UIView {

    // MARK: UI
    
    private let addressContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapEditAddress)))
        view.isUserInteractionEnabled = true
        view.layer.borderWidth = 6
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.textGray.cgColor
        view.clipsToBounds = true
        return view
    }()

    private let addressLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var editAddressButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit Address", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 12)
        button.setTitleColor(.textGray, for: .normal)
        button.addTarget(self, action: #selector(didTapEditAddress), for: .touchUpInside)
        return button
    }()

    private lazy var stampImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "stamp")
        return imageView
    }()

    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = viewModel.dateType.color
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "Noteworthy-Bold", size: 20)
        label.textAlignment = .center
        label.text = viewModel.addressText
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
    }

    private func configureView() {
        
    }
    
    private func constructView() {
        addSubview(addressContainerView)
        addressContainerView.addSubview(editAddressButton)
        addressContainerView.addSubview(stampImageView)
        addressContainerView.addSubview(addressLabel)
    }
    
    private func constrainView() {
        NSLayoutConstraint.activate([
            editAddressButton.topAnchor.constraint(equalTo: addressContainerView.topAnchor, constant: 8),
            editAddressButton.leadingAnchor.constraint(equalTo: addressContainerView.leadingAnchor, constant: 12),
        ])
        NSLayoutConstraint.activate([
            stampImageView.topAnchor.constraint(equalTo: addressContainerView.topAnchor, constant: 8),
            stampImageView.trailingAnchor.constraint(equalTo: addressContainerView.trailingAnchor, constant: -8),
            stampImageView.widthAnchor.constraint(equalToConstant: 25),
            stampImageView.heightAnchor.constraint(equalToConstant: 30),
        ])
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalTo: addressContainerView.topAnchor),
            addressLabel.bottomAnchor.constraint(equalTo: addressContainerView.bottomAnchor),
            addressLabel.leadingAnchor.constraint(equalTo: addressContainerView.leadingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: addressContainerView.trailingAnchor)
        ])
    }
    
    // MARK: Action
    
    @objc
    func didTapEditAddress() {
        // Show animated address edit
    }
}
