//
//  NotesNavigationViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/8/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol NotesNavigationViewOutputting: class {

    func configureNavigation(barTintColor: UIColor, tintColor: UIColor)
    func configureNavigation(titleTextAttributes:  [NSAttributedString.Key : Any]?)
}

class NotesNavigationViewController: UINavigationController {
    
    // MARK: Properties
    
    var presenter: NotesNavigationEventHandling?
    
    var tab: UITabBarItem = {
        let image =  UIImage(named: "unselected-pencil")!.withRenderingMode(.alwaysTemplate)
        let selectedImage = UIImage(named: "selected-pencil")!.withRenderingMode(.alwaysTemplate)
        
        let tab = UITabBarItem(title: "Notes", image: image, selectedImage: selectedImage)
        tab.setTitleTextAttributes([.foregroundColor : UIColor.compatibleLabel], for: .normal)
        
        return tab
    }()
    
    // MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = tab
    }
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        presenter?.presentNotes()
    }
}

// MARK: DatesNavigationViewOutputting

extension NotesNavigationViewController: NotesNavigationViewOutputting {

    func configureNavigation(barTintColor: UIColor, tintColor: UIColor) {
        navigationBar.barTintColor = barTintColor
        navigationBar.tintColor = tintColor
    }
    
    func configureNavigation(titleTextAttributes:  [NSAttributedString.Key : Any]?) {
        navigationBar.titleTextAttributes = titleTextAttributes
    }
}
