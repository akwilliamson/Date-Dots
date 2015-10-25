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
    var addressDelegate: SetAddressDelegate?
    var managedContext: NSManagedObjectContext?
    let colorForType = ["birthday": UIColor.birthdayColor(), "anniversary": UIColor.anniversaryColor(), "holiday": UIColor.holidayColor()]
    var streetString = ""
    var regionString = ""
    var notificationDelegate: SetNotificationDelegate?

    @IBOutlet weak var addressTextField: AddNameTextField!
    @IBOutlet weak var regionTextField: AddNameTextField!
    @IBOutlet weak var notificationSettingsButton: UIButton!
    @IBOutlet weak var giftNotesButton: UIButton!
    @IBOutlet weak var planNotesButton: UIButton!
    @IBOutlet weak var otherNotesButton: UIButton!
    
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
        
        giftNotesButton.contentHorizontalAlignment = .Left
        giftNotesButton.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0)
        planNotesButton.contentHorizontalAlignment = .Left
        planNotesButton.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0)
        otherNotesButton.contentHorizontalAlignment = .Left
        otherNotesButton.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0)
    }
    
    @IBAction func done(sender: AnyObject) {
        addressDelegate?.setAddressProperties(addressTextField.text, region: regionTextField.text)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditLocalNotification" {
            let singlePushSettingsVC = segue.destinationViewController as! SinglePushSettingsVC
            singlePushSettingsVC.date = date
            singlePushSettingsVC.notificationDelegate = notificationDelegate
        } else {
            let noteVC = segue.destinationViewController as! NoteVC
            noteVC.typeColor = colorForType[date.type!]
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
