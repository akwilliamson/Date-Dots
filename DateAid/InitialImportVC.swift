//
//  ViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/7/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData
import AddressBook
import AddressBookUI

class InitialImportVC: UIViewController {
    
    // Initialized through application(_:didFinishLaunchingWithOptions)
    var managedContext: NSManagedObjectContext!
    // object to interact with iOS contacts
    var addressBook: ABAddressBook!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getDatesFromContacts() {
        if !self.determineStatus() {
            println("determineStatus() returns false. Exiting getContactNames()")
            return
        }
        let people = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray as [ABRecord]
        for person in people {
            
            var anniversaries: ABMultiValueRef = ABRecordCopyValue(person, kABPersonDateProperty).takeUnretainedValue() as ABMultiValueRef
            var anniversaryLabel: String
            
            var stuff: ABMultiValueRef
            stuff = anniversaries
            var i = 0
            for (i = 0; i < ABMultiValueGetCount(anniversaries); i++) {
                anniversaryLabel = (ABMultiValueCopyLabelAtIndex(anniversaries, i)).takeRetainedValue() as! String
                
                let otherLabel = kABPersonAnniversaryLabel as! String
                if anniversaryLabel == otherLabel {
                    println("Anniversary for:")
                    println(ABRecordCopyCompositeName(person).takeUnretainedValue() as! String)
                    println((ABMultiValueCopyValueAtIndex(anniversaries, i)).takeUnretainedValue() as! NSDate)
                }
            }
            
            
            let birthday = ABRecordCopyValue(person, kABPersonBirthdayProperty)
            if birthday != nil {
                let name = ABRecordCopyCompositeName(person)
                let dateForDateEntity = birthday.takeUnretainedValue() as! NSDate
                let nameForDateEntity = name.takeUnretainedValue() as! String
                
                let dateEntity = NSEntityDescription.entityForName("Date", inManagedObjectContext: managedContext)
                let date = Date(entity: dateEntity!, insertIntoManagedObjectContext: managedContext)
                date.name = nameForDateEntity
                date.date = dateForDateEntity
                date.type = "birthday"
                
                var error: NSError?
                if !managedContext.save(&error) {
                    println("Could not save: \(error)")
                }
            }
        }
    }
    
    func addDateToCoreData(type: String, date: NSDate, name: String) {
    
    }
    
    func determineStatus() -> Bool {
        let status = ABAddressBookGetAuthorizationStatus()
        switch status {
        case .Authorized:
            return self.createAddressBook()
        case .NotDetermined:
            var ok = false
            ABAddressBookRequestAccessWithCompletion(nil) {
                (granted:Bool, err:CFError!) in
                dispatch_async(dispatch_get_main_queue()) {
                    if granted {
                        ok = self.createAddressBook()
                    }
                }
            }
            if ok == true {
                return true
            }
            self.addressBook = nil
            return false
        case .Restricted:
            self.addressBook = nil
            return false
        case .Denied:
            self.addressBook = nil
            return false
        }
    }
    
    func createAddressBook() -> Bool {
        if self.addressBook != nil {
            return true
        }
        var err: Unmanaged<CFError>? = nil
        let adbk: ABAddressBook? = ABAddressBookCreateWithOptions(nil, &err).takeRetainedValue()
        if adbk == nil {
            self.addressBook = nil
            return false
        }
        self.addressBook = adbk
        return true
    }
    
    @IBAction func syncContacts(sender: AnyObject) {
        getDatesFromContacts()
        self.performSegueWithIdentifier("HomeScreen", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let tabBarVC = segue.destinationViewController as! UITabBarController
//        let revealVC = tabBarVC.childViewControllers[0] as! SW
//        let destinationVC = revealVC.
//        destinationVC.datesDictionary = datesDictionary
    }
}

















