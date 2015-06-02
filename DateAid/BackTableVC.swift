//
//  BackTableVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/7/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import Foundation

class BackTableVC: UITableViewController {
    
    var tableArray = [String]()
    let fakeHolidaysArray = ["holiday 1", "holiday 2", "holiday 3", "holiday 4", "holiday 5"]
    let fakeAnniversariesArray = ["anniversary 1", "anniversary 2", "anniversary 3"]
    
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
        
        var indexPath = self.tableView.indexPathForSelectedRow()
        if indexPath!.row == 0 {
            destinationVC.menuIndexPath = 0
        } else if indexPath!.row == 1 {
            destinationVC.showDates = fakeHolidaysArray
            destinationVC.menuIndexPath = 1
        } else if indexPath!.row == 2 {
            destinationVC.showDates = fakeAnniversariesArray
            destinationVC.menuIndexPath = 2
        }
    }
}