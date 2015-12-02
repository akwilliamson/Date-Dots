//
//  DatesTableVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/7/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

protocol ReloadDatesTableDelegate {
    func reloadTableView()
}

class DatesTableVC: UITableViewController {
    
// MARK: PROPERTIES
    
    var menuIndexPath: Int?
    var typePredicate: NSPredicate?
    var fetchedResults: [Date]?
    var managedContext = CoreDataStack().managedObjectContext
    var sidebarMenuOpen: Bool?
    
    // Search
    var filteredResults = [Date]()
    var resultSearchController = UISearchController()
    
    var typeColorForNewDate = UIColor.birthdayColor() // nil menu index path defaults to birthday color
    let typeStrings = ["dates", "birthdays", "anniversaries", "custom"]
    
// MARK: OUTLETS
    
    @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!
    
// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logEvents(forString: "Main View")
        setAndPerformFetchRequest()
        registerNibCell(withName: "DateCell")
        addRevealVCGestureRecognizers()
        configureNavigationBar()
        addSearchBar()
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addSearchBar()
        setAndPerformFetchRequest()
        
        for item in tabBarController!.tabBar.items! {
            if let image = item.image {
                item.image = image.imageWithColor(UIColor.whiteColor()).imageWithRenderingMode(.AlwaysOriginal)
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        resultSearchController.active = false
        super.viewWillDisappear(true)
    }
    
// MARK: HELPERS
    
    func setAndPerformFetchRequest() {
        let datesFetch = NSFetchRequest(entityName: "Date")
        let datesInOrder = NSSortDescriptor(key: "equalizedDate", ascending: true)
        let namesInOrder = NSSortDescriptor(key: "name", ascending: true)
        datesFetch.sortDescriptors = [datesInOrder, namesInOrder]
        datesFetch.predicate = typePredicate
        
        do { fetchedResults = try managedContext.executeFetchRequest(datesFetch) as? [Date]
            if fetchedResults!.count > 0 {
                for date in fetchedResults! {
                    if date.equalizedDate < NSDate().formatDateIntoString() {
                        fetchedResults!.removeAtIndex(0)
                        fetchedResults!.append(date)
                    }
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func addSearchBar() {
        resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.sizeToFit()
        resultSearchController.searchBar.tintColor = UIColor.birthdayColor()
        definesPresentationContext = true
        tableView.tableHeaderView = resultSearchController.searchBar
        tableView.reloadData()
    }
    
    func addRevealVCGestureRecognizers() {
        revealViewController().panGestureRecognizer()
        revealViewController().tapGestureRecognizer()
        revealViewController().delegate = self
    }
    
    func registerNibCell(withName name: String) {
        let dateCellNib = UINib(nibName: name, bundle: nil)
        tableView.registerNib(dateCellNib, forCellReuseIdentifier: name)
    }
    
    func configureNavigationBar() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM d"
        title = formatter.stringFromDate(NSDate())
        menuBarButtonItem.target = self.revealViewController()
        menuBarButtonItem.action = Selector("revealToggle:")
    }
    
    func addNoDatesLabel() {
        if resultSearchController.active == false {
            let label = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height))
            if let indexPath = menuIndexPath {
                label.text = "No \(typeStrings[indexPath]) added"
            } else {
                label.text = "No dates found"
            }
            label.font = UIFont(name: "AvenirNext-Bold", size: 25)
            label.textColor = UIColor.lightGrayColor()
            label.textAlignment = .Center
            label.sizeToFit()
            tableView.backgroundView = label
            tableView.separatorStyle = .None
        }
    }
    
// MARK: SEGUE
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DateDetailsVC" {
            let dateDetailsVC = segue.destinationViewController as! DateDetailsVC
            if resultSearchController.active == true {
                dateDetailsVC.dateObject = filteredResults[tableView.indexPathForSelectedRow!.row]
            } else {
                dateDetailsVC.dateObject = fetchedResults![tableView.indexPathForSelectedRow!.row]
            }
            dateDetailsVC.managedContext = managedContext
            dateDetailsVC.reloadDatesTableDelegate = self
        }
        if segue.identifier == "AddDateVC" {
            let addDateVC = segue.destinationViewController as! AddDateVC
            addDateVC.isBeingEdited = false
            addDateVC.managedContext = managedContext
            addDateVC.incomingColor = typeColorForNewDate
            addDateVC.reloadDatesTableDelegate = self
        }
    }
}

extension DatesTableVC { // UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if resultSearchController.active {
            if filteredResults.count == 0 {
                addNoDatesLabel()
            }
            return filteredResults.count
        } else {
            if fetchedResults!.count == 0 {
                addNoDatesLabel()
            }
            return fetchedResults!.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dateCell = tableView.dequeueReusableCellWithIdentifier("DateCell", forIndexPath: indexPath) as! DateCell
        
        let date = resultSearchController.active == true ? filteredResults[indexPath.row] : fetchedResults![indexPath.row]
        
        if let firstName = date.name?.firstName(), let readableDate = date.date?.readableDate(), let lastName = date.name?.lastName() {
            if date.type! == "custom" {
                dateCell.firstName = date.name!
                dateCell.lastName = ""
            } else {
                dateCell.firstName = firstName
                dateCell.lastName = lastName
            }
            dateCell.date = readableDate
        }
        
        dateCell.firstNameLabel.textColor = date.type?.associatedColor()
        
        return dateCell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            self.logEvents(forString: "Swiped to Delete")
            let dateToDelete = fetchedResults![indexPath.row]
            managedContext.deleteObject(dateToDelete)
            fetchedResults?.removeAtIndex(indexPath.row)
            
            do { try managedContext.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        
    }
}

extension DatesTableVC { // UITableViewDelegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return sidebarMenuOpen == true ? nil : indexPath
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        resultSearchController.searchBar.hidden = true
        self.performSegueWithIdentifier("DateDetailsVC", sender: self)
    }
}

extension DatesTableVC: ReloadDatesTableDelegate {

    func reloadTableView() {
        setAndPerformFetchRequest()
        tableView.reloadData()
    }
    
}

extension DatesTableVC: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filteredResults.removeAll(keepCapacity: false)
        let searchPredicate = NSPredicate(format: "name CONTAINS %@", searchController.searchBar.text!)
        let array = (fetchedResults! as NSArray).filteredArrayUsingPredicate(searchPredicate)
        filteredResults = array as! [Date]
        tableView.reloadData()
    }
    
}

extension DatesTableVC: SWRevealViewControllerDelegate {

    func revealController(revealController: SWRevealViewController!,  willMoveToPosition position: FrontViewPosition) {
        if position == .Left {
             self.view.userInteractionEnabled = true
            sidebarMenuOpen = false
        } else {
             self.view.userInteractionEnabled = false
            sidebarMenuOpen = true
        }
    }

}
