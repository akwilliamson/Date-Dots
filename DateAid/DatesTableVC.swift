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
    
// MARK: PROPERTIES
    
    var fetchedResultsController: NSFetchedResultsController?
    var fetchedResults = [Date]()
    let managedContext = CoreDataStack().managedObjectContext
    var datesPredicate: NSPredicate?
    var currentDateString: String?
    var menuIndexPath: Int?
    
// MARK: OUTLETS
    
    @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!
    
// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizers() // For SWRevealVC
        registerNibCells() // For custom Date cell
        setFetchedResultsController()
        performFetch()
        sortFetchedResultsArray()
        configureNavigationBar()
        configureTabBar()
    }
    
// MARK: MEMORY
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning in DatesTableVC")
    }

// MARK: TABLE VIEW

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController!.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dateCell = tableView.dequeueReusableCellWithIdentifier("DateCell", forIndexPath: indexPath) as! DateCell
        
        let date = fetchedResults[indexPath.row]
        dateCell.name = date.abbreviatedName
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd MMM"
        let stringDate = dayTimePeriodFormatter.stringFromDate(date.date)
        dateCell.date = stringDate

        if menuIndexPath == nil || menuIndexPath! == 0 { // Show all cells and set the right color
            switch date.type {
            case "birthday":
                dateCell.nameLabel.textColor = UIColor.birthdayColor()
            case "anniversary":
                dateCell.nameLabel.textColor = UIColor.anniversaryColor()
            default: // "holiday":
                dateCell.nameLabel.textColor = UIColor.holidayColor()
            }
            
        } else if menuIndexPath! == 1 { // Show birthday cells
            dateCell.nameLabel.textColor = UIColor.birthdayColor()
        } else if menuIndexPath! == 2 { // Show anniversary cells
            dateCell.nameLabel.textColor = UIColor.anniversaryColor()
        } else {                        // Show holiday cells
            dateCell.nameLabel.textColor = UIColor.holidayColor()
        }
        return dateCell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowDateDetails", sender: self)
    }
    
// MARK: SEGUE
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = tableView.indexPathForSelectedRow
        if segue.identifier == "ShowDateDetails" {
            let dateDetailsVC = segue.destinationViewController as! DateDetailsVC
            dateDetailsVC.date = fetchedResults[indexPath!.row] as Date
        }
    }
    
// MARK: HELPERS
    
    func addGestureRecognizers() {
        // Check if this line is really necessary
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        let revealController = self.revealViewController()
        revealController.panGestureRecognizer()
        revealController.tapGestureRecognizer()
    }
    
    func registerNibCells() {
        let dateCellNib = UINib(nibName: "DateCell", bundle: nil)
        tableView.registerNib(dateCellNib, forCellReuseIdentifier: "DateCell")
    }
    
    func setFetchedResultsController() {
        let datesFetch = NSFetchRequest(entityName: "Date")
        let dateSort = NSSortDescriptor(key: "equalizedDate", ascending: true)
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        datesFetch.sortDescriptors = [dateSort, nameSort]
        datesFetch.predicate = datesPredicate
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: datesFetch, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func performFetch() {
        do { try fetchedResultsController?.performFetch()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func sortFetchedResultsArray() -> [Date] {
        fetchedResults = fetchedResultsController?.fetchedObjects as! [Date]

        currentDateString = formatCurrentDateIntoString(NSDate())
        for fetchedDate in fetchedResults {
            if fetchedDate.equalizedDate < currentDateString! {
                fetchedResults.removeAtIndex(0)
                fetchedResults.append(fetchedDate)
            } else {
                break
            }
        }
        return fetchedResults
    }
    
    func configureNavigationBar() {
        self.title = formatCurrentDateIntoString(NSDate())
        let navBar = navigationController?.navigationBar
        navBar!.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.creamColor()]
        navBar!.barTintColor = UIColor.birthdayColor()
        navBar!.tintColor = UIColor.creamColor()
        menuBarButtonItem.target = self.revealViewController()
        menuBarButtonItem.action = Selector("revealToggle:")
    }
    
    func configureTabBar() {
        let tabBar = tabBarController?.tabBar
        tabBar!.barTintColor = UIColor.birthdayColor()
        tabBar!.tintColor = UIColor.creamColor()
        for item in tabBar!.items! {
            if let image = item.image {
                item.image = image.imageWithColor(UIColor.creamColor()).imageWithRenderingMode(.AlwaysOriginal)
            }
        }
    }
    
    func formatCurrentDateIntoString(date: NSDate) -> String {
        let formatString = NSDateFormatter.dateFormatFromTemplate("MM dd", options: 0, locale: NSLocale.currentLocale())
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = formatString
        return dateFormatter.stringFromDate(NSDate())
    }
}