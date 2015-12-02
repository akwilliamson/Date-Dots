//
//  BackTableVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/7/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import Foundation

class BackTableVC: UITableViewController {
    
    let dateTypeCategories = ["All", "Birthdays", "Anniversaries", "Custom"]
    let dateTypePredicates: [String?] = [nil, "birthday", "anniversary", "custom"]
    
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateTypeCategories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let navigationCell = tableView.dequeueReusableCellWithIdentifier("NavigationCell", forIndexPath: indexPath) as! NavigationCell
        
        navigationCell.setIcon(forIndexPath: indexPath)
        navigationCell.navigationTitle.text = dateTypeCategories[indexPath.row]
        navigationCell.navigationTitle.textColor = dateTypeCategories[indexPath.row].associatedColor()
        
        return navigationCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowDatesTableVC", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let selectedIndex = self.tableView.indexPathForSelectedRow?.row else { return }
        self.logEvents(forString: "View \(dateTypeCategories[selectedIndex])")
        
        guard let navigationVC = segue.destinationViewController as? UINavigationController else { return }
        guard let datesTableVC = navigationVC.topViewController as? DatesTableVC else { return }
        
        let predicate: NSPredicate? = dateTypePredicates[selectedIndex] != nil ? NSPredicate(format: "type = %@", dateTypePredicates[selectedIndex]!) : nil
        datesTableVC.menuIndexPath = selectedIndex
        datesTableVC.typePredicate = predicate
        datesTableVC.typeColorForNewDate = dateTypeCategories[selectedIndex].associatedColor()
        
    }
}