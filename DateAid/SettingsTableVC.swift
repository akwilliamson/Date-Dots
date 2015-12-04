//
//  SettingsTableVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 11/2/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import AddressBook

class SettingsTableVC: UIViewController {
    
    var settingsLabelIsActive = false
    var reloadDatesTableDelegate: ReloadDatesTableDelegate?
    var settingsLabelColor: UIColor?
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    lazy var contactImporter: ContactImporter = {
        return ContactImporter()
    }()
    
    @IBOutlet weak var syncCancel: CircleLabel!
    @IBOutlet weak var iCloudCancel: CircleLabel!
    @IBOutlet weak var alertCancel: CircleLabel!
    @IBOutlet weak var colorCancel: CircleLabel!
    
    @IBOutlet weak var syncLabel: UILabel!
    @IBOutlet weak var iCloudLabel: UILabel!
    @IBOutlet weak var alertsLabel: UILabel!
    @IBOutlet weak var colorsLabel: UILabel!
    
    @IBOutlet weak var syncSetting: CircleLabel!
    @IBOutlet weak var iCloudSetting: CircleLabel!
    @IBOutlet weak var alertSetting: CircleLabel!
    @IBOutlet weak var colorSetting: CircleLabel!
    
    @IBOutlet var allSettingsLabels: Array<CircleLabel>!
    @IBOutlet var allTextLabels: Array<UILabel>!
    @IBOutlet var allCancelLabels: Array<CircleLabel>!
    
