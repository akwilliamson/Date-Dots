//
//  RemindersNavigationViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/8/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol RemindersNavigationViewOutputting: class {

    func configureNavigation(barTintColor: UIColor, tintColor: UIColor)
    func configureNavigation(titleTextAttributes:  [NSAttributedString.Key : Any]?)
}

class RemindersNavigationViewController: UINavigationController {
    
    // MARK: Properties
    
    var presenter: RemindersNavigationEventHandling?
    
    var tab: UITabBarItem = {
        let image =  UIImage(named: "unselected-reminder")!.withRenderingMode(.alwaysTemplate)
        let selectedImage = UIImage(named: "selected-reminder")!.withRenderingMode(.alwaysTemplate)
        
        let tabBarItem = UITabBarItem(title: "Reminders", image: image, selectedImage: selectedImage)
        tabBarItem.setTitleTextAttributes([.foregroundColor : UIColor.compatibleLabel], for: .normal)
        
        return tabBarItem
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
        presenter?.showReminders(in: self)
    }
}

// MARK: DatesNavigationViewOutputting

extension RemindersNavigationViewController: RemindersNavigationViewOutputting {

    func configureNavigation(barTintColor: UIColor, tintColor: UIColor) {
        navigationBar.barTintColor = barTintColor
        navigationBar.tintColor = tintColor
    }
    
    func configureNavigation(titleTextAttributes:  [NSAttributedString.Key : Any]?) {
        navigationBar.titleTextAttributes = titleTextAttributes
    }
}
