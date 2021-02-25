//
//  RemindersViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/9/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

protocol RemindersViewOutputting: class {
}

class RemindersViewController: UIViewController {
    
    var presenter: RemindersEventHandling?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        presenter?.viewLoaded()
    }
}

extension RemindersViewController: RemindersViewOutputting {
}
