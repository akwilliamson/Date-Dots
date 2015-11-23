//
//  NotesTableVCTableViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/21/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

class NotesTableVC: UITableViewController {

    var typeColor: UIColor!
    var managedContext: NSManagedObjectContext?
    let noteTitles = ["Gifts","Plans","Other"]
    var dateObject: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logEvents(forString: "Notes Main View")
        registerNibCell(withName: "NoteCell")
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func registerNibCell(withName name: String) {
        let noteCellNib = UINib(nibName: name, bundle: nil)
        tableView.registerNib(noteCellNib, forCellReuseIdentifier: name)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as! NoteCell

        cell.nameLabel?.text = noteTitles[indexPath.row]
        cell.nameLabel?.textColor = typeColor
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowNote", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let noteVC = segue.destinationViewController as! NoteVC
        noteVC.managedContext = managedContext
        noteVC.dateObject = dateObject
        noteVC.noteTitle = noteTitles[indexPath.row]
    }
}
