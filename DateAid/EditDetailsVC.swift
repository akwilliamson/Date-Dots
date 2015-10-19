//
//  EditDetailsVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/18/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit

class EditDetailsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let notesCell = tableView.dequeueReusableCellWithIdentifier("NotesCell", forIndexPath: indexPath) 
        notesCell.textLabel!.text = "This is a note"
        
        return notesCell
    }

}
