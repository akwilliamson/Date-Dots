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
    
    // MARK: PROPERTIES
    
    var managedContext: NSManagedObjectContext?
    var addressBook: ABAddressBook!
    var datesToAdd: [Date]?
    var datesAlreadyAdded: [Date]?
    
    // MARK: OUTLETS
    
    @IBOutlet weak var importButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    // MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchExistingDates()
        setButtonStyles()
    }
    
    override func viewWillAppear(animated: Bool) {
        [importButton, skipButton].forEach({ $0.transform = CGAffineTransformScale($0.transform, 0, 0) })
        zoomInButton(importButton, withDelay: 0)
        zoomInButton(skipButton, withDelay: 0.2)
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
    
    // MARK: ACTIONS
    
    @IBAction func syncContacts(sender: AnyObject) {
        getDatesFromContacts()
        addEntitiesForCustomDatesFromPlist()
        saveManagedContext()
        self.performSegueWithIdentifier("HomeScreen", sender: self)
    }
    
    // MARK: HELPERS
    
    func fetchExistingDates() {
        let existingDateFetchRequest = NSFetchRequest(entityName: "Date")
        
        do { datesAlreadyAdded = try managedContext?.executeFetchRequest(existingDateFetchRequest) as? [Date]
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // The main method to extract and save all initial dates
    func getDatesFromContacts() {
        if userHasAuthorizedAddressBookAccess() == true {
            createAnAddressBook()
            createDateEntitiesFrom(addressBook)
        }
    }
    
    /* Passes user's address book to getDatesFromContacts() and allows said function
    to continue, or returns no address book and forces getDatesFromContacts to exit. */
    func userHasAuthorizedAddressBookAccess() -> Bool {
        switch ABAddressBookGetAuthorizationStatus() {
        case .Authorized:
            return true
        case .NotDetermined:
            var userDidAuthorize: Bool!
            ABAddressBookRequestAccessWithCompletion(nil) { (granted: Bool, error: CFError!) in
                if granted { userDidAuthorize = true } else { userDidAuthorize = false }
            }
            return userDidAuthorize
        case .Restricted:
            return false
        case .Denied:
            return false
        }
    }
    // Helper method for determineStatus that extracts and initializes the actual address book
    func createAnAddressBook() {
        if self.addressBook != nil { // If an addressBook exists, then
            return
        } else { // Create one
            var error: Unmanaged<CFError>? = nil
            let newAddressBook: ABAddressBook? = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()
            addressBook = newAddressBook
        }
    }
    
    func createDateEntitiesFrom(addressBook: ABAddressBook?) {
        if addressBook != nil {
            let contacts = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray as [ABRecord]
            for contact in contacts {
                addBirthdayEntityFor(contact)
                addAnniversaryEntityFor(contact)
            }
        }
    }
    
    func createDateObjectFrom(contact: (name: String, date: NSDate, type: String)) -> Date {
        let dateEntity = NSEntityDescription.entityForName("Date", inManagedObjectContext: managedContext!)
        let dateObject = Date(entity: dateEntity!, insertIntoManagedObjectContext: managedContext)
        
        dateObject.name = contact.name
        dateObject.abbreviatedName = contact.name.abbreviateName()
        dateObject.date = contact.date
        dateObject.equalizedDate = contact.date.formatDateIntoString()
        dateObject.type = contact.type
        
        return dateObject
    }
    
    func extractAddressesFrom(contact: AnyObject) -> (values: ABMultiValueRef, count: CFIndex) {
        let unmanagedAddresses = ABRecordCopyValue(contact, kABPersonAddressProperty)
        let addresses = (Unmanaged.fromOpaque(unmanagedAddresses.toOpaque()).takeUnretainedValue() as NSObject) as ABMultiValueRef
        let numberOfAddresses = ABMultiValueGetCount(addresses)
        
        return (addresses, numberOfAddresses)
    }
    
    func extractAddressValuesFrom(addresses: ABMultiValueRef, atIndex index: CFIndex) -> (street: String, region: String) {
        var street = ""
        var region = ""
        
        let unmanagedAddress = ABMultiValueCopyValueAtIndex(addresses, index)
        let address = (Unmanaged.fromOpaque(unmanagedAddress.toOpaque()).takeUnretainedValue() as NSObject) as! NSDictionary
        
        if let streetValue = address.valueForKey("Street") as? String {
            street = streetValue
        }
        if let cityValue = address.valueForKey("City") as? String {
            region = cityValue
        }
        if let stateValue = address.valueForKey("State") as? String {
            region += " \(stateValue)"
        }
        if let zip = address.valueForKey("ZIP") as? String {
            if let intZip = Int(zip) {
                let zipCodeValue = NSNumber(integer: intZip)
                region += " \(zipCodeValue)"
            }
        }
        return (street, region)
    }
    
    func createAddressObjectFor(address: (String, String)) -> Address {
        let addressEntity = NSEntityDescription.entityForName("Address", inManagedObjectContext: managedContext!)
        let addressObject = Address(entity: addressEntity!, insertIntoManagedObjectContext: managedContext)
        
        return addressObject
    }
    
    func extractValuesForDateFrom(contact: AnyObject, forType type: String, atIndex index: CFIndex?, optionalContact: AnyObject?) -> (name: String, date: NSDate, type: String) {
        var storedDate: NSDate!
        var contactName: String!
        if type == "birthday" {
            storedDate = ABRecordCopyValue(contact, kABPersonBirthdayProperty).takeUnretainedValue() as! NSDate
            contactName = ABRecordCopyCompositeName(contact).takeUnretainedValue() as String
        } else if type == "anniversary" {
            storedDate = ABMultiValueCopyValueAtIndex(contact, index!).takeUnretainedValue() as! NSDate
            contactName = ABRecordCopyCompositeName(optionalContact).takeUnretainedValue() as String
        }
        
        let contactDate = NSCalendar.currentCalendar().startOfDayForDate(storedDate)
        let contactType = type
        
        return (contactName, contactDate, contactType)
    }
    
    func findMatchingDateObjectFor(contact: (name: String, date: NSDate, type: String)) -> NSFetchRequest {
        let matchingDateRequest = NSFetchRequest(entityName: "Date")
        matchingDateRequest.predicate = NSPredicate(format: "name = %@ AND date = %@ AND type = %@", contact.name, contact.date, contact.type)
        matchingDateRequest.fetchLimit = 1
        
        return matchingDateRequest
    }
    
    func addBirthdayEntityFor(addressBookContact: AnyObject) {
        let contactHasABirthday = ABRecordCopyValue(addressBookContact, kABPersonBirthdayProperty)
        
        if contactHasABirthday != nil {
            let contactValues = extractValuesForDateFrom(addressBookContact, forType: "birthday", atIndex: nil, optionalContact: nil)
            fetchOrCreateEntityWith(contactValues, forContact: addressBookContact)
        }
    }
    
    func addAnniversaryEntityFor(addressBookContact: AnyObject) {
        let dateProperties: ABMultiValueRef = ABRecordCopyValue(addressBookContact, kABPersonDateProperty).takeUnretainedValue()
        for index in 0..<ABMultiValueGetCount(dateProperties) {
            let datePropertyLabel = (ABMultiValueCopyLabelAtIndex(dateProperties, index)).takeRetainedValue() as String
            let anniversaryLabel = kABPersonAnniversaryLabel as String
            
            if datePropertyLabel == anniversaryLabel {
                let contactValues = extractValuesForDateFrom(dateProperties, forType: "anniversary", atIndex: index, optionalContact: addressBookContact)
                fetchOrCreateEntityWith(contactValues, forContact: addressBookContact)
            }
        }
    }
    
    func fetchOrCreateEntityWith(contactValues: (name: String, date: NSDate, type: String), forContact addressBookContact: AnyObject) {
        let fetchRequest = findMatchingDateObjectFor(contactValues)
        do { let matchingDate = try managedContext?.executeFetchRequest(fetchRequest) as? [Date]
            if matchingDate?.count == 0 {
                let dateObject = createDateObjectFrom(contactValues)
                let addresses = extractAddressesFrom(addressBookContact)
                if addresses.count > 0 {
                    for index in 0..<addresses.count {
                        let addressValues = extractAddressValuesFrom(addresses.values, atIndex: index)
                        let addressObject = createAddressObjectFor(addressValues)
                        dateObject.address = addressObject
                    }
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func saveManagedContext() {
        do { try managedContext!.save()
        } catch let fetchError as NSError {
            print(fetchError.localizedDescription)
        }
    }
    
    func addEntitiesForCustomDatesFromPlist() {
        if let path = NSBundle.mainBundle().pathForResource("Custom", ofType: "plist") {
            let customDictionary = NSDictionary(contentsOfFile: path)!
            for (customName, customDate) in customDictionary {
                let actualDate = customDate as! NSDate
                
                let name = customName as! String
                let abbreviatedName = name
                let date = NSCalendar.currentCalendar().startOfDayForDate(actualDate)
                let equalizedDate = actualDate.formatDateIntoString()
                let type = "custom"
                
                let fetchRequest = NSFetchRequest(entityName: "Date")
                fetchRequest.predicate = NSPredicate(format: "name = %@ AND date = %@ AND type = %@", name,date,type)
                fetchRequest.fetchLimit = 1
                
                do { let result = try managedContext?.executeFetchRequest(fetchRequest) as? [Date]
                    if result?.count == 0 {
                        let customEntity = NSEntityDescription.entityForName("Date", inManagedObjectContext: managedContext!)
                        let customDate = Date(entity: customEntity!, insertIntoManagedObjectContext: managedContext)
                        
                        customDate.name = name
                        customDate.abbreviatedName = abbreviatedName
                        customDate.date = date
                        customDate.equalizedDate = equalizedDate
                        customDate.type = type
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func setButtonStyles() {
        importButton.titleLabel?.textAlignment = .Center
        importButton.layer.cornerRadius = 85
        skipButton.titleLabel?.textAlignment = .Center
        skipButton.layer.cornerRadius = 60
    }
}

//
//    func iOS9AddBirthdays() {
//
//        let formatString = NSDateFormatter.dateFormatFromTemplate("MM dd", options: 0, locale: NSLocale.currentLocale())
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = formatString
//        if #available(iOS 9.0, *) {
//            let contacts = CNContactStore()
//            let birthdayKeys = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactBirthdayKey]
//            let birthdayFetch = CNContactFetchRequest(keysToFetch: birthdayKeys)
//            do { try contacts.enumerateContactsWithFetchRequest(birthdayFetch) { (contact: CNContact, error: UnsafeMutablePointer<ObjCBool>) -> Void in
//                    let fullName = "\(contact.givenName) \(contact.familyName)"
//                    let abbreviatedName = abbreviateName(fullName)
//                    if let contactBirthday = contact.birthday {
//                        let birthday = NSCalendar.currentCalendar().dateFromComponents(contactBirthday)
//                        let birthdayEntity = NSEntityDescription.entityForName("Date", inManagedObjectContext: managedContext)
//                        let birthdayDate = Date(entity: birthdayEntity!, insertIntoManagedObjectContext: managedContext)
//
//                        birthdayDate.name = fullName
//                        birthdayDate.abbreviatedName = abbreviatedName
//                        birthdayDate.date = birthday!
//                        birthdayDate.equalizedDate = dateFormatter.stringFromDate(birthday!)
//                        birthdayDate.type = "birthday"
//                    }
//                }
//            } catch let error as NSError {
//                print(error.localizedDescription)
//            }
//
//        } else {
//            // Fallback on earlier versions
//        }
//
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

















