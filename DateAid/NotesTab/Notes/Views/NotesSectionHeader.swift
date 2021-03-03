//
//  NotesSectionHeader.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/1/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

class NotesSectionHeaderView: UITableViewHeaderFooterView {
    
    // MARK: Subviews
    
    private lazy var sectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: noteType.title)
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = noteType.title.capitalized
        label.font = FontType.noteworthyBold(18).font
        return label
    }()
    
    private var addImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "plus")
        return imageView
    }()
    
    // MARK: Properties
    
    private let noteType: NoteType

    // MARK: Initialization
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(noteType: NoteType, reuseIdentifier: String) {
        self.noteType = noteType
//        self.viewModel = viewModel
//        self.delegate = delegate
        super.init(reuseIdentifier: reuseIdentifier)
        configureView()
        constructSubviews()
        constrainSubviews()
    }
    
    // MARK: View Setup
    
    private func configureView() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSectionHeader)))
    }
    
    private func constructSubviews() {
        addSubview(sectionImageView)
        addSubview(titleLabel)
        addSubview(addImageView)
    }
    
    private func  constrainSubviews(){
        NSLayoutConstraint.activate([
            sectionImageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            sectionImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,constant: 10),
            sectionImageView.heightAnchor.constraint(equalToConstant: 40),
            sectionImageView.widthAnchor.constraint(equalToConstant: 40)
        ])
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: sectionImageView.trailingAnchor, constant: 15)
        ])
        NSLayoutConstraint.activate([
            addImageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            addImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15),
            addImageView.heightAnchor.constraint(equalToConstant: 15),
            addImageView.widthAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    @objc
    func didTapSectionHeader() {
//        delegate?.didTapSectionHeader(for: noteType)
    }
}
