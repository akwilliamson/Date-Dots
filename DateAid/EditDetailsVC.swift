//
//  EditDetailsVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/18/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

class EditDetailsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var date: Date!
    var managedContext: NSManagedObjectContext?
    var streetString = ""
    var regionString = ""

    @IBOutlet weak var addressTextField: AddNameTextField!
    @IBOutlet weak var regionTextField: AddNameTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let street = date.address?.street {
            streetString = street
        }
        if let region = date.address?.region {
            regionString = region
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
    
    @IBAction func saveAddress(sender: AnyObject) {
        if addressTextField.text?.characters.count > 0 {
            date.address?.street = addressTextField.text
        }
        if regionTextField.text?.characters.count > 0 {
            date.address?.region = regionTextField.text
        }
        saveContext()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditLocalNotification" {
            let singlePushSettingsVC = segue.destinationViewController as! SinglePushSettingsVC
            singlePushSettingsVC.date = date
        }
    }
    
    func saveContext() {
        do { try managedContext?.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

}

extension EditDetailsVC: UITextFieldDelegate {
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let _ = touches.first {
            view.endEditing(true)
        }
        super.touchesBegan(touches, withEvent: event)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return false
    }
}
