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
    
    var presenter: InitialImportEventHandling?
    
// MARK: - Actions
    
    @IBAction func syncContacts(_ sender: AnyObject) {
        presenter?.syncContactsPressed(in: view.window)
    }
    
    @IBAction func skipImportPressed(_ sender: AnyObject) {
        presenter?.showTabBar(in: view.window)
    }
}

extension InitialImportViewController: InitialImportViewOutputting {}
