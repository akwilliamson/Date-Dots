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
        registerNibCell(withName: "NoteCell")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func registerNibCell(withName name: String) {
        let noteCellNib = UINib(nibName: name, bundle: nil)
        tableView.register(noteCellNib, forCellReuseIdentifier: name)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell

        cell.nameLabel?.text = noteTitles[(indexPath as NSIndexPath).row]
        cell.nameLabel?.textColor = typeColor
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowNote", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let noteVC = segue.destination as! NoteVC
        noteVC.managedContext = managedContext
        noteVC.dateObject = dateObject
        noteVC.noteTitle = noteTitles[(indexPath as NSIndexPath).row]
    }
}
