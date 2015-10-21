//
//  BackTableVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/7/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import Foundation
import CoreData

class BackTableVC: UITableViewController {
    
// MARK: PROPERTIES
    
    let managedContext = CoreDataStack().managedObjectContext
    let tableArray = ["All", "Birthdays", "Anniversaries", "Holidays"]
    
// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureTopViewInteraction(allowed: false)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        configureTopViewInteraction(allowed: true)
    }
    
// MARK: TABLE VIEW
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let navigationCell = tableView.dequeueReusableCellWithIdentifier("NavigationCell", forIndexPath: indexPath) as UITableViewCell
        let label = navigationCell.viewWithTag(1) as! UILabel
        label.text = tableArray[indexPath.row]
        
        switch tableArray[indexPath.row] {
        case "All":
            label.textColor = UIColor.blackColor()
        case "Birthdays":
            label.textColor = UIColor.birthdayColor()
        case "Anniversaries":
            label.textColor = UIColor.anniversaryColor()
        default:
            label.textColor = UIColor.holidayColor()
        }
        return navigationCell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationVC = segue.destinationViewController as! UINavigationController
        let destinationVC = navigationVC.topViewController as! DatesTableVC
        
        let indexPath = self.tableView.indexPathForSelectedRow
        
        switch indexPath!.row {
        case 0:
            destinationVC.menuIndexPath = 0
            destinationVC.datesPredicate = nil
        case 1:
            destinationVC.menuIndexPath = 1
            destinationVC.datesPredicate = NSPredicate(format: "type = %@", "birthday")
        case 2:
            destinationVC.menuIndexPath = 2
            destinationVC.datesPredicate = NSPredicate(format: "type = %@", "anniversary")
        default: // indexPath!.row = 3
            destinationVC.menuIndexPath = 3
            destinationVC.datesPredicate = NSPredicate(format: "type = %@", "holiday")
        }
    }
    
// MARK: HELPERS
    
    func configureTopViewInteraction(allowed allowed: Bool) {
        if allowed {
            self.revealViewController().frontViewController.view.userInteractionEnabled = true
        } else {
            self.revealViewController().frontViewController.view.userInteractionEnabled = false
        }
        self.revealViewController().view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
}