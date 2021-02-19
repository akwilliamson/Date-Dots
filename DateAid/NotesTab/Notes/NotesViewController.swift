//
//  NotesViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/9/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol NotesViewOutputting: class {
    
    func configureTabBar(image: UIImage, selectedImage: UIImage)
}

class NotesViewController: UIViewController {
    
    var presenter: NotesEventHandling?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        presenter?.viewLoaded()
    }
}

extension NotesViewController: NotesViewOutputting {
    
    func configureTabBar(image: UIImage, selectedImage: UIImage) {
        tabBarItem = UITabBarItem(title: "Notes", image: image, selectedImage: selectedImage)
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.compatibleLabel], for: .normal)
    }
}
