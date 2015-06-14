//
//  ViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/7/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

/**

TO DO: Add another property to Date entity that includes the user's abbreviated name for quick 
       access and display in DatesTableVC's tableview rows. Ex: Aaron Williamson -> Aaron W.

**/

import UIKit
import CoreData
import AddressBook
import AddressBookUI

class InitialImportVC: UIViewController {
    
    // Passed through application(_:didFinishLaunchingWithOptions)
    var managedContext: NSManagedObjectContext!
    // Object to interact with contacts in address book
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
            
            let anniversaries: ABMultiValueRef = ABRecordCopyValue(person, kABPersonDateProperty).takeUnretainedValue() as ABMultiValueRef
            var anniversaryLabel: String
            let stuff: ABMultiValueRef
            stuff = anniversaries
            var i = 0
            for (i = 0; i < ABMultiValueGetCount(anniversaries); i++) {
                anniversaryLabel = (ABMultiValueCopyLabelAtIndex(anniversaries, i)).takeRetainedValue() as! String
                
                let otherLabel = kABPersonAnniversaryLabel as! String
                if anniversaryLabel == otherLabel {
                    
                    let anniversaryEntity = NSEntityDescription.entityForName("Date", inManagedObjectContext: managedContext)
                    let anniversary = Date(entity: anniversaryEntity!, insertIntoManagedObjectContext: managedContext)
      
                    anniversary.name = ABRecordCopyCompositeName(person).takeUnretainedValue() as! String
                    anniversary.abbreviatedName = abbreviateName(anniversary.name)
                    anniversary.date = ABMultiValueCopyValueAtIndex(anniversaries, i).takeUnretainedValue() as! NSDate
                    anniversary.type = "anniversary"
                    
                    var error: NSError?
                    if !managedContext.save(&error) {
                        println("Could not save: \(error)")
                    }
                }
            }
            
            let birthdayProperty = ABRecordCopyValue(person, kABPersonBirthdayProperty)
            if birthdayProperty != nil {
                
                let birthdayEntity = NSEntityDescription.entityForName("Date", inManagedObjectContext: managedContext)
                let birthday = Date(entity: birthdayEntity!, insertIntoManagedObjectContext: managedContext)
                
                birthday.name = ABRecordCopyCompositeName(person).takeUnretainedValue() as! String
                birthday.abbreviatedName = abbreviateName(birthday.name)
                birthday.date = birthdayProperty.takeUnretainedValue() as! NSDate
                birthday.type = "birthday"
                
                var error: NSError?
                if !managedContext.save(&error) {
                    println("Could not save: \(error)")
                }
            }
        }
    }
    
    func abbreviateName(fullName: String) -> String {
        let castString = fullName as NSString
        let convertedRange: Range<String.Index>
        let endIndex = castString.rangeOfString(" ", options: .BackwardsSearch).location
        if endIndex < 100 {
            convertedRange = fullName.convertRange(0..<endIndex)
        } else {
            convertedRange = fullName.convertRange(0..<castString.length-2)
        }
        
        return fullName.substringWithRange(convertedRange)
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
}

















