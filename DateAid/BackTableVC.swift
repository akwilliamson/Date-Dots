//
//  BackTableVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/7/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import Foundation

class BackTableVC: UITableViewController {
    
// MARK: PROPERTIES
    
    let categoryNames = ["All", "Birthdays", "Anniversaries", "Custom"]
    let categoryColors = [UIColor.grayColor(), UIColor.birthdayColor(), UIColor.anniversaryColor(),UIColor.customColor()]
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationVC = segue.destinationViewController as! UINavigationController
        let datesTableVC = navigationVC.topViewController as! DatesTableVC
        let selectedIndex = self.tableView.indexPathForSelectedRow!.row
        
        datesTableVC.typeColorForNewDate = categoryColors[selectedIndex]
        datesTableVC.menuIndexPath = selectedIndex
        
        switch selectedIndex {
        case 0:
            self.logEvents(forString: "View All")
            datesTableVC.typePredicate = nil
            datesTableVC.typeColorForNewDate = UIColor.birthdayColor()
        case 1:
            self.logEvents(forString: "View Birthdays")
            datesTableVC.typePredicate = NSPredicate(format: "type = %@", "birthday")
        case 2:
            self.logEvents(forString: "View Anniversaries")
            datesTableVC.typePredicate = NSPredicate(format: "type = %@", "anniversary")
        case 3:
            self.logEvents(forString: "View Custom")
            datesTableVC.typePredicate = NSPredicate(format: "type = %@", "custom")
        default:
            break
        }
    }
    
}