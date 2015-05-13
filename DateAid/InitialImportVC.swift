//
//  ViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/7/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit

class InitialImportVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var userHasSeenInitialVIew = NSUserDefaults.standardUserDefaults().valueForKey("seenInitialView") as? Bool
        if userHasSeenInitialVIew == !true {
            return
        } else if userHasSeenInitialVIew! == true {
            self.performSegueWithIdentifier("HomeScreen", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "seenInitialView")
    }
    
}

