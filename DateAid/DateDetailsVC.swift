//
//  DateDetailsVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/23/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

class DateDetailsVC: UIViewController {

    var date: Date?

    @IBOutlet weak var fullNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullNameLabel.text = date?.name
    }
}
