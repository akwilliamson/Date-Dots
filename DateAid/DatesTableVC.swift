//
//  DatesTableVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/7/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit

class DatesTableVC: UITableViewController {
    
    // Bar button items
    var leftBarButtonItem: UIBarButtonItem!
    var rightBarButtonItem: UIBarButtonItem!
    // Fake table view rows
    let fakeDatesArray = ["date 1", "holiday 2", "date 3", "anniversary 4", ]
    
    var showDates = [String]()
    var menuIndexPath: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set bar button items
        self.leftBarButtonItem =  UIBarButtonItem(title: "Menu",
                                                  style: .Plain,
                                                 target: self.revealViewController(),
                                                 action: Selector("revealToggle:"))
        
        self.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                  style: .Plain,
                                                 target: self,
                                                 action: Selector("customFunc:"))
        
        self.navigationItem.leftBarButtonItem = self.leftBarButtonItem
        self.navigationItem.rightBarButtonItem = self.rightBarButtonItem
        self.title = "Dates"
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }

// MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if menuIndexPath == nil {
            return fakeDatesArray.count
        } else {
            return showDates.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        if menuIndexPath == nil {
            cell.textLabel?.text = fakeDatesArray[indexPath.row]
        } else {
            cell.textLabel?.text = showDates[indexPath.row]
        }
        
        return cell
    }

    func customFunc(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("AddDate", sender: UIBarButtonItem())
    }

}
