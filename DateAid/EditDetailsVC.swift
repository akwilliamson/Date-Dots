//
//  EditDetailsVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/18/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit

class EditDetailsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var date: Date!
    var streetString = ""
    var regionString = ""

    @IBOutlet weak var addressTextField: AddNameTextField!
    @IBOutlet weak var regionTextField: AddNameTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let street = date.address?.street {
            streetString = street
        }
        if let city = date.address?.city {
            regionString += "\(city),"
        }
        if let state = date.address?.state {
            regionString += " \(state)"
        }
        if let zip = date.address?.zip {
            regionString += " \(zip)"
        }
        addressTextField.text = streetString
        regionTextField.text = regionString
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let notesCell = tableView.dequeueReusableCellWithIdentifier("NotesCell", forIndexPath: indexPath) 
        notesCell.textLabel!.text = "This is a note"
        
        return notesCell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditLocalNotification" {
            let singlePushSettingsVC = segue.destinationViewController as! SinglePushSettingsVC
            singlePushSettingsVC.date = date
        }
    }

}
