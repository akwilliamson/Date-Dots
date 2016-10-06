//
//  DatesTabBarViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/5/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit

class DatesTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let tabBarItems = tabBar.items else { return }
        
        tabBarItems.forEach { item in
            guard var image = item.image else { return }
            image = image.imageWithColor(.white).withRenderingMode(.alwaysOriginal)
        }
    }
}
