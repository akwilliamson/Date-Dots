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
    
    var menuIndexPath: Int?
    var datesPredicate: NSPredicate?
    
    let colorForType = ["birthday": UIColor.birthdayColor(), "anniversary": UIColor.anniversaryColor(), "holiday": UIColor.holidayColor()]
    var typeColorForNewDate = UIColor.birthdayColor()
    
    var managedContext = CoreDataStack().managedObjectContext
    var fetchedResultsController: NSFetchedResultsController?
    var fetchedResults = [Date]()
    
// MARK: OUTLETS
    
    @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!
    
// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFetchControllerWithOptions()
        performFetch()
        registerDateCellNib()
        sortFetchedResultsArray()
        addRevealVCGestureRecognizers()
        configureNavigationBar()
        configureTabBar()
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        if tableView.numberOfRowsInSection(0) == 0 {
            let imageView = UIImageView(image: (UIImage(named: "no-birthdays.png")))
            imageView.center = self.tableView.center
            tableView.backgroundView = imageView
        }
    }
    
// MARK: HELPERS
    
    func addRevealVCGestureRecognizers() {
        revealViewController().panGestureRecognizer()
        revealViewController().tapGestureRecognizer()
    }
    
    func registerDateCellNib() {
        let dateCellNib = UINib(nibName: "DateCell", bundle: nil)
        tableView.registerNib(dateCellNib, forCellReuseIdentifier: "DateCell")
    }
    
    func setFetchControllerWithOptions() {
        let datesFetch = NSFetchRequest(entityName: "Date")
        let dateSort = NSSortDescriptor(key: "equalizedDate", ascending: true)
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        datesFetch.sortDescriptors = [dateSort, nameSort]
        datesFetch.predicate = datesPredicate
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: datesFetch, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func performFetch() {
        do { try fetchedResultsController?.performFetch()
            fetchedResults = fetchedResultsController?.fetchedObjects as! [Date]
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func sortFetchedResultsArray() -> [Date] {
        for fetchedDate in fetchedResults {
            if fetchedDate.equalizedDate < NSDate().formatDateIntoString() {
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
        if let navBar = navigationController?.navigationBar {
            navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "AvenirNext-Bold", size: 23)!]
            navBar.barTintColor = UIColor.birthdayColor()
            navBar.tintColor = UIColor.whiteColor()
        }
        menuBarButtonItem.target = self.revealViewController()
        menuBarButtonItem.action = Selector("revealToggle:")
    }
    
    func configureTabBar() {
        if let tabBar = tabBarController?.tabBar {
            tabBar.barTintColor = UIColor.birthdayColor()
            tabBar.tintColor = UIColor.whiteColor()
            for item in tabBar.items! {
                if let image = item.image {
                    item.image = image.imageWithColor(UIColor.whiteColor()).imageWithRenderingMode(.AlwaysOriginal)
                }
            }
        }
    }
    
// MARK: SEGUE
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DateDetailsVC" {
            let indexPath = tableView.indexPathForSelectedRow!
            let dateDetailsVC = segue.destinationViewController as! DateDetailsVC
            dateDetailsVC.date = fetchedResults[indexPath.row] as Date
            dateDetailsVC.managedContext = managedContext
        }
        if segue.identifier == "AddDateVC" {
            let addDateVC = segue.destinationViewController as! AddDateVC
            addDateVC.isBeingEdited = false
            addDateVC.managedContext = managedContext
            addDateVC.incomingColor = typeColorForNewDate
        }
    }
}

extension DatesTableVC { // UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController!.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dateCell = tableView.dequeueReusableCellWithIdentifier("DateCell", forIndexPath: indexPath) as! DateCell
        
        let date = fetchedResults[indexPath.row]
        
        if let abbreviatedName = date.abbreviatedName, let readableDate = date.date?.readableDate() {
            dateCell.name = abbreviatedName
            dateCell.date = readableDate
        }
        
        if let colorIndex = menuIndexPath {
            switch colorIndex {
            case 1:
                dateCell.nameLabel.textColor = colorForType["birthday"]
            case 2:
                dateCell.nameLabel.textColor = colorForType["anniversary"]
            case 3:
                dateCell.nameLabel.textColor = colorForType["holiday"]
            default:
                if let dateType = date.type {
                    dateCell.nameLabel.textColor = colorForType[dateType]
                }
            }
        } else {
            if let dateType = date.type {
                dateCell.nameLabel.textColor = colorForType[dateType]
            }
        }
        return dateCell
    }
}

extension DatesTableVC { // UITableViewDelegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("DateDetailsVC", sender: self)
    }
    
}


