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
    // Grab the context
    var managedContext = CoreDataStack().managedObjectContext
    // Bar button items
    var leftBarButtonItem: UIBarButtonItem!
    var rightBarButtonItem: UIBarButtonItem!
    // Holds dates shown in table
    var datesArray = [Date]()
    var menuIndexPath: Int?
    // Format NSDate to be human readable
    let dayTimePeriodFormatter = NSDateFormatter()
    // Colors
    let  aquaColor = UIColor(red:  18/255.0, green: 151/255.0, blue: 147/255.0, alpha: 1)
    let   redColor = UIColor(red: 239/255.0, green: 101/255.0, blue:  85/255.0, alpha: 1)
    let  greyColor = UIColor(red:  80/255.0, green:  80/255.0, blue:  80/255.0, alpha: 1)
    let creamColor = UIColor(red: 255/255.0, green: 245/255.0, blue: 185/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set initial datesArray
        let datesFetch = NSFetchRequest(entityName: "Date")
        var error: NSError?
        if menuIndexPath == nil {
            datesArray = managedContext.executeFetchRequest(datesFetch, error: &error) as! [Date]
        }
        // Configure navigation bar
        self.title = "Date Aid"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: creamColor]
        self.leftBarButtonItem =  UIBarButtonItem(title: "Menu",
                                                  style: .Plain,
                                                 target: self.revealViewController(),
                                                 action: Selector("revealToggle:"))
        self.navigationItem.leftBarButtonItem = self.leftBarButtonItem
        self.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                  style: .Plain,
                                                 target: self,
                                                 action: Selector("customFunc:"))
        self.navigationItem.rightBarButtonItem = self.rightBarButtonItem
        self.navigationController?.navigationBar.barTintColor = aquaColor
        self.navigationController?.navigationBar.tintColor = creamColor
        // Configure tab bar
        self.tabBarController?.tabBar.barTintColor = aquaColor
        // Detect gesture to reveal/hide side menu
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Register nib tableviewcells for reuse
        let dateCellNib = UINib(nibName: "DateCell", bundle: nil)
        tableView.registerNib(dateCellNib, forCellReuseIdentifier: "DateCell")
        // Set date format for display
        dayTimePeriodFormatter.dateFormat = "dd MMM"
    }

// MARK: - Table view data source

    //
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datesArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dateCell = tableView.dequeueReusableCellWithIdentifier("DateCell", forIndexPath: indexPath) as! DateCell
        
        let date = datesArray[indexPath.row]
        dateCell.name = date.abbreviatedName
        let stringDate = dayTimePeriodFormatter.stringFromDate(date.date)
        dateCell.date = stringDate
        
        if menuIndexPath == nil || menuIndexPath! == 0 { // Show all cells and set the right color
            switch date.type {
            case "birthday":
                dateCell.nameLabel.textColor = aquaColor
            case "anniversary":
                dateCell.nameLabel.textColor = redColor
            default: // "holiday":
                dateCell.nameLabel.textColor = greyColor
            }
            
        } else if menuIndexPath! == 1 { // Show birthday cells
            dateCell.nameLabel.textColor = aquaColor
        } else if menuIndexPath! == 2 { // Show anniversary cells
            dateCell.nameLabel.textColor = redColor
        } else {                        // Show holiday cells
            dateCell.nameLabel.textColor = greyColor
        }
        return dateCell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }

    func customFunc(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("AddDate", sender: UIBarButtonItem())
    }
}

/*

How to get number of days until date:

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