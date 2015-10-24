//
//  EditDetailsVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/18/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

class EditDetailsVC: UIViewController {
    
    var date: Date!
    var delegate: SetAddressDelegate?
    var managedContext: NSManagedObjectContext?
    let colorForType = ["birthday": UIColor.birthdayColor(), "anniversary": UIColor.anniversaryColor(), "holiday": UIColor.holidayColor()]
    var streetString = ""
    var regionString = ""

    @IBOutlet weak var addressTextField: AddNameTextField!
    @IBOutlet weak var regionTextField: AddNameTextField!
    @IBOutlet weak var notificationSettingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let dateType = date.type {
            notificationSettingsButton.setTitleColor(colorForType[dateType], forState: .Normal)
        }
        if let street = date.address?.street {
            streetString = street
        }
        if let region = date.address?.region {
            regionString = region
        }
        addressTextField.text = streetString
        regionTextField.text = regionString
        
        addressTextField.delegate = self
        regionTextField.delegate = self
    }
    
    @IBAction func done(sender: AnyObject) {
        delegate?.setAddressProperties(addressTextField.text, region: regionTextField.text)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditLocalNotification" {
            let singlePushSettingsVC = segue.destinationViewController as! SinglePushSettingsVC
            singlePushSettingsVC.date = date
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

extension EditDetailsVC: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let noteCell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath)
        noteCell.textLabel!.text = "This is a note"
        
        return noteCell
    }
}

extension EditDetailsVC: UITableViewDelegate {

}
