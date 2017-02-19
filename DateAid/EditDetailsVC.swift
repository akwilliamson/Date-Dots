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

    @IBOutlet weak var addressTextField: AddNameTextField!
    @IBOutlet weak var regionTextField: AddNameTextField!
    
    @IBOutlet weak var giftNotesButton: UIButton!
    @IBOutlet weak var planNotesButton: UIButton!
    @IBOutlet weak var otherNotesButton: UIButton!
    
    @IBOutlet weak var notificationSettingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logEvents(forString: "Edit Details")
        setColorTheme(for: dateObject.color)
        populateAddressFields(withAddress: dateObject.address)
    }
    
    func setColorTheme(for color: UIColor) {
        [giftNotesButton, planNotesButton, otherNotesButton, notificationSettingsButton].forEach() {
            $0.setTitleColor(color, for: .normal)
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
    
    @IBAction func done(_ sender: AnyObject) {
        self.logEvents(forString: "Save Date on EditDetailsVC")
        dateObject.address?.street = addressTextField.text
        dateObject.address?.region = regionTextField.text
        addressDelegate?.repopulateAddressFor(dateObject: dateObject)
        
        do { try managedContext?.save()
            if let DateDetailsViewController = self.navigationController?.viewControllers[1] as? DateDetailsViewController {
                _ = self.navigationController?.popToViewController(DateDetailsViewController, animated: true)
            } else {
                let datesVC = self.navigationController?.viewControllers[0] as! DatesViewController
                _ = self.navigationController?.popToViewController(datesVC, animated: true)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditLocalNotification" {
            let singlePushSettingsVC = segue.destination as! SinglePushSettingsVC
            singlePushSettingsVC.dateObject = dateObject
            singlePushSettingsVC.notificationDelegate = notificationDelegate
        } else {
            let noteVC = segue.destination as! NoteVC
            noteVC.dateObject = dateObject
            noteVC.managedContext = managedContext
            switch segue.identifier! {
            case "ShowGifts":
                noteVC.noteTitle = "Gifts"
            case "ShowPlans":
                noteVC.noteTitle = "Plans"
            case "ShowOther":
                noteVC.noteTitle = "Other"
            default:
                break
            }
        }
    }
}

extension EditDetailsVC: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return false
    }
}
