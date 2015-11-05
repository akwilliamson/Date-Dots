//
//  ViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/7/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit

class InitialImportVC: UIViewController {
    
    lazy var contactImporter: ContactImporter = {
        return ContactImporter()
    }()
    
    @IBOutlet weak var importButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonStyles()
    }
    
    override func viewWillAppear(animated: Bool) {
        [importButton, skipButton].forEach({ $0.transform = CGAffineTransformScale($0.transform, 0, 0) })
        zoomInButton(importButton, withDelay: 0)
        zoomInButton(skipButton, withDelay: 0.2)
    }
    
    func setButtonStyles() {
        [importButton, skipButton].forEach({ $0.titleLabel?.textAlignment = .Center })
        importButton.layer.cornerRadius = 85
        skipButton.layer.cornerRadius = 60
    }
    
    func zoomInButton(button: UIButton, withDelay delay: NSTimeInterval) {
        UIView.animateWithDuration(0.4, delay: delay, options: [], animations: { () -> Void in
            button.transform = CGAffineTransformMakeScale(1.2, 1.2)
            }) { finish in
                UIView.animateWithDuration(0.3) {
                    button.transform = CGAffineTransformMakeScale(1, 1)
                }
        }
    }
    
    @IBAction func syncContacts(sender: AnyObject) {
        contactImporter.syncContacts()
        self.performSegueWithIdentifier("HomeScreen", sender: self)
    }
}
