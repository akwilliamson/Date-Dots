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
    var labelForSetting: [CircleLabel: UILabel]!
    
    lazy var contactImporter: ContactImporter = {
        return ContactImporter()
    }()
    
    @IBOutlet weak var syncSetting: CircleLabel!
    @IBOutlet weak var syncNo: CircleLabel!
    @IBOutlet weak var iCloudSetting: CircleLabel!
    @IBOutlet weak var alertSetting: CircleLabel!
    @IBOutlet weak var colorSetting: CircleLabel!
    
    @IBOutlet weak var syncLabel: UILabel!
    @IBOutlet weak var iCloudLabel: UILabel!
    
    @IBOutlet weak var marginToViewEdge: NSLayoutConstraint!
    
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
        let slideGesture = UITapGestureRecognizer(target: self, action: Selector("terminateAnimation:"))
        slideGesture.numberOfTapsRequired = 1
        syncNo.userInteractionEnabled = true
        syncNo.addGestureRecognizer(slideGesture)
        labelForSetting = [syncSetting: syncLabel, iCloudSetting: iCloudLabel]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        animateLabelIntoView(syncSetting, delay: 0, cancelLabel: syncNo)
        animateLabelIntoView(iCloudSetting, delay: 0.03, cancelLabel: nil)
        animateLabelIntoView(alertSetting, delay: 0.06, cancelLabel: nil)
        animateLabelIntoView(colorSetting, delay: 0.09, cancelLabel: nil)
    }
    
    func configureNavigationBar() {
        if let navBar = navigationController?.navigationBar {
            navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "AvenirNext-Bold", size: 23)!]
            navBar.barTintColor = UIColor.birthdayColor()
            navBar.tintColor = UIColor.whiteColor()
        }
    }
    
    func slideAway(sender: UITapGestureRecognizer) {
        if slidAway == false {
            sender.view!.userInteractionEnabled = false
            sender.view!.rotate360Degrees()
            animateAway(sender.view as! CircleLabel)
            sender.view!.userInteractionEnabled = true
        } else {
            if sender.view! == syncSetting {
                contactImporter.syncContacts()
            }
            sender.view!.userInteractionEnabled = false
            sender.view?.rotateBack360Degrees()
            animateBack(sender.view as! CircleLabel)
            sender.view!.userInteractionEnabled = true
        }
    }
    
    func terminateAnimation(sender: UITapGestureRecognizer) {
        syncLabel.hidden = true
        syncSetting.backgroundColor = UIColor.lightGrayColor()
        syncSetting.rotateBack360Degrees()
        UIView.animateWithDuration(0.5, animations: { _ in
            self.syncSetting.center.x = self.syncNo.center.x
            }) { _ in
                self.slidAway = false
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func animateAway(view: CircleLabel) {
        syncNo.userInteractionEnabled = false
        view.backgroundColor = UIColor.confirmColor()
        UIView.animateWithDuration(0.5, animations: { _ in
            view.center.x = self.view.frame.width - (view.center.x)
            }) { _ in
                self.labelForSetting[view]?.hidden = false
                self.slidAway = true
                self.syncNo.userInteractionEnabled = true
        }
    }
    
    func animateBack(view: CircleLabel) {
        let text = view.text!
        labelForSetting[view]?.hidden = true
        UIView.animateWithDuration(0.5, animations: { _ in
            view.center.x = self.syncNo.center.x
            view.text = "✓"
            }) { _ in
                self.slidAway = false
                self.delay(0.5) {
                    view.text = text
                    view.backgroundColor = UIColor.lightGrayColor()
                }
        }
    }
    
    func animateLabelIntoView(label: CircleLabel, delay: NSTimeInterval, cancelLabel: CircleLabel?) {
        cancelLabel?.hidden = true
        label.center.x = -self.view.frame.width - label.frame.height
        UIView.animateWithDuration(0.4, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [], animations: { () -> Void in
            label.center.x = self.syncNo.center.x
            }) { _ in
                cancelLabel?.hidden = false
        }
    }
    
}
