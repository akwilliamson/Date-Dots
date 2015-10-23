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
    let categoryValuesTuple = [("All", UIColor.darkGrayColor()),
                         ("Birthdays", UIColor.birthdayColor()),
                     ("Anniversaries", UIColor.anniversaryColor()),
                          ("Holidays", UIColor.holidayColor())]
    
// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
// MARK: TABLE VIEW
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryValuesTuple.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let navigationCell = tableView.dequeueReusableCellWithIdentifier("NavigationCell", forIndexPath: indexPath) as UITableViewCell
        
        let categoryLabel = navigationCell.viewWithTag(1) as! UILabel
        categoryLabel.text = categoryValuesTuple[indexPath.row].0
        categoryLabel.textColor = categoryValuesTuple[indexPath.row].1
        
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
            destinationVC.typeColorForNewDate = UIColor.birthdayColor()
        case 1:
            destinationVC.menuIndexPath = 1
            destinationVC.datesPredicate = NSPredicate(format: "type = %@", "birthday")
            destinationVC.typeColorForNewDate = UIColor.birthdayColor()
        case 2:
            destinationVC.menuIndexPath = 2
            destinationVC.datesPredicate = NSPredicate(format: "type = %@", "anniversary")
            destinationVC.typeColorForNewDate = UIColor.anniversaryColor()
        case 3:
            destinationVC.menuIndexPath = 3
            destinationVC.datesPredicate = NSPredicate(format: "type = %@", "holiday")
            destinationVC.typeColorForNewDate = UIColor.holidayColor()
        default:
            break
        }
    }
    
}