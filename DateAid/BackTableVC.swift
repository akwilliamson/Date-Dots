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
    let   blueColor = UIColor(red:  37/255.0, green:  62/255.0, blue: 102/255.0,  alpha: 1)
    let orangeColor = UIColor(red: 239/255.0, green: 101/255.0, blue:  85/255.0,  alpha: 1)
    let   goldColor = UIColor(red: 194/255.0, green: 157/255.0, blue:  98/255.0,  alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableArray = ["All", "Birthdays", "Anniversaries", "Holidays"]
        let navigationCelllNib = UINib(nibName: "NavigationCell", bundle: nil)
        tableView.registerNib(navigationCelllNib, forCellReuseIdentifier: "NavigationCell")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var navigationCell = tableView.dequeueReusableCellWithIdentifier("NavigationCell", forIndexPath: indexPath) as! NavigationCell
        navigationCell.nameLabel.text = tableArray[indexPath.row]
        switch tableArray[indexPath.row] {
        case "All":
            navigationCell.nameLabel.textColor = UIColor.blackColor()
        case "Birthdays":
            navigationCell.nameLabel.textColor = blueColor
        case "Anniversaries":
            navigationCell.nameLabel.textColor = orangeColor
        default: // Holidays
            navigationCell.nameLabel.textColor = goldColor
        }
        return navigationCell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("hey")
        let navigationVC = segue.destinationViewController as! UINavigationController
        let destinationVC = navigationVC.topViewController as! DatesTableVC
        
        let datesFetch = NSFetchRequest(entityName: "Date")
        var error: NSError?
        
        let indexPath = self.tableView.indexPathForSelectedRow()
        
        switch indexPath!.row {
        case 0:
            destinationVC.menuIndexPath = 0
            if let allDatesArray = managedContext.executeFetchRequest(datesFetch, error: &error) as? [Date] {
                destinationVC.datesArray = allDatesArray
            }
        case 1:
            destinationVC.menuIndexPath = 1
            datesFetch.predicate = NSPredicate(format: "type == %@", "birthday")
            if let birthdaysArray = managedContext.executeFetchRequest(datesFetch, error: &error) as? [Date] {
                destinationVC.datesArray = birthdaysArray
            }
        case 2:
            destinationVC.menuIndexPath = 2
            datesFetch.predicate = NSPredicate(format: "type == %@", "anniversary")
            if let anniversariesArray = managedContext.executeFetchRequest(datesFetch, error: &error) as? [Date] {
                destinationVC.datesArray = anniversariesArray
            }
        default: // indexPath!.row = 3
            destinationVC.menuIndexPath = 3
            datesFetch.predicate = NSPredicate(format: "type == %@", "holiday")
            if let holidaysArray = managedContext.executeFetchRequest(datesFetch, error: &error) as? [Date] {
                destinationVC.datesArray = holidaysArray
            }
        }
    }
}