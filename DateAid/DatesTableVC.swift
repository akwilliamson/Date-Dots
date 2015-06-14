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
    var datesArray: [Date] = []
    
    var showDates = [String]()
    var menuIndexPath: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set title
        self.title = "Dates"
        
        // Set bar buttons and corresponding actions
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
        
        // Fetch all dates from core data
        let datesFetch = NSFetchRequest(entityName: "Date")
        var error: NSError?
        datesArray = managedContext.executeFetchRequest(datesFetch, error: &error) as! [Date]
        
        // Detect gesture to reveal/hide side menu
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        // *** Register nib tableviewcells for reuse
        let birthdayNib = UINib(nibName: "BirthdayCell", bundle: nil)
        tableView.registerNib(birthdayNib, forCellReuseIdentifier: "BirthdayCell")
    }

// MARK: - Table view data source

    //
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if menuIndexPath == nil || menuIndexPath == 0 || menuIndexPath == 1 || menuIndexPath == 2 {
            return datesArray.count
        } else {
            return showDates.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd MMM"
        
        // If "All" is selected in the side navigation, show all saved dates
        
        if menuIndexPath == nil || menuIndexPath! == 0 {
            let birthdayCell = tableView.dequeueReusableCellWithIdentifier("BirthdayCell", forIndexPath: indexPath) as! BirthdayCell
            let date = datesArray[indexPath.row]
            birthdayCell.name = date.abbreviatedName
            let stringDate = dayTimePeriodFormatter.stringFromDate(date.date)
            birthdayCell.date = stringDate
            cell = birthdayCell
        } else if menuIndexPath! == 1 {                          // If "Birthdays" is selected in the side navigation, show all birthdays
            let birthdayCell = tableView.dequeueReusableCellWithIdentifier("BirthdayCell", forIndexPath: indexPath) as! BirthdayCell
            let date = datesArray[indexPath.row]
            birthdayCell.name = date.abbreviatedName
            let stringDate = dayTimePeriodFormatter.stringFromDate(date.date)
            birthdayCell.date = stringDate
            cell = birthdayCell
        } else if menuIndexPath! == 2 {                          // If "Birthdays" is selected in the side navigation, show all birthdays
            cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
            let anniversary = datesArray[indexPath.row]
            cell.textLabel?.text = "\(anniversary.name): \(anniversary.date)"
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = showDates[indexPath.row]
        }
        return cell
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