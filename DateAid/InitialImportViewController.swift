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

class InitialImportViewController: UIViewController {
    
    var viewPresenter = InitialImportPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addActivityView()
    }
    
    private func addActivityView() {
        viewPresenter.activityIndicator.center = view.center
        view.addSubview(viewPresenter.activityIndicator)
    }
    
// MARK: - Actions
    
    @IBAction func syncContacts(_ sender: AnyObject) {
        viewPresenter.activityIndicator.startAnimating()
        
        ContactManager.syncContacts { 
            self.viewPresenter.activityIndicator.startAnimating()
            self.performSegue(withIdentifier: "ShowHome", sender: self)
        }
    }
    
    @IBAction func skipImportPressed(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "ShowHome", sender: self)
    }
    
}
