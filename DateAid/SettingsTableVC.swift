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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logEvents(forString: "Settings")
        addGestureRecognizers()
        setIndicesForLabels()
        reloadDatesTableDelegate = tabBarController?.viewControllers?[0].childViewControllers[1].childViewControllers[0] as? DatesTableVC
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        toggleCancelLabels(shouldBeHidden: true)
        animateSettingsLabelsIntoView()
        delay(1) { self.toggleCancelLabels(shouldBeHidden: false) }
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
        // 3 more cases in here eventually
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
    
    func showContactsUnaccessibleAlert() {
        let title = "Contacts Unaccessible"
        let message = "Permission to access your address book is necessary before syncing contacts."
        UIAlertController.generate(self, title: title, message: message)
    }
    
    func rollToTheRight(forLabel labelSelected: CircleLabel) {
        self.settingsLabelIsActive = true
        toggleLabelInteractions(false)
        settingsLabelColor = labelSelected.backgroundColor
        labelSelected.rollRight(forDuration: 0.5, inView: view, closure: rollRightCompletion(labelSelected))
        toggleLabelInteractions(true)
    }
    
    func rollToTheLeft(forLabel labelSelected: CircleLabel) {
        toggleLabelInteractions(false)
        self.allTextLabels[labelSelected.index].hidden = true
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
        if labelSelected == self.syncSetting {
            self.syncCancel.userInteractionEnabled = true
        }
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
