//
//  DatesTableVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/7/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

class DatesTableVC: UITableViewController {
    
    var managedContext = CoreDataStack().context
    
    // Bar button items
    var leftBarButtonItem: UIBarButtonItem!
    var rightBarButtonItem: UIBarButtonItem!
    
    var datesArray: [Date] = []
    
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
        
        // Fetch all dates from core data
        let datesFetch = NSFetchRequest(entityName: "Date")
        var error: NSError?
        datesArray = managedContext.executeFetchRequest(datesFetch, error: &error) as! [Date]
    }

// MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if menuIndexPath == nil || menuIndexPath == 0 {
            return datesArray.count
        } else {
            return showDates.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        if menuIndexPath == nil {
            let date = datesArray[indexPath.row]
            cell.textLabel?.text = "\(date.name): \(date.date)"
        } else {
            cell.textLabel?.text = showDates[indexPath.row]
        }
        
        return cell
    }

    func customFunc(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("AddDate", sender: UIBarButtonItem())
    }

}

/*

How to get days until date:

func daysBetween(date1: NSDate, date2: NSDate) -> Int {
    var unitFlags = NSCalendarUnit.CalendarUnitDay
    var calendar = NSCalendar.currentCalendar()
    var components = calendar.components(unitFlags, fromDate: date1, toDate: date2, options: nil)
    return 365 - (components.day)
}

var daysAway = daysBetween(contactDate, date2: NSDate())
while daysAway < 0 {
    daysAway = daysAway + 365
}

*/