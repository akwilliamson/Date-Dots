//
//  BackTableVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/7/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import Foundation
import CoreData

class BackTableVC: UITableViewController {
    
// MARK: PROPERTIES
    
    let managedContext = CoreDataStack().managedObjectContext
    let categoryNames = ["All", "Birthdays", "Anniversaries", "Custom"]
    let categoryColors = [UIColor.darkGrayColor(), UIColor.birthdayColor(), UIColor.anniversaryColor(),UIColor.customColor()]
    
// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logEvents(forString: "Back Table Shown")
        registerNibCell(withName: "NavigationCell")
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func registerNibCell(withName name: String) {
        let navigationCellNib = UINib(nibName: name, bundle: nil)
        tableView.registerNib(navigationCellNib, forCellReuseIdentifier: name)
    }
    
// MARK: TABLE VIEW
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryNames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let navigationCell = tableView.dequeueReusableCellWithIdentifier("NavigationCell", forIndexPath: indexPath) as! NavigationCell
        
        navigationCell.setIcon(forIndexPath: indexPath)
        navigationCell.navigationTitle.text = categoryNames[indexPath.row]
        navigationCell.navigationTitle.textColor = categoryColors[indexPath.row]
        
        return navigationCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowDatesTableVC", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationVC = segue.destinationViewController as! UINavigationController
        let destinationVC = navigationVC.topViewController as! DatesTableVC
        let selectedIndex = self.tableView.indexPathForSelectedRow!.row
        
        destinationVC.typeColorForNewDate = categoryColors[selectedIndex]
        destinationVC.menuIndexPath = selectedIndex
        
        switch selectedIndex {
        case 0:
            self.logEvents(forString: "View All")
            destinationVC.typePredicate = nil
            destinationVC.typeColorForNewDate = UIColor.birthdayColor()
        case 1:
            self.logEvents(forString: "View Birthdays")
            destinationVC.typePredicate = NSPredicate(format: "type = %@", "birthday")
        case 2:
            self.logEvents(forString: "View Anniversaries")
            destinationVC.typePredicate = NSPredicate(format: "type = %@", "anniversary")
        case 3:
            self.logEvents(forString: "View Custom")
            destinationVC.typePredicate = NSPredicate(format: "type = %@", "custom")
        default:
            break
        }
    }
    
}