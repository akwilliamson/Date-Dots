//
//  SettingsTableVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 11/2/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit

class SettingsTableVC: UIViewController {
    
    var slidAway = false
    var originalCenterX: CGFloat?
    
    lazy var contactImporter: ContactImporter = {
        return ContactImporter()
    }()
    
    @IBOutlet weak var syncSetting: CircleLabel!
    @IBOutlet weak var iCloudSetting: CircleLabel!
    @IBOutlet weak var alertSetting: CircleLabel!
    @IBOutlet weak var colorSetting: CircleLabel!
    
    @IBOutlet weak var syncLabel: UILabel!
    @IBOutlet weak var iCloudLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalCenterX = syncSetting.center.x
        configureNavigationBar()
        [syncSetting, iCloudSetting, alertSetting, colorSetting].forEach({
            let slideGesture = UITapGestureRecognizer(target: self, action: Selector("slideAway:"))
            slideGesture.numberOfTapsRequired = 1
            $0.userInteractionEnabled = true
            $0.addGestureRecognizer(slideGesture)
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        animateLabelIntoView(syncSetting, delay: 0)
        animateLabelIntoView(iCloudSetting, delay: 0.03)
        animateLabelIntoView(alertSetting, delay: 0.06)
        animateLabelIntoView(colorSetting, delay: 0.09)
    }
    
    func configureNavigationBar() {
        if let navBar = navigationController?.navigationBar {
            navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "AvenirNext-Bold", size: 23)!]
            navBar.barTintColor = UIColor.birthdayColor()
            navBar.tintColor = UIColor.whiteColor()
        }
    }
    
    func showProperLabel(forView view: UIView) {
        switch view {
        case syncSetting:
            syncLabel.hidden = false
        case iCloudSetting:
            iCloudLabel.hidden = false
        default:
            return
        }
    }
    
    func hideProperLabel(forView view: UIView) {
        switch view {
        case syncSetting:
            syncLabel.hidden = true
        case iCloudSetting:
            iCloudLabel.hidden = true
        default:
            return
        }
    }
    
    func slideAway(sender: UITapGestureRecognizer) {
        if slidAway == false {
            sender.view?.rotate360Degrees()
            UIView.animateWithDuration(0.5, animations: { _ in
                sender.view?.center.x = self.view.frame.width - self.originalCenterX! - (sender.view?.frame.width)!
                }) { _ in
                self.showProperLabel(forView: sender.view!)
                self.slidAway = true
            }
        } else {
            if sender.view! == syncSetting {
                contactImporter.syncContacts()
            }
            sender.view?.rotateBack360Degrees()
            hideProperLabel(forView: sender.view!)
            UIView.animateWithDuration(0.5, animations: { _ in
                sender.view?.center.x = self.originalCenterX! + (sender.view?.frame.width)!
                }) { _ in
                self.slidAway = false
            }
        }
    }
    
    func animateLabelIntoView(label: CircleLabel, delay: NSTimeInterval) {
        label.center.x = -200
        UIView.animateWithDuration(0.4, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [], animations: { () -> Void in
            label.center.x = self.originalCenterX! + label.frame.width
        }, completion: nil)
    }
    
}
