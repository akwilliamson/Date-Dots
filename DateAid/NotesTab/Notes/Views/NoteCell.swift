//
//  NoteCell.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/1/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {

    // MARK: UI
    
    private let eventTypeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            label.font = FontType.avenirNextDemiBold(20).font
        default:
            label.font = FontType.avenirNextDemiBold(25).font
        }
        return label
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            label.font = FontType.avenirNextMedium(15).font
        default:
            label.font = FontType.avenirNextMedium(20).font
        }
        return label
    }()

    // MARK: Properties
    
    public var note: Note? {
        didSet {
            populate(note)
        }
    }
    
    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        configureView()
        constructViews()
        constrainViews()
    }

    // MARK: View Setup

    private func configureView() {
        selectionStyle = .none
    }
    
    private func constructViews() {
        addSubview(eventTypeIcon)
        addSubview(nameLabel)
        addSubview(noteLabel)
    }
    
    private func constrainViews() {
        NSLayoutConstraint.activate([
            eventTypeIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            eventTypeIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            eventTypeIcon.widthAnchor.constraint(equalToConstant: 24),
            eventTypeIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: eventTypeIcon.trailingAnchor, constant: 8)
        ])
        NSLayoutConstraint.activate([
            noteLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            noteLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 15)
        ])
    }

    // MARK: Helper Methods

    private func populate(_ note: Note?) {
        guard let note = note else { return }
        
        eventTypeIcon.image = note.event.eventType.selectedImage
        eventTypeIcon.layer.cornerRadius = 12
        
        nameLabel.text = note.event.fullName
        nameLabel.textColor = note.event.eventType.color
        
        if let subject = note.subject {
            noteLabel.text = subject.capitalized
        } else {
            noteLabel.text = note.type
        }
        noteLabel.textColor = UIColor.compatibleLabel
    }
}
