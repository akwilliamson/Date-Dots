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
import Contacts

class InitialImportVC: UIViewController {
    
    // Passed through application(_:didFinishLaunchingWithOptions)
    var managedContext: NSManagedObjectContext!
    // Object to interact with contacts in address book
    var addressBook: ABAddressBook!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

// MARK: - Actions

    @IBAction func realImport(sender: AnyObject) {
        if #available(iOS 9.0, *) {
            // Rewrite new determineStatus() for iOS9
            if determineStatus() {
                return
            }
            iOS9AddBirthdays()
            iOS9AddAnniversaries()
            addEntitiesForHolidaysFromPlist()
            saveManagedContext()
            self.performSegueWithIdentifier("HomeScreen", sender: self)
        } else {
            if determineStatus() {
                return
            }
            getDatesFromContacts()
            addEntitiesForHolidaysFromPlist()
            saveManagedContext()
            self.performSegueWithIdentifier("HomeScreen", sender: self)
        }
    }
    
    func iOS9AddBirthdays() {
        if #available(iOS 9.0, *) {
            let contacts = CNContactStore()
            let birthdayKeys = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactBirthdayKey]
            let birthdayFetch = CNContactFetchRequest(keysToFetch: birthdayKeys)
            
            let formatString = NSDateFormatter.dateFormatFromTemplate("MM dd", options: 0, locale: NSLocale.currentLocale())
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = formatString
            
            try! contacts.enumerateContactsWithFetchRequest(birthdayFetch) { (contact: CNContact, error: UnsafeMutablePointer<ObjCBool>) -> Void in
                let fullName = "\(contact.givenName) \(contact.familyName)"
                let abbreviatedName = self.abbreviateName(fullName)
                if let contactBirthday = contact.birthday {
                    let birthday = NSCalendar.currentCalendar().dateFromComponents(contactBirthday)
                    let birthdayEntity = NSEntityDescription.entityForName("Date", inManagedObjectContext: self.managedContext)
                    let birthdayDate = Date(entity: birthdayEntity!, insertIntoManagedObjectContext: self.managedContext)
                    
                    birthdayDate.name = fullName
                    birthdayDate.abbreviatedName = abbreviatedName
                    birthdayDate.date = birthday!
                    birthdayDate.equalizedDate = dateFormatter.stringFromDate(birthday!)
                    birthdayDate.type = "birthday"
                }
            }
        }
    }
    
    func iOS9AddAnniversaries() {
        if #available(iOS 9.0, *) {
            let contacts = CNContactStore()
            let anniversaryKeys = [CNContactGivenNameKey,CNContactFamilyNameKey,CNLabelDateAnniversary]
            let anniversaryFetch = CNContactFetchRequest(keysToFetch: anniversaryKeys)
            
            let formatString = NSDateFormatter.dateFormatFromTemplate("MM dd", options: 0, locale: NSLocale.currentLocale())
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = formatString
            
            try! contacts.enumerateContactsWithFetchRequest(anniversaryFetch) { (contact: CNContact, error: UnsafeMutablePointer<ObjCBool>) -> Void in
                for date in contact.dates {
                    if date.label == CNLabelDateAnniversary {
                        let anniversaryValue = date.value as! NSDateComponents
                        let anniversary = NSCalendar.currentCalendar().dateFromComponents(anniversaryValue)
                        let anniversaryEntity = NSEntityDescription.entityForName("Date", inManagedObjectContext: self.managedContext)
                        let anniversaryDate = Date(entity: anniversaryEntity!, insertIntoManagedObjectContext: self.managedContext)
                        
                        anniversaryDate.name = "\(contact.givenName) \(contact.familyName)"
                        anniversaryDate.abbreviatedName = self.abbreviateName(anniversaryDate.name)
                        anniversaryDate.date = anniversary!
                        anniversaryDate.equalizedDate = dateFormatter.stringFromDate(anniversary!)
                        anniversaryDate.type = "birthday"
                    }
                }
            }
        }
    }
    
    @IBAction func syncContacts(sender: AnyObject) {
        getDatesFromContacts()
        addEntitiesForHolidaysFromPlist()
        saveManagedContext()
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
                    print("Not granted access to user's addressbook")
                }
            }
            return userDidAuthorize == true ? true : false
        case .Restricted:
            print("Not authorized to access user's addressbook")
            return false
        case .Denied:
            print("Denied access user's addressbook")
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
            
            birthday.name = ABRecordCopyCompositeName(person).takeUnretainedValue() as String
            birthday.abbreviatedName = abbreviateName(birthday.name)
            let actualDate = birthdayProperty.takeUnretainedValue() as! NSDate
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
            let anniversaryLabel = (ABMultiValueCopyLabelAtIndex(anniversaryDate, index)).takeRetainedValue() as String
            let otherLabel = kABPersonAnniversaryLabel as String
            
            if anniversaryLabel == otherLabel {
                
                let anniversaryEntity = NSEntityDescription.entityForName("Date", inManagedObjectContext: managedContext)
                let anniversary = Date(entity: anniversaryEntity!, insertIntoManagedObjectContext: managedContext)
                
                anniversary.name = ABRecordCopyCompositeName(person).takeUnretainedValue() as String
                anniversary.abbreviatedName = abbreviateName(anniversary.name)
                let actualDate = ABMultiValueCopyValueAtIndex(anniversaryDate, index).takeUnretainedValue() as! NSDate
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
        do {
            try managedContext.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save: \(error?.localizedDescription)")
        }
    }
    
    func addEntitiesForHolidaysFromPlist() {
        if let path = NSBundle.mainBundle().pathForResource("Holidays", ofType: "plist") {
            let holidaysDictionary = NSDictionary(contentsOfFile: path)!
            for (holidayName, holidayDate) in holidaysDictionary {
                let holidayEntity = NSEntityDescription.entityForName("Date", inManagedObjectContext: managedContext)
                let holiday = Date(entity: holidayEntity!, insertIntoManagedObjectContext: managedContext)
                holiday.name = holidayName as! String
                holiday.abbreviatedName = holidayName as! String
                let actualDate = holidayDate as! NSDate
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

















