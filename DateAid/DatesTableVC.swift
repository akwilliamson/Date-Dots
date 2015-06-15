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
    var holidaysDictionary = [String: NSDate]()
    var menuIndexPath: Int?
    
    // Format NSDate to be human readable
    let dayTimePeriodFormatter = NSDateFormatter()
    
    // Custom colors
    let blueColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1)
    
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
        
        // Detect gesture to reveal/hide side menu
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        // Register nib tableviewcells for reuse
        let dateCellNib = UINib(nibName: "DateCell", bundle: nil)
        tableView.registerNib(dateCellNib, forCellReuseIdentifier: "DateCell")
        
        var myDict: NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource("Holidays", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
            if let myDictionary = myDict {
                for each in myDictionary {
                    holidaysDictionary[each.key as! String] = each.value as? NSDate
                }
            }
        }
        
        dayTimePeriodFormatter.dateFormat = "dd MMM"
    }

// MARK: - Table view data source

    //
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if menuIndexPath == nil || menuIndexPath == 0 || menuIndexPath == 1 || menuIndexPath == 2 {
            return datesArray.count
        } else {
            return holidaysDictionary.count
        }
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
                dateCell.nameLabel.textColor = UIColor.yellowColor()
            case "anniversary":
                dateCell.nameLabel.textColor = UIColor.redColor()
            default:
                dateCell.nameLabel.textColor = blueColor
            }
            
        } else if menuIndexPath! == 1 { // Show birthday cells
            dateCell.nameLabel.textColor = UIColor.yellowColor()
        } else if menuIndexPath! == 2 { // Show anniversary cells
            dateCell.nameLabel.textColor = UIColor.redColor()
        } else {                        // Show holiday cells
            dateCell.nameLabel.textColor = blueColor
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