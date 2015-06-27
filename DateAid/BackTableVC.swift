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
    
    var managedContext = CoreDataStack().managedObjectContext
    var tableArray = [String]()
    // Colors
    let   aquaColor = UIColor(red:  18/255.0, green: 151/255.0, blue: 147/255.0, alpha: 1)
    let    redColor = UIColor(red: 239/255.0, green: 101/255.0, blue:  85/255.0, alpha: 1)
    let   greyColor = UIColor(red:  80/255.0, green:  80/255.0, blue:  80/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableArray = ["All", "Birthdays", "Anniversaries", "Holidays"]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let navigationCell = tableView.dequeueReusableCellWithIdentifier("NavigationCell", forIndexPath: indexPath) as! UITableViewCell
        let label = navigationCell.viewWithTag(1) as! UILabel
        label.text = tableArray[indexPath.row]
        
        switch tableArray[indexPath.row] {
        case "All":
            label.textColor = UIColor.blackColor()
        case "Birthdays":
            label.textColor = aquaColor
        case "Anniversaries":
            label.textColor = redColor
        default: // Holidays
            label.textColor = greyColor
        }
        return navigationCell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationVC = segue.destinationViewController as! UINavigationController
        let destinationVC = navigationVC.topViewController as! DatesTableVC
        
        let datesFetch = NSFetchRequest(entityName: "Date")
        var error: NSError?
        
        let indexPath = self.tableView.indexPathForSelectedRow()
        
        switch indexPath!.row {
        case 0:
            destinationVC.menuIndexPath = 0
            destinationVC.datesPredicate = nil
        case 1:
            destinationVC.menuIndexPath = 1
            destinationVC.datesPredicate = NSPredicate(format: "type == %@", "birthday")
        case 2:
            destinationVC.menuIndexPath = 2
            destinationVC.datesPredicate = NSPredicate(format: "type == %@", "anniversary")
        default: // indexPath!.row = 3
            destinationVC.menuIndexPath = 3
            destinationVC.datesPredicate = NSPredicate(format: "type == %@", "holiday")
        }
    }
}