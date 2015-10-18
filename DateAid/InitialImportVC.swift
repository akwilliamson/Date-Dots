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
//import Contacts

class InitialImportVC: UIViewController {
    
// MARK: PROPERTIES
    
    var managedContext: NSManagedObjectContext?
    var addressBook: ABAddressBook!
    
// MARK: OUTLETS
    
    @IBOutlet weak var importButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonStyles()
    }
    
    override func viewWillAppear(animated: Bool) {
        importButton.transform = CGAffineTransformScale(importButton.transform, 0, 0);
        skipButton.transform = CGAffineTransformScale(skipButton.transform, 0, 0);
        
        UIView.animateWithDuration(0.4, animations: {
            self.importButton.transform = CGAffineTransformMakeScale(1.2, 1.2)
        }, completion: { finish in
            UIView.animateWithDuration(0.3) {
                self.importButton.transform = CGAffineTransformMakeScale(1, 1)
            }
        })
        
        UIView.animateWithDuration(0.4, delay: 0.2, options: [], animations: { () -> Void in
            self.skipButton.transform = CGAffineTransformMakeScale(1.2, 1.2)
            }) { finish in
                UIView.animateWithDuration(0.3) {
                    self.skipButton.transform = CGAffineTransformMakeScale(1, 1)
                }
            }
    }

// MARK: ACTIONS
    
    @IBAction func syncContacts(sender: AnyObject) {
        getDatesFromContacts()
        addEntitiesForHolidaysFromPlist()
        saveManagedContext()
        self.performSegueWithIdentifier("HomeScreen", sender: self)
    }
    
// MARK: HELPERS
    
    // The main method to extract and save all initial dates
    func getDatesFromContacts() {
        if !determineStatus() { return }
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
            let actualDate = birthdayProperty.takeUnretainedValue() as! NSDate
            
            let birthdayEntity = NSEntityDescription.entityForName("Date", inManagedObjectContext: managedContext!)
            let birthday = Date(entity: birthdayEntity!, insertIntoManagedObjectContext: managedContext)
            
            birthday.name = ABRecordCopyCompositeName(person).takeUnretainedValue() as String
            birthday.abbreviatedName = birthday.name!.abbreviateName()
            birthday.date = actualDate
            birthday.equalizedDate = actualDate.formatCurrentDateIntoString()
            birthday.type = "birthday"
        }
    }
    
    func addEntitiesForAddressBookAnniversaries(person: AnyObject) {
        let anniversaryDate: ABMultiValueRef = ABRecordCopyValue(person, kABPersonDateProperty).takeUnretainedValue()
        for index in 0..<ABMultiValueGetCount(anniversaryDate) {
            let anniversaryLabel = (ABMultiValueCopyLabelAtIndex(anniversaryDate, index)).takeRetainedValue() as String
            let otherLabel = kABPersonAnniversaryLabel as String
            
            if anniversaryLabel == otherLabel {
                let actualDate = ABMultiValueCopyValueAtIndex(anniversaryDate, index).takeUnretainedValue() as! NSDate
                
                let anniversaryEntity = NSEntityDescription.entityForName("Date", inManagedObjectContext: managedContext!)
                let anniversary = Date(entity: anniversaryEntity!, insertIntoManagedObjectContext: managedContext)
                
                anniversary.name = ABRecordCopyCompositeName(person).takeUnretainedValue() as String
                anniversary.abbreviatedName = anniversary.name!.abbreviateName()
                anniversary.date = actualDate
                anniversary.equalizedDate = actualDate.formatCurrentDateIntoString()
                anniversary.type = "anniversary"
            }
        }
    }
    
    func saveManagedContext() {
        do { try managedContext!.save()
        } catch let fetchError as NSError {
            print(fetchError.localizedDescription)
        }
    }
    
    func addEntitiesForHolidaysFromPlist() {
        if let path = NSBundle.mainBundle().pathForResource("Holidays", ofType: "plist") {
            let holidaysDictionary = NSDictionary(contentsOfFile: path)!
            for (holidayName, holidayDate) in holidaysDictionary {
                let actualDate = holidayDate as! NSDate
                
                let holidayEntity = NSEntityDescription.entityForName("Date", inManagedObjectContext: managedContext!)
                let holiday = Date(entity: holidayEntity!, insertIntoManagedObjectContext: managedContext)
                
                holiday.name = holidayName as? String
                holiday.abbreviatedName = holidayName as? String
                holiday.date = actualDate
                holiday.equalizedDate = actualDate.formatCurrentDateIntoString()
                holiday.type = "holiday"
            }
        }
    }
    
    func setButtonStyles() {
        importButton.titleLabel?.textAlignment = .Center
        importButton.layer.cornerRadius = 75
        skipButton.titleLabel?.textAlignment = .Center
        skipButton.layer.cornerRadius = 50
    }
    
}

