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
                         ("irthdays", UIColor.birthdayColor()),
                     ("nniversaries", UIColor.anniversaryColor()),
                          ("olidays", UIColor.holidayColor())]
    let categoryAbbreviations = ["","B","A","H"]
    
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
        
        let abbreviation = navigationCell.viewWithTag(1) as! CircleLabel
        let categoryLabel = navigationCell.viewWithTag(2) as! UILabel
        let allLabel = navigationCell.viewWithTag(3) as! UILabel
        
        if indexPath.row == 0 {
            abbreviation.hidden = true
            categoryLabel.hidden = true
        } else {
            allLabel.hidden = true
            abbreviation.text = categoryAbbreviations[indexPath.row]
            abbreviation.backgroundColor = categoryValuesTuple[indexPath.row].1
            categoryLabel.text = categoryValuesTuple[indexPath.row].0
            categoryLabel.textColor = categoryValuesTuple[indexPath.row].1
        }
        
        return navigationCell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationVC = segue.destinationViewController as! UINavigationController
        let destinationVC = navigationVC.topViewController as! DatesTableVC
        let index = self.tableView.indexPathForSelectedRow!.row
        
        destinationVC.typeColorForNewDate = categoryValuesTuple[index].1
        destinationVC.menuIndexPath = index
        
        switch index {
        case 0:
            destinationVC.typePredicate = nil
            destinationVC.typeColorForNewDate = UIColor.birthdayColor()
        case 1:
            destinationVC.typePredicate = NSPredicate(format: "type = %@", "birthday")
        case 2:
            destinationVC.typePredicate = NSPredicate(format: "type = %@", "anniversary")
        case 3:
            destinationVC.typePredicate = NSPredicate(format: "type = %@", "holiday")
        default:
            break
        }
    }
    
}