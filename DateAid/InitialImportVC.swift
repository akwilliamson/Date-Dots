//
//  ViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/7/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData
import Contacts

class InitialImportVC: UIViewController {
    
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addActivityView()
    }
    
    private func addActivityView() {
        activityView.transform = CGAffineTransform(scaleX: 2, y: 2)
        activityView.center = view.center
        activityView.isHidden = true
        view.addSubview(activityView)
    }
    
// MARK: - Actions
    
    @IBAction func syncContacts(_ sender: AnyObject) {
        activityView.startAnimating()
        
        ContactManager.syncContacts { 
            self.activityView.stopAnimating()
            self.performSegue(withIdentifier: "ShowHome", sender: self)
        }
    }
    
    @IBAction func skipImportPressed(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "ShowHome", sender: self)
    }
    
}