    @IBOutlet weak var alertYearlyButton: UIButton!
    @IBOutlet weak var alertOnceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logEvents(forString: "Settings")
        addGestureRecognizers()
        setIndicesForLabels()
        alertToggle(selectedButton: alertYearlyButton, offButton: alertOnceButton)
        reloadDatesTableDelegate = tabBarController?.viewControllers?[0].childViewControllers[1].childViewControllers[0] as? DatesTableVC
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        toggleCancelLabels(shouldBeHidden: true)
        animateSettingsLabelsIntoView()
        delay(1) { self.toggleCancelLabels(shouldBeHidden: false) }
    }
    
    func alertToggle(selectedButton onButton: UIButton, offButton: UIButton) {
        
        guard let alertYearly = userDefaults.objectForKey("alertYearly") as? Bool else {
            onButton.backgroundColor = UIColor.anniversaryColor()
            offButton.backgroundColor = UIColor.lightGrayColor()
            onButton.layer.cornerRadius = 5
            onButton.clipsToBounds = true
            offButton.layer.cornerRadius = 5
            offButton.clipsToBounds = true
            return
        }
        
        if alertYearly == true {
            onButton.backgroundColor = UIColor.anniversaryColor()
            offButton.backgroundColor = UIColor.lightGrayColor()
        } else {
            offButton.backgroundColor = UIColor.anniversaryColor()
            onButton.backgroundColor = UIColor.lightGrayColor()
        }
        onButton.layer.cornerRadius = 5
        onButton.clipsToBounds = true
        offButton.layer.cornerRadius = 5
        offButton.clipsToBounds = true
    }
    
    func setIndicesForLabels() {
        for (index, label) in allSettingsLabels.enumerate() { label.index = index }
        for (index, label) in allCancelLabels.enumerate() { label.index = index }
    }
    
    func addGestureRecognizers() {
        allSettingsLabels.forEach({
            $0.addTapGestureRecognizer(forAction: "slideRightOrLeft:", inController: self)
        })
        allCancelLabels.forEach({
            $0.addTapGestureRecognizer(forAction: "cancelButtonPressed:", inController: self)
        })
    }
    
    func toggleCancelLabels(shouldBeHidden hidden: Bool) {
        allCancelLabels.forEach({ $0.hidden = hidden })
    }
    
    func animateSettingsLabelsIntoView() {
        var delay: NSTimeInterval = 0
        allSettingsLabels.forEach({ $0.animate(intoView: view, toPosition: syncCancel.center.x, withDelay: delay); delay += 0.03 })
    }
    
    func slideRightOrLeft(sender: UITapGestureRecognizer) {
        guard let labelSelected = sender.view as? CircleLabel else { return }
        if settingsLabelIsActive == false {
            rollToTheRight(forLabel: labelSelected)
        } else {
            performAction(forLabel: labelSelected)
            rollToTheLeft(forLabel: labelSelected)
        }
    }
    
    func performAction(forLabel labelSelected: CircleLabel) {
        switch labelSelected {
        case syncSetting:
            syncAddressBook()
        case alertSetting:
            saveAlertRepeatPreference()
        default:
            break
        }
    }
    
    func syncAddressBook() {
        let status = ABAddressBookGetAuthorizationStatus()
        self.contactImporter.syncContacts(status: status)
        if status == .Authorized {
            self.reloadDatesTableDelegate?.reloadTableView()
        } else {
            self.showContactsUnaccessibleAlert()
        }
    }
    
    func saveAlertRepeatPreference() {
        if alertYearlyButton.backgroundColor == UIColor.anniversaryColor() {
            userDefaults.setBool(true, forKey: "alertYearly")
        } else {
            userDefaults.setBool(false, forKey: "alertYearly")
        }
    }
    
    func showContactsUnaccessibleAlert() {
        let title = "Contacts Unaccessible"
        let message = "Permission to access your address book is necessary before syncing contacts."
        UIAlertController.generate(self, title: title, message: message)
    }
    
    func rollToTheRight(forLabel labelSelected: CircleLabel) {
        self.settingsLabelIsActive = true
        toggleLabelInteractions(false)
        settingsLabelColor = labelSelected.backgroundColor
        labelSelected.rollRight(forDuration: 0.5, inView: view) { (labelSelected) -> () in
            self.rollRightCompletion(labelSelected)
        }
        toggleLabelInteractions(true)
    }
    
    func rollToTheLeft(forLabel labelSelected: CircleLabel) {
        toggleLabelInteractions(false)
        self.allTextLabels[labelSelected.index].hidden = true
        self.showOrHidSettingsInfo(forIndex: labelSelected.index, hide: true)
        labelSelected.rollLeft(forDuration: 0.5, toPosition: syncCancel.center.x) { (label, text) -> () in
            self.rollLeftCompletion(label, text: text)
        }
        toggleLabelInteractions(true)
        self.settingsLabelIsActive = false
    }
    
    func toggleLabelInteractions(enabled: Bool) {
        self.allSettingsLabels?.forEach({ $0.userInteractionEnabled = enabled })
        self.allCancelLabels?.forEach({ $0.userInteractionEnabled = enabled })
    }
    
    func rollRightCompletion(labelSelected: CircleLabel) {
        labelSelected.backgroundColor = UIColor.confirmColor()
        self.allTextLabels[labelSelected.index].hidden = false
        showOrHidSettingsInfo(forIndex: labelSelected.index, hide: false)
        if labelSelected == self.syncSetting {
            self.syncCancel.userInteractionEnabled = true
        }
    }
    
    func showOrHidSettingsInfo(forIndex index: Int, hide: Bool) {
        switch index {
        case 2:
            alertOnceButton.hidden = hide
            alertYearlyButton.hidden = hide
        default:
            break
        }
    }
    
    @IBAction func alertYearlySelected(sender: AnyObject) {
        alertYearlyButton.backgroundColor = UIColor.anniversaryColor()
        alertOnceButton.backgroundColor = UIColor.lightGrayColor()
    }
    
    @IBAction func alertOnceSelected(sender: AnyObject) {
        alertOnceButton.backgroundColor = UIColor.anniversaryColor()
        alertYearlyButton.backgroundColor = UIColor.lightGrayColor()
    }
    
    func rollLeftCompletion(labelSelected: CircleLabel, text: String) {
        self.delay(0.5) {
            labelSelected.backgroundColor = self.settingsLabelColor
            labelSelected.text = text
            self.toggleLabelInteractions(true)
        }
    }
    
    func cancelButtonPressed(sender: UITapGestureRecognizer) {
        guard let labelSelected = sender.view as? CircleLabel else { return }
        let settingsTextLabel = allTextLabels[labelSelected.index]
        settingsTextLabel.hidden = true
        self.showOrHidSettingsInfo(forIndex: labelSelected.index, hide: true)
        let settingsLabel = allSettingsLabels[labelSelected.index]
        settingsLabel.backgroundColor = settingsLabelColor
        settingsLabel.rotateBack360Degrees()
        
        UIView.animateWithDuration(0.5, animations: { _ in
            settingsLabel.center.x = self.syncCancel.center.x
            }) { _ in
                self.settingsLabelIsActive = false
                self.toggleLabelInteractions(true)
        }
    }
}
