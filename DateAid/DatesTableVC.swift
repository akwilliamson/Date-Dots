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
    var managedContext = CoreDataStack().managedObjectContext
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
        tableView.tableFooterView = UIView(frame: CGRectZero)
        if tableView.numberOfRowsInSection(0) == 0 {
            let imageView = UIImageView(image: (UIImage(named: "no-birthdays.png")))
            imageView.center = self.tableView.center
            tableView.backgroundView = imageView
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
// MARK: SEGUE
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = tableView.indexPathForSelectedRow
        if segue.identifier == "ShowDateDetails" {
            let dateDetailsVC = segue.destinationViewController as! DateDetailsVC
            dateDetailsVC.date = fetchedResults[indexPath!.row] as Date
            dateDetailsVC.managedContext = managedContext
        }
        if segue.identifier == "CreateNewDate" {
            let addDateVC = segue.destinationViewController as! AddDateVC
            addDateVC.isBeingEdited = false
            addDateVC.managedContext = managedContext
        }
    }
    
// MARK: HELPERS
    
    func addGestureRecognizers() {
        revealViewController().panGestureRecognizer()
        revealViewController().tapGestureRecognizer()
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

        currentDateString = NSDate().formatDateIntoString()
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
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM d"
        title = formatter.stringFromDate(NSDate())
        let navBar = navigationController?.navigationBar
        navBar!.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "AvenirNext-Bold", size: 23)!]
        navBar!.barTintColor = UIColor.birthdayColor()
        navBar!.tintColor = UIColor.whiteColor()
        menuBarButtonItem.target = self.revealViewController()
        menuBarButtonItem.action = Selector("revealToggle:")
    }
    
    func configureTabBar() {
        let tabBar = tabBarController?.tabBar
        tabBar!.barTintColor = UIColor.birthdayColor()
        tabBar!.tintColor = UIColor.whiteColor()
        for item in tabBar!.items! {
            if let image = item.image {
                item.image = image.imageWithColor(UIColor.whiteColor()).imageWithRenderingMode(.AlwaysOriginal)
            }
        }
    }
    
    func configureCell(cell: DateCell, indexPath: NSIndexPath) {
        
        let date = fetchedResultsController!.objectAtIndexPath(indexPath) as! Date
        
        cell.name = date.abbreviatedName!
        cell.date = date.date!.readableDate()
        
        if menuIndexPath == nil || menuIndexPath! == 0 { // Show all cells and set the right color
            switch date.type! {
            case "birthday":
                cell.nameLabel.textColor = UIColor.birthdayColor()
            case "anniversary":
                cell.nameLabel.textColor = UIColor.anniversaryColor()
            default: // "holiday":
                cell.nameLabel.textColor = UIColor.holidayColor()
            }
            
        } else if menuIndexPath! == 1 { // Show birthday cells
            cell.nameLabel.textColor = UIColor.birthdayColor()
        } else if menuIndexPath! == 2 { // Show anniversary cells
            cell.nameLabel.textColor = UIColor.anniversaryColor()
        } else {                        // Show holiday cells
            cell.nameLabel.textColor = UIColor.holidayColor()
        }
    }
}

extension DatesTableVC /* UITableViewDataSource */ {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController!.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dateCell = tableView.dequeueReusableCellWithIdentifier("DateCell", forIndexPath: indexPath) as! DateCell
        
        let date = fetchedResults[indexPath.row]
        dateCell.name = date.abbreviatedName!
        dateCell.date = date.date!.readableDate()
        if menuIndexPath == nil || menuIndexPath! == 0 { // Show all cells and set the right color
            switch date.type! {
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
}

extension DatesTableVC /* UITableViewDelegate */ {
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowDateDetails", sender: self)
    }
    
}

extension DatesTableVC: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Update:
            let cell = tableView.cellForRowAtIndexPath(indexPath!) as! DateCell
            configureCell(cell, indexPath: indexPath!)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        }
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}


