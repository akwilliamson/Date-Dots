//
//  NotesViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/9/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol NotesViewOutputting: class {
    
    func reloadData()
}

class NotesViewController: UIViewController {
    
    // MARK: UI
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EventCell.self, forCellReuseIdentifier: "EventCell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private var dotStackView: UIStackView = {
        let stacKView = UIStackView()
        stacKView.translatesAutoresizingMaskIntoConstraints = false
        stacKView.distribution = .fillEqually
        stacKView.spacing = 8
        return stacKView
    }()

    private lazy var giftsDot: IconCircleImageView = {
        let dotView = IconCircleImageView(eventType: .birthday)
        dotView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dotPressed(_:)))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()

    private lazy var plansDot: IconCircleImageView = {
        let dotView = IconCircleImageView(eventType: .anniversary)
        dotView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dotPressed(_:)))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()

    private lazy var otherDot: IconCircleImageView = {
        let dotView = IconCircleImageView(eventType: .other)
        dotView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dotPressed(_:)))
        dotView.addGestureRecognizer(tapGesture)
        return dotView
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
    }()
    
    // MARK: Properties
    
    var presenter: NotesEventHandling?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        presenter?.viewDidLoad()
        configureView()
        constructSubviews()
        constrainSubviews()
    }
    
    // MARK: View Setup
    
    private func configureView() {
        view.backgroundColor = .compatibleSystemBackground
        navigationItem.rightBarButtonItems = [addButton]
    }
    
    private  func constructSubviews() {
        view.addSubview(dotStackView)
        dotStackView.addArrangedSubview(giftsDot)
        dotStackView.addArrangedSubview(plansDot)
        dotStackView.addArrangedSubview(otherDot)
        view.addSubview(tableView)
    }
    
    private func constrainSubviews() {
        NSLayoutConstraint.activate([
            dotStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dotStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            dotStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            giftsDot.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/5),
            giftsDot.heightAnchor.constraint(equalTo: giftsDot.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: dotStackView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: Actions
    
    @objc
    func addButtonPressed() {
        let alertController = UIAlertController(title: "Add", message: "was tapped", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "dismiss", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc
    func dotPressed(_ sender: UITapGestureRecognizer) {
        print("Note dot pressed")
    }
}

extension NotesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let presenter = presenter else { return 0 }
        return presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else { return 0 }
        return presenter.numberOfNotes(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "NoteCell")

        cell.textLabel?.text = presenter?.cellTitle(for: indexPath)
        cell.detailTextLabel?.text = presenter?.cellSubtitle(for: indexPath)
        
        return cell
    }
}

extension NotesViewController: UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let presenter = presenter else { return nil }
        return presenter.noteTitle(for: section)
    }
}

extension NotesViewController: NotesViewOutputting {
    
    func reloadData() {
        tableView.reloadData()
    }
}
