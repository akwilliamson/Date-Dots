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
    
    var dateObject: Date!
    var managedContext: NSManagedObjectContext?
    var addressDelegate: SetAddressDelegate?
    var notificationDelegate: SetNotificationDelegate? // <<< Not used here, but propogated to SinglePushSettingsVC
    var reloadDatesTableDelegate: ReloadDatesTableDelegate?
    
    let colorForType = ["birthday": UIColor.birthdayColor(), "anniversary": UIColor.anniversaryColor(), "custom": UIColor.customColor()]

    @IBOutlet weak var addressTextField: AddNameTextField!
    @IBOutlet weak var regionTextField: AddNameTextField!
    
    @IBOutlet weak var notificationSettingsButton: UIButton!
    @IBOutlet weak var giftNotesButton: UIButton!
    @IBOutlet weak var planNotesButton: UIButton!
    @IBOutlet weak var otherNotesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logEvents(forString: "Edit Details")
        setDateTypeColor(onButtons: [notificationSettingsButton, giftNotesButton, planNotesButton, otherNotesButton])
        populateAddressFields(withAddress: dateObject.address)
    }
    
    func setDateTypeColor(onButtons buttons: [UIButton]) {
        if let dateType = dateObject.type {
            let color = colorForType[dateType]
            buttons.forEach() { $0.setTitleColor(color, forState: .Normal) }
        }
    }
    
    func populateAddressFields(withAddress address: Address?) {
        if let street = address?.street {
            addressTextField.text = street
        }
        if let region = address?.region {
            regionTextField.text = region
        }
    }
    
    @IBAction func done(sender: AnyObject) {
        self.logEvents(forString: "Save Date on EditDetailsVC")
        dateObject.address?.street = addressTextField.text
        dateObject.address?.region = regionTextField.text
        addressDelegate?.repopulateAddressFor(dateObject: dateObject)
        reloadDatesTableDelegate?.reloadTableView()
        do { try managedContext?.save()
            if let dateDetailsVC = self.navigationController?.viewControllers[1] as? DateDetailsVC {
                self.navigationController?.popToViewController(dateDetailsVC, animated: true)
            } else {
                let dateDetailsVC = self.navigationController?.viewControllers[0] as! DatesTableVC
                self.navigationController?.popToViewController(dateDetailsVC, animated: true)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditLocalNotification" {
            let singlePushSettingsVC = segue.destinationViewController as! SinglePushSettingsVC
            singlePushSettingsVC.dateObject = dateObject
            singlePushSettingsVC.notificationDelegate = notificationDelegate
        } else {
            let noteVC = segue.destinationViewController as! NoteVC
            noteVC.typeColor = colorForType[dateObject.type!]
            noteVC.date = dateObject
            noteVC.managedContext = managedContext
            switch segue.identifier! {
            case "ShowGifts":
                noteVC.note = "Gifts"
            case "ShowPlans":
                noteVC.note = "Plans"
            case "ShowOther":
                noteVC.note = "Other"
            default:
                break
            }
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
