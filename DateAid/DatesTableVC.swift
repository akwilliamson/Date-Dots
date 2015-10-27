//
//  DatesTableVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/7/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

class DatesTableVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
// MARK: PROPERTIES
    
    var menuIndexPath: Int?
    var typePredicate: NSPredicate?
    var soonestPredicate = NSPredicate(format: "equalizedDate > %@", NSDate().formatDateIntoString())
    
    let colorForType = ["birthday": UIColor.birthdayColor(), "anniversary": UIColor.anniversaryColor(), "holiday": UIColor.holidayColor()]
    var typeColorForNewDate = UIColor.birthdayColor() // nil menu index path defaults to birthday color
    let typeStrings = ["dates", "birthdays", "anniversaries", "holidays"]
    var soonestDate: Date?
    
    var managedContext = CoreDataStack().managedObjectContext
    var fetchedResultsController: NSFetchedResultsController?
    
// MARK: OUTLETS
    
    @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!
    
// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSoonestDate()
        setFetchControllerWithOptions()
        performFRCFetch()
        
        registerDateCellNib()
        addRevealVCGestureRecognizers()
        configureNavigationBar()
        configureTabBar()

        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        fetchedResultsController?.delegate = self
        
        let datesFetch = createDateFetchRequestWithSorting()
        datesFetch.predicate = typePredicate
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: datesFetch, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func createDateFetchRequestWithSorting() -> NSFetchRequest {
        let datesFetch = NSFetchRequest(entityName: "Date")
        let dateSort = NSSortDescriptor(key: "equalizedDate", ascending: true)
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        datesFetch.sortDescriptors = [dateSort, nameSort]
        
        return datesFetch
    }
    
    func getSoonestDate() {
        let dateFetch = createDateFetchRequestWithSorting()
        dateFetch.fetchLimit = 1
        
        if let typePredicate = typePredicate {
            dateFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [typePredicate, soonestPredicate])
        } else {
            dateFetch.predicate = soonestPredicate
        }
        performMOCFetch(dateFetch)
        if soonestDate == nil {
            getFirstDate()
        }
    }
    
    func getFirstDate() {
        let dateFetch = createDateFetchRequestWithSorting()
        dateFetch.fetchLimit = 1
        
        if let typePredicate = typePredicate {
            dateFetch.predicate = typePredicate
        }
        performMOCFetch(dateFetch)
    }
    
    func performMOCFetch(fetch: NSFetchRequest) {
        do { let result = try managedContext.executeFetchRequest(fetch) as! [Date]
            if result.count > 0 {
                soonestDate = result.first
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func performFRCFetch() {
        do { try fetchedResultsController?.performFetch()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
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
    
    func getProperDate(indexPath: NSIndexPath) -> Date {
        let soonestIndexPath = fetchedResultsController?.indexPathForObject(soonestDate!)
        let count = fetchedResultsController?.sections?.first?.numberOfObjects
        let actualIndex = NSIndexPath(forRow: (soonestIndexPath!.row + indexPath.row) % count!, inSection: 0)
        return fetchedResultsController?.objectAtIndexPath(actualIndex) as! Date
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
    
    func addNoDatesLabel() {
        let label = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height))
        if let indexPath = menuIndexPath {
            label.text = "No \(typeStrings[indexPath]) added"
        } else {
            label.text = "No dates added"
        }
        label.font = UIFont(name: "AvenirNext-Bold", size: 23)
        label.textColor = UIColor.lightGrayColor()
        label.textAlignment = .Center
        label.sizeToFit()
        tableView.backgroundView = label
        tableView.separatorStyle = .None
    }
    
// MARK: SEGUE
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DateDetailsVC" {
            let dateDetailsVC = segue.destinationViewController as! DateDetailsVC
            dateDetailsVC.date = getProperDate(tableView.indexPathForSelectedRow!)
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
        let sectionInfo = fetchedResultsController!.sections![section]
            if sectionInfo.numberOfObjects == 0 {
                addNoDatesLabel()
            }
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dateCell = tableView.dequeueReusableCellWithIdentifier("DateCell", forIndexPath: indexPath) as! DateCell
        
        let date = getProperDate(indexPath)
        
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
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let dateToDelete = getProperDate(indexPath)
            fetchedResultsController?.managedObjectContext.deleteObject(dateToDelete)
            
            do { try managedContext.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    
}

extension DatesTableVC { // UITableViewDelegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("DateDetailsVC", sender: self)
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject object: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
            switch type {
            case .Delete:
                if let indexPath = indexPath {
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
            default:
                return
            }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
}


