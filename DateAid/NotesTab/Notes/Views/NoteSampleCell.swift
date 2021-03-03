//
//  NoteSampleCell.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/1/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

class NoteSampleCell: UITableViewCell {

    // MARK: UI
    
    let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 1
        label.textAlignment = .center
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            label.font = FontType.avenirNextMedium(13).font
        default:
            label.font = FontType.avenirNextMedium(18).font
        }
        return label
    }()

    // MARK: Properties
    
    private let noteType: NoteType
    
    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(noteType: NoteType, reuseIdentifier: String?) {
        self.noteType = noteType
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configureView()
        constructViews()
        constrainViews()
    }

    // MARK: View Setup

    private func configureView() {
        selectionStyle = .none
        configureLabelText()
    }
    
    private func constructViews() {
        addSubview(containerStackView)
        containerStackView.addSubview(descriptionLabel)
    }
    
    private func constrainViews() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.heightAnchor.constraint(equalToConstant: 30),
            descriptionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    // MARK: Helper Methods
    
    private func configureLabelText() {
        switch noteType {
        case .gifts:
            descriptionLabel.text = "You haven't added any gift ideas yet"
        case .plans:
            descriptionLabel.text = "You haven't added any event plans yet"
        case .other:
            descriptionLabel.text = "You haven't added any miscellaneous notes"
        }
    }
}
