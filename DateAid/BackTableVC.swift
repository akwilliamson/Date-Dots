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
    
    var managedContext = CoreDataStack().managedObjectContext
    
    var tableArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableArray = ["All", "Birthdays", "Anniversaries", "Holidays"]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = tableArray[indexPath.row]
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let navigationVC = segue.destinationViewController as! UINavigationController
        let destinationVC = navigationVC.topViewController as! DatesTableVC
        
        let datesFetch = NSFetchRequest(entityName: "Date")
        let indexPath = self.tableView.indexPathForSelectedRow()
        
        if indexPath!.row == 0 {
            
            destinationVC.menuIndexPath = 0
            
        } else if indexPath!.row == 1 {
            
            destinationVC.menuIndexPath = 1
            datesFetch.predicate = NSPredicate(format: "type == %@", "birthday")
            var error: NSError?
            if let birthdaysArray = managedContext.executeFetchRequest(datesFetch, error: &error) as? [Date] {
                destinationVC.datesArray = birthdaysArray
            }
            
        } else if indexPath!.row == 2 {
            
            destinationVC.menuIndexPath = 2
            datesFetch.predicate = NSPredicate(format: "type == %@", "anniversary")
            var error: NSError?
            if let anniversariesArray = managedContext.executeFetchRequest(datesFetch, error: &error) as? [Date] {
                destinationVC.datesArray = anniversariesArray
            }
            
        } else {
            
            destinationVC.menuIndexPath = 3
            
            
        }
    }
}