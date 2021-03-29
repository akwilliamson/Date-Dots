//
//  NotesViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/9/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol NotesViewOutputting: class {
    
    func configureNavigationBar(title: String)
    func reloadData()
}

class NotesViewController: UIViewController {
    
    // MARK: UI
    
    private var dotStackView: UIStackView = {
        let stacKView = UIStackView()
        stacKView.translatesAutoresizingMaskIntoConstraints = false
        stacKView.distribution = .fillEqually
        stacKView.spacing = 8
        return stacKView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = false
        tableView.register(NoteCell.self, forCellReuseIdentifier: "NoteCell")
        tableView.register(NoteSampleCell.self, forCellReuseIdentifier: "NoteSampleCell")
        tableView.register(NotesSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "SectionHeader")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
    }()
    
    // MARK: Properties
    
    weak var presenter: NotesEventHandling?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        presenter?.viewDidLoad()
        configureView()
        constructSubviews()
        constrainSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    // MARK: View Setup
    
    private func configureView() {
        view.backgroundColor = .compatibleSystemBackground
        navigationItem.rightBarButtonItems = [addButton]
    }
    
    private  func constructSubviews() {
        view.addSubview(dotStackView)
        view.addSubview(tableView)
    }
    
    private func constrainSubviews() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
        let existingNotesInSection = presenter.numberOfNotes(for: section)
        
        return existingNotesInSection > 0 ? existingNotesInSection : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell") as? NoteCell,
            let note = presenter?.note(for: indexPath)
        else {
            switch indexPath.section {
            case 0: return NoteSampleCell(noteType: .gifts, reuseIdentifier: "NoteSampleCell")
            case 1: return NoteSampleCell(noteType: .plans, reuseIdentifier: "NoteSampleCell")
            case 2: return NoteSampleCell(noteType: .other, reuseIdentifier: "NoteSampleCell")
            default:
                return UITableViewCell()
            }
        }
        
        cell.note = note
        
        return cell
    }
}

extension NotesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader: NotesSectionHeaderView
        switch section {
        case 0: sectionHeader = NotesSectionHeaderView(noteType: .gifts, reuseIdentifier: "SectionHeader")
        case 1: sectionHeader = NotesSectionHeaderView(noteType: .plans, reuseIdentifier: "SectionHeader")
        case 2: sectionHeader = NotesSectionHeaderView(noteType: .other, reuseIdentifier: "SectionHeader")
        default:
            return nil
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
        sectionHeader.addGestureRecognizer(tapGesture)
        
        return sectionHeader
    }
    
    @objc
    func headerTapped(sender: UITapGestureRecognizer) {
        guard let section = sender.view?.tag else { return }
        presenter?.didSelectSection(at: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRow(at: indexPath)
    }
}

extension NotesViewController: NotesViewOutputting {
    
    func configureNavigationBar(title: String) {
        navigationItem.title = title
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}
