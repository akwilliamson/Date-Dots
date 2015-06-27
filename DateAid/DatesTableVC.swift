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
    
    var fetchedResultsController: NSFetchedResultsController!
    var fetchedResults = [Date]()
    var managedContext = CoreDataStack().managedObjectContext
    // Date for comparing dates
    var currentDateString: String?
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
    
    @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set initial datesArray
        let datesFetch = NSFetchRequest(entityName: "Date")
        let dateSort = NSSortDescriptor(key: "equalizedDate", ascending: true)
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        datesFetch.sortDescriptors = [dateSort, nameSort]

        fetchedResultsController = NSFetchedResultsController(fetchRequest: datesFetch, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        var error: NSError?
        if menuIndexPath == nil {
            if !fetchedResultsController.performFetch(&error) {
                println(error?.localizedDescription)
            }
        }
        // Compare and sort dates most recent from today
        currentDateString = formatCurrentDateIntoString(NSDate())
        
        fetchedResults = fetchedResultsController.fetchedObjects as! [Date]
        for fetchedDate in fetchedResults {
            if fetchedDate.equalizedDate < currentDateString! {
                fetchedResults.removeAtIndex(0)
                fetchedResults.append(fetchedDate)
            } else {
                break
            }
        }
        
        // Configure navigation bar
        self.title = "Date Aid"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: creamColor]
        menuBarButtonItem.target = self.revealViewController()
        menuBarButtonItem.action = Selector("revealToggle:")
        self.navigationController?.navigationBar.barTintColor = aquaColor
        self.navigationController?.navigationBar.tintColor = creamColor
        // Configure tab bar and tab bar items
        self.tabBarController?.tabBar.barTintColor = aquaColor
        self.tabBarController?.tabBar.tintColor = creamColor
        let items = self.tabBarController?.tabBar.items as! [UITabBarItem]
        for item in items as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(creamColor).imageWithRenderingMode(.AlwaysOriginal)
            }
        }
        // Detect gesture to reveal/hide side menu
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Register nib tableviewcells for reuse
        let dateCellNib = UINib(nibName: "DateCell", bundle: nil)
        tableView.registerNib(dateCellNib, forCellReuseIdentifier: "DateCell")
        // Set date format for display
        dayTimePeriodFormatter.dateFormat = "dd MMM"
    }
    
// MARK: - Custom Methods
    func formatCurrentDateIntoString(date: NSDate) -> String {
        let formatString = NSDateFormatter.dateFormatFromTemplate("MM dd", options: 0, locale: NSLocale.currentLocale())
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = formatString
        return dateFormatter.stringFromDate(NSDate())
    }

// MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section] as! NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dateCell = tableView.dequeueReusableCellWithIdentifier("DateCell", forIndexPath: indexPath) as! DateCell
        
        let date = fetchedResults[indexPath.row]
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowDateDetails", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = tableView.indexPathForSelectedRow()
        if segue.identifier == "ShowDateDetails" {
            let dateDetailsVC = segue.destinationViewController as! DateDetailsVC
            dateDetailsVC.date = datesArray[indexPath!.row] as Date
        }
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