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
    
    // Passed through application(_:didFinishLaunchingWithOptions)
    var managedContext: NSManagedObjectContext!
    // Object to interact with contacts in address book
    var addressBook: ABAddressBook!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

// MARK: - Actions
    
    @IBAction func syncContacts(sender: AnyObject) {
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityView.transform = CGAffineTransformMakeScale(2, 2)
        activityView.center = self.view.center
        activityView.startAnimating()
        self.view.addSubview(activityView)
        getDatesFromContacts()
        addEntitiesForHolidaysFromPlist()
        saveManagedContext()
        activityView.stopAnimating()
        self.performSegueWithIdentifier("HomeScreen", sender: self)
    }
    // The main method to extract and save all initial dates
    func getDatesFromContacts() {
        if !determineStatus() {
            return
        }
        let people = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray as [ABRecord]
        for person in people {
            // Add Date entities for address book birthdays
            addEntitiesForAddressBookBirthdays(person)
            // Add Date entities for address book anniversaries
            addEntitiesForAddressBookAnniversaries(person)
        }
    }
    /* Passes user's address book to getDatesFromContacts() and allows said function
    to continue, or returns no address book and forces getDatesFromContacts to exit. */
    func determineStatus() -> Bool {
        switch ABAddressBookGetAuthorizationStatus() {
        case .Authorized:
            return self.createAddressBook()
        case .NotDetermined:
            var userDidAuthorize = false
            ABAddressBookRequestAccessWithCompletion(nil) { (granted: Bool, error: CFError!) in
                if granted {
                    userDidAuthorize = self.createAddressBook()
                } else {
                    println("Not granted access to user's addressbook")
                }
            }
            return userDidAuthorize == true ? true : false
        case .Restricted:
            println("Not authorized to access user's addressbook")
            return false
        case .Denied:
            println("Denied access user's addressbook")
            return false
        }
    }
    // Helper method for determineStatus that extracts and initializes the actual address book
    func createAddressBook() -> Bool {
        if self.addressBook != nil {
            return true
        }
        var error: Unmanaged<CFError>? = nil
        let newAddressBook: ABAddressBook? = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()
        if newAddressBook == nil {
            return false
        } else {
            self.addressBook = newAddressBook
            return true
        }
    }

    func addEntitiesForAddressBookBirthdays(person: AnyObject) {
        let birthdayProperty = ABRecordCopyValue(person, kABPersonBirthdayProperty)
        if birthdayProperty != nil {
            
            let birthdayEntity = NSEntityDescription.entityForName("Date", inManagedObjectContext: managedContext)
            let birthday = Date(entity: birthdayEntity!, insertIntoManagedObjectContext: managedContext)
            
            birthday.name = ABRecordCopyCompositeName(person).takeUnretainedValue() as! String
            birthday.abbreviatedName = abbreviateName(birthday.name)
            var actualDate = birthdayProperty.takeUnretainedValue() as! NSDate
            birthday.date = actualDate
            let formatString = NSDateFormatter.dateFormatFromTemplate("MM dd", options: 0, locale: NSLocale.currentLocale())
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = formatString
            birthday.equalizedDate = dateFormatter.stringFromDate(actualDate)
            birthday.type = "birthday"
        }
    }
    
    func addEntitiesForAddressBookAnniversaries(person: AnyObject) {
        let anniversaryDate: ABMultiValueRef = ABRecordCopyValue(person, kABPersonDateProperty).takeUnretainedValue()
        for index in 0..<ABMultiValueGetCount(anniversaryDate) {
            let anniversaryLabel = (ABMultiValueCopyLabelAtIndex(anniversaryDate, index)).takeRetainedValue() as! String
            let otherLabel = kABPersonAnniversaryLabel as! String
            
            if anniversaryLabel == otherLabel {
                
                let anniversaryEntity = NSEntityDescription.entityForName("Date", inManagedObjectContext: managedContext)
                let anniversary = Date(entity: anniversaryEntity!, insertIntoManagedObjectContext: managedContext)
                
                anniversary.name = ABRecordCopyCompositeName(person).takeUnretainedValue() as! String
                anniversary.abbreviatedName = abbreviateName(anniversary.name)
                var actualDate = ABMultiValueCopyValueAtIndex(anniversaryDate, index).takeUnretainedValue() as! NSDate
                anniversary.date = actualDate
                let formatString = NSDateFormatter.dateFormatFromTemplate("MM dd", options: 0, locale: NSLocale.currentLocale())
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = formatString
                anniversary.equalizedDate = dateFormatter.stringFromDate(actualDate)
                anniversary.type = "anniversary"
            }
        }
    }
    
    func saveManagedContext() {
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save: \(error?.localizedDescription)")
        }
    }
    
    func addEntitiesForHolidaysFromPlist() {
        if let path = NSBundle.mainBundle().pathForResource("Holidays", ofType: "plist") {
            var holidaysDictionary = NSDictionary(contentsOfFile: path)!
            for (holidayName, holidayDate) in holidaysDictionary {
                let holidayEntity = NSEntityDescription.entityForName("Date", inManagedObjectContext: managedContext)
                let holiday = Date(entity: holidayEntity!, insertIntoManagedObjectContext: managedContext)
                holiday.name = holidayName as! String
                holiday.abbreviatedName = holidayName as! String
                var actualDate = holidayDate as! NSDate
                holiday.date = actualDate
                let formatString = NSDateFormatter.dateFormatFromTemplate("MM dd", options: 0, locale: NSLocale.currentLocale())
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = formatString
                holiday.equalizedDate = dateFormatter.stringFromDate(actualDate)
                holiday.type = "holiday"
            }
        }
    }
    // Abbreviates an address book name. Ex: Aaron Williamson -> Aaron W.
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
}

