//    func iOS9AddBirthdays() {
//        let contacts = CNContactStore()
//        let birthdayKeys = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactBirthdayKey]
//        let birthdayFetch = CNContactFetchRequest(keysToFetch: birthdayKeys)
//
//        let formatString = NSDateFormatter.dateFormatFromTemplate("MM dd", options: 0, locale: NSLocale.currentLocale())
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = formatString
//
//        contacts.enumerateContactsWithFetchRequest(birthdayFetch) { (contact: CNContact, error: UnsafeMutablePointer<ObjCBool>) -> Void in
//            let fullName = "\(contact.givenName) \(contact.familyName)"
//            let abbreviatedName = self.abbreviateName(fullName)
//            if let contactBirthday = contact.birthday {
//                let birthday = NSCalendar.currentCalendar().dateFromComponents(contactBirthday)
//                let birthdayEntity = NSEntityDescription.entityForName("Date", inManagedObjectContext: self.managedContext)
//                let birthdayDate = Date(entity: birthdayEntity!, insertIntoManagedObjectContext: self.managedContext)
//
//                birthdayDate.name = fullName
//                birthdayDate.abbreviatedName = abbreviatedName
//                birthdayDate.date = birthday!
//                birthdayDate.equalizedDate = dateFormatter.stringFromDate(birthday!)
//                birthdayDate.type = "birthday"
//            }
//        }
//    }
//
//    func iOS9AddAnniversaries() {
//        let contacts = CNContactStore()
//        let anniversaryKeys = [CNContactGivenNameKey,CNContactFamilyNameKey,CNLabelDateAnniversary]
//        let anniversaryFetch = CNContactFetchRequest(keysToFetch: anniversaryKeys)
//
//        let formatString = NSDateFormatter.dateFormatFromTemplate("MM dd", options: 0, locale: NSLocale.currentLocale())
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = formatString
//
//        contacts.enumerateContactsWithFetchRequest(anniversaryFetch) { (contact: CNContact, error: UnsafeMutablePointer<ObjCBool>) -> Void in
//            for date in contact.dates {
//                if date.label == CNLabelDateAnniversary {
//                    let anniversaryValue = date.value as! NSDateComponents
//                    let anniversary = NSCalendar.currentCalendar().dateFromComponents(anniversaryValue)
//                    let anniversaryEntity = NSEntityDescription.entityForName("Date", inManagedObjectContext: self.managedContext)
//                    let anniversaryDate = Date(entity: anniversaryEntity!, insertIntoManagedObjectContext: self.managedContext)
//
//                    anniversaryDate.name = "\(contact.givenName) \(contact.familyName)"
//                    anniversaryDate.abbreviatedName = self.abbreviateName(anniversaryDate.name)
//                    anniversaryDate.date = anniversary!
//                    anniversaryDate.equalizedDate = dateFormatter.stringFromDate(anniversary!)
//                    anniversaryDate.type = "birthday"
//                }
//            }
//        }
//    }















