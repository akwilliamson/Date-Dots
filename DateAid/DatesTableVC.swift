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
    var typePredicate: NSPredicate?
    
    let colorForType = ["birthday": UIColor.birthdayColor(), "anniversary": UIColor.anniversaryColor(), "holiday": UIColor.holidayColor()]
    var typeColorForNewDate = UIColor.birthdayColor() // nil menu index path defaults to birthday color
    let typeStrings = ["dates", "birthdays", "anniversaries", "holidays"]
    
    var fetchedResults: [Date]?
    
    var managedContext = CoreDataStack().managedObjectContext
    
// MARK: OUTLETS
    
    @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!
    
// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAndPerformFetchRequest()
        
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
    
    func setAndPerformFetchRequest() {
        let datesFetch = NSFetchRequest(entityName: "Date")
        let datesInOrder = NSSortDescriptor(key: "equalizedDate", ascending: true)
        let namesInOrder = NSSortDescriptor(key: "name", ascending: true)
        datesFetch.sortDescriptors = [datesInOrder, namesInOrder]
        datesFetch.predicate = typePredicate
        
        do { fetchedResults = try managedContext.executeFetchRequest(datesFetch) as? [Date]
            if fetchedResults != nil && fetchedResults?.count > 0 {
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
    
    func addRevealVCGestureRecognizers() {
        revealViewController().panGestureRecognizer()
        revealViewController().tapGestureRecognizer()
    }
    
    func registerDateCellNib() {
        let dateCellNib = UINib(nibName: "DateCell", bundle: nil)
        tableView.registerNib(dateCellNib, forCellReuseIdentifier: "DateCell")
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
            dateDetailsVC.date = fetchedResults![tableView.indexPathForSelectedRow!.row]
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
        var numberOfRows = 0
        if let fetchedResults = fetchedResults {
            numberOfRows = fetchedResults.count
        }
        if numberOfRows == 0 {
            addNoDatesLabel()
        }
        return numberOfRows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dateCell = tableView.dequeueReusableCellWithIdentifier("DateCell", forIndexPath: indexPath) as! DateCell
        
        if let results = fetchedResults {
            let date = results[indexPath.row]
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
        }
        return dateCell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("DateDetailsVC", sender: self)
    }
    
}


