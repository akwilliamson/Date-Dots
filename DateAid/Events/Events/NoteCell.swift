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
    
    private let noteTypeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        switch UIDevice.type {
        case .iPhone4, .iPhone5, .iPhoneSE, .iPhoneSE2:
            label.font = FontType.avenirNextMedium(13).font
        default:
            label.font = FontType.avenirNextMedium(18).font
        }
        return label
    }()

    // MARK: Properties
    
    var note: Note?
    var noteType: NoteType?
    
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
        addSubview(noteTypeIcon)
        addSubview(noteLabel)
    }
    
    private func constrainViews() {
        NSLayoutConstraint.activate([
            noteTypeIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            noteTypeIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            noteTypeIcon.widthAnchor.constraint(equalToConstant: 24),
            noteTypeIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
        NSLayoutConstraint.activate([
            noteLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            noteLabel.leadingAnchor.constraint(equalTo: noteTypeIcon.trailingAnchor, constant: 8)
        ])
    }
}

// MARK: - Populate

extension NoteCell {
    
    struct Content {
        let note: Note?
        let noteType: NoteType?
    }
    
    func populate(_ content: Content) {
        if let note = content.note {
            noteTypeIcon.image = note.noteType.image
            noteTypeIcon.layer.cornerRadius = 12
            
            if let subject = note.subject {
                noteLabel.text = subject.capitalized
            } else {
                noteLabel.text = note.type
            }
            noteLabel.textColor = UIColor.compatibleLabel
        } else if let noteType = content.noteType {
            noteTypeIcon.image = noteType.image
            noteTypeIcon.layer.cornerRadius = 12
            
            switch noteType {
            case .gifts:
                noteLabel.text = "Gift ideas"
            case .plans:
                noteLabel.text = "Event plans"
            case .misc:
                noteLabel.text = "Other notes"
            }
            noteLabel.textColor = .systemGray3
        }
    }
}
