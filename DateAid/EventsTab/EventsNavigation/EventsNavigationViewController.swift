//
//  DatesNavigationViewController.swift
//  Date Dots
//
//  Created by Aaron Williamson on 1/15/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

protocol EventsNavigationViewOutputting: class {

    func configureNavigation(barTintColor: UIColor, tintColor: UIColor)
    func configureNavigation(titleTextAttributes:  [NSAttributedString.Key : Any]?)
}

class EventsNavigationViewController: UINavigationController {
    
    // MARK: Properties
    
    var presenter: EventsNavigationEventHandling?
    
    var tab: UITabBarItem = {
        let image =  UIImage(named: "unselected-calendar")!.withRenderingMode(.alwaysTemplate)
        let selectedImage = UIImage(named: "selected-calendar")!.withRenderingMode(.alwaysTemplate)
        
        let tab = UITabBarItem(title: "Events", image: image, selectedImage: selectedImage)
        tab.setTitleTextAttributes([.foregroundColor : UIColor.compatibleLabel], for: .normal)
        
        return tab
    }()
    
    // MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = tab
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        presenter?.showEvents(in: self)
    }
}

// MARK: DatesNavigationViewOutputting

extension EventsNavigationViewController: EventsNavigationViewOutputting {

    func configureNavigation(barTintColor: UIColor, tintColor: UIColor) {
        navigationBar.barTintColor = barTintColor
        navigationBar.tintColor = tintColor
    }
    
    func configureNavigation(titleTextAttributes:  [NSAttributedString.Key : Any]?) {
        navigationBar.titleTextAttributes = titleTextAttributes
    }
}
