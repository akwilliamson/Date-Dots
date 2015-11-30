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
    var labelForSetting: [CircleLabel: UILabel]!
    var reloadDatesTableDelegate: ReloadDatesTableDelegate?
    
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
    
    @IBOutlet var allCircleLabels: Array<CircleLabel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logEvents(forString: "Settings")
        addGestureRecognizers()
        reloadDatesTableDelegate = tabBarController?.viewControllers?[0].childViewControllers[1].childViewControllers[0] as? DatesTableVC
        labelForSetting = [syncSetting: syncLabel, iCloudSetting: iCloudLabel, alertSetting: alertsLabel, colorSetting: colorsLabel]
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        toggleCancelLabels(shouldBeHidden: true)
        animateSettingsLabelsIntoView()
        delay(1) { self.toggleCancelLabels(shouldBeHidden: false) }
    }
    
    func addGestureRecognizers() {
        [syncSetting, iCloudSetting, alertSetting, colorSetting].forEach({
            $0.addTapGestureRecognizer(forAction: "slideRightOrLeft:")
        })
        syncCancel.addTapGestureRecognizer(forAction: "terminateAnimation:")
    }
    
    func animateSettingsLabelsIntoView() {
        syncSetting.animate(intoView: view, toPosition: syncCancel.center.x, withDelay: 0)
        iCloudSetting.animate(intoView: view, toPosition: iCloudCancel.center.x, withDelay: 0.03)
        alertSetting.animate(intoView: view, toPosition: alertCancel.center.x, withDelay: 0.06)
        colorSetting.animate(intoView: view, toPosition: colorCancel.center.x, withDelay: 0.09)
    }
    
    func toggleCancelLabels(shouldBeHidden hidden: Bool) {
        [syncCancel, iCloudCancel, alertCancel, colorCancel].forEach({ $0.hidden = hidden })
    }
    
    func disableLabelInteractions() {
        allCircleLabels?.forEach({ $0.userInteractionEnabled = false })
    }
    
    func slideRightOrLeft(sender: UITapGestureRecognizer) {
        guard let labelSelected = sender.view as? CircleLabel else { return }
        if settingsLabelIsActive == false {
            disableLabelInteractions()
            labelSelected.rotate360Degrees()
            labelSelected.slideRight(forDuration: 0.5, inView: view, closure: animateRightCompletion(labelSelected))
            labelSelected.userInteractionEnabled = true
        } else {
            if labelSelected == syncSetting {
                let status = ABAddressBookGetAuthorizationStatus()
                contactImporter.syncContacts(status: status)
                if status == .Authorized {
                    reloadDatesTableDelegate?.reloadTableView()
                } else {
                    self.showContactsUnaccessibleAlert()
                }
            }
            labelSelected.userInteractionEnabled = false
            labelSelected.rotateBack360Degrees()
            slideLeft(labelSelected)
            labelSelected.userInteractionEnabled = true
        }
    }
    
    func showContactsUnaccessibleAlert() {
        let title = "Contacts Unaccessible"
        let message = "Permission to access your address book is necessary before syncing contacts."
        UIAlertController.generate(self, title: title, message: message)
    }
    
    func animateRightCompletion(label: CircleLabel) {
        label.backgroundColor = UIColor.confirmColor()
        self.labelForSetting[label]?.hidden = false
        settingsLabelIsActive = true
        if label == self.syncSetting {
            self.syncCancel.userInteractionEnabled = true
        }
    }
    
    func slideLeft(label: CircleLabel) {
        let text = label.text!
        labelForSetting[label]?.hidden = true
        UIView.animateWithDuration(0.5, animations: { _ in
            label.center.x = self.syncCancel.center.x
            label.text = "✓"
            }) { _ in
                self.settingsLabelIsActive = false
                self.delay(0.5) {
                    label.text = text
                    label.backgroundColor = UIColor.lightGrayColor()
                    self.allCircleLabels.forEach({ $0.userInteractionEnabled = true })
                }
        }
    }
    
    func terminateAnimation(sender: UITapGestureRecognizer) {
        syncLabel.hidden = true
        syncSetting.backgroundColor = UIColor.lightGrayColor()
        syncSetting.rotateBack360Degrees()
        UIView.animateWithDuration(0.5, animations: { _ in
            self.syncSetting.center.x = self.syncCancel.center.x
            }) { _ in
                self.settingsLabelIsActive = false
                self.allCircleLabels.forEach({ $0.userInteractionEnabled = true })
        }
    }
    
}
