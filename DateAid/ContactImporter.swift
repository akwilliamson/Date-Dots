//
//  ContactImporter.swift
//  DateAid
//
//  Created by Aaron Williamson on 11/4/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import Foundation
import CoreData
import AddressBook
import AddressBookUI
import Contacts

struct ContactImporter {
    
    var managedContext: NSManagedObjectContext?
    var addressBook: ABAddressBook!
    var datesToAdd: [Date]?
    var datesAlreadyAdded: [Date]?
    
    mutating func syncContacts(status: ABAuthorizationStatus) {
        managedContext = CoreDataStack().managedObjectContext
        if status == .authorized {
            fetchExistingDates()
            getDatesFromContacts()
            addCustomEntitiesForPlistDates()
            saveManagedContext()
        } else {
            addCustomEntitiesForPlistDates()
            saveManagedContext()
        }
    }
    
   fileprivate mutating func fetchExistingDates() {
        let existingDateFetchRequest = NSFetchRequest(entityName: "Date")
        do { datesAlreadyAdded = try managedContext?.fetch(existingDateFetchRequest) as? [Date]
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    fileprivate mutating func getDatesFromContacts() {
        createAnAddressBook()
        createDateEntitiesFrom(addressBook)
    }
    
    fileprivate mutating func createAnAddressBook() {
        if self.addressBook != nil { // If an addressBook exists, then exit
            return
        } else { // If not, create one
            var error: Unmanaged<CFError>? = nil
            let newAddressBook: ABAddressBook? = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()
            addressBook = newAddressBook
        }
    }
    
    fileprivate func createDateEntitiesFrom(_ addressBook: ABAddressBook?) {
        if addressBook != nil {
            let contacts = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray as [ABRecord]
            for contact in contacts {
                addBirthdayEntityFor(contact)
                addAnniversaryEntityFor(contact)
            }
        }
    }
    
    fileprivate func addBirthdayEntityFor(_ addressBookContact: AnyObject) {
        let contactHasABirthday = ABRecordCopyValue(addressBookContact, kABPersonBirthdayProperty)
        
        if contactHasABirthday != nil {
            let contactValues = extractValuesForDateFrom(addressBookContact, forType: "birthday", atIndex: nil, optionalContact: nil)
            fetchOrCreateEntityWith(contactValues, forContact: addressBookContact)
        }
    }
    
    fileprivate func addAnniversaryEntityFor(_ addressBookContact: AnyObject) {
        let dateProperties: ABMultiValue = ABRecordCopyValue(addressBookContact, kABPersonDateProperty).takeUnretainedValue()
        for index in 0..<ABMultiValueGetCount(dateProperties) {
            let datePropertyLabel = (ABMultiValueCopyLabelAtIndex(dateProperties, index)).takeRetainedValue() as String
            let anniversaryLabel = kABPersonAnniversaryLabel as String
            
            if datePropertyLabel == anniversaryLabel {
                let contactValues = extractValuesForDateFrom(dateProperties, forType: "anniversary", atIndex: index, optionalContact: addressBookContact)
                fetchOrCreateEntityWith(contactValues, forContact: addressBookContact)
            }
        }
    }
    
    fileprivate func addCustomEntitiesForPlistDates() {
        if let path = Bundle.main.path(forResource: "Custom", ofType: "plist") {
            let customDictionary = NSDictionary(contentsOfFile: path)!
            for (customName, customDate) in customDictionary {
                let actualDate = customDate as! Foundation.Date
                let name = customName as! String
                let date = Calendar.current.startOfDay(for: actualDate)
                let type = "custom"
                let contactValues = (name, date, type)
                fetchOrCreateEntityWith(contactValues, forContact: nil)
            }
        }
    }
    
    fileprivate func extractValuesForDateFrom(_ contact: AnyObject, forType type: String, atIndex index: CFIndex?, optionalContact: AnyObject?) -> (name: String, date: Foundation.Date, type: String) {
        var storedDate: Foundation.Date!
        var contactName: String!
        if type == "birthday" {
            storedDate = ABRecordCopyValue(contact, kABPersonBirthdayProperty).takeUnretainedValue() as! Foundation.Date
            contactName = ABRecordCopyCompositeName(contact).takeUnretainedValue() as String
        } else if type == "anniversary" {
            storedDate = ABMultiValueCopyValueAtIndex(contact, index!).takeUnretainedValue() as! Foundation.Date
            contactName = ABRecordCopyCompositeName(optionalContact).takeUnretainedValue() as String
        }
        
        let contactDate = Calendar.current.startOfDay(for: storedDate)
        let contactType = type
        
        return (contactName, contactDate, contactType)
    }
    
    fileprivate func fetchOrCreateEntityWith(_ contactValues: (name: String, date: Foundation.Date, type: String), forContact addressBookContact: AnyObject?) {
        let fetchRequest = findMatchingDateObjectFor(contactValues)
        do { let matchingDate = try managedContext?.fetch(fetchRequest) as? [Date]
            if matchingDate?.count == 0 {
                let dateObject = createDateObjectFrom(contactValues)
                if let addressBookContact = addressBookContact {
                    let addresses = extractAddressesFrom(addressBookContact)
                    if addresses.count > 0 {
                        for index in 0..<addresses.count {
                            let addressValues = extractAddressValuesFrom(addresses.values, atIndex: index)
                            let addressObject = createAddressObjectFor(addressValues)
                            dateObject.address = addressObject
                        }
                    }
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    fileprivate func findMatchingDateObjectFor(_ contact: (name: String, date: Foundation.Date, type: String)) -> NSFetchRequest<AnyObject> {
        let matchingDateRequest = NSFetchRequest(entityName: "Date")
        matchingDateRequest.predicate = NSPredicate(format: "name = %@ AND date = %@ AND type = %@", contact.name, contact.date, contact.type)
        matchingDateRequest.fetchLimit = 1
        
        return matchingDateRequest
    }
    
    fileprivate func createDateObjectFrom(_ contact: (name: String, date: Foundation.Date, type: String)) -> Date {
        let dateEntity = NSEntityDescription.entity(forEntityName: "Date", in: managedContext!)
        let dateObject = Date(entity: dateEntity!, insertInto: managedContext)
        
        dateObject.name = contact.name
        dateObject.abbreviatedName = contact.name.abbreviateName()
        dateObject.date = contact.date
        dateObject.equalizedDate = contact.date.formatDateIntoString()
        dateObject.type = contact.type
        
        return dateObject
    }
    
    fileprivate func extractAddressesFrom(_ contact: AnyObject) -> (values: ABMultiValue, count: CFIndex) {
        let unmanagedAddresses = ABRecordCopyValue(contact, kABPersonAddressProperty)
        let addresses = (Unmanaged.fromOpaque((unmanagedAddresses?.toOpaque())!).takeUnretainedValue() as NSObject) as ABMultiValue
        let numberOfAddresses = ABMultiValueGetCount(addresses)
        
        return (addresses, numberOfAddresses)
    }
    
    fileprivate func extractAddressValuesFrom(_ addresses: ABMultiValue, atIndex index: CFIndex) -> (street: String, region: String) {
        var street = ""
        var region = ""
        
        let unmanagedAddress = ABMultiValueCopyValueAtIndex(addresses, index)
        let address = (Unmanaged.fromOpaque((unmanagedAddress?.toOpaque())!).takeUnretainedValue() as NSObject) as! NSDictionary
        
        if let streetValue = address.value(forKey: "Street") as? String {
            street = streetValue
        }
        if let cityValue = address.value(forKey: "City") as? String {
            region = cityValue
        }
        if let stateValue = address.value(forKey: "State") as? String {
            region += " \(stateValue)"
        }
        if let zip = address.value(forKey: "ZIP") as? String {
            if let intZip = Int(zip) {
                let zipCodeValue = NSNumber(value: intZip as Int)
                region += " \(zipCodeValue)"
            }
        }
        return (street, region)
    }
    
    fileprivate func createAddressObjectFor(_ address: (String, String)) -> Address {
        let addressEntity = NSEntityDescription.entity(forEntityName: "Address", in: managedContext!)
        let addressObject = Address(entity: addressEntity!, insertInto: managedContext)
        
        return addressObject
    }
    
    fileprivate func saveManagedContext() {
        do { try managedContext!.save()
        } catch let fetchError as NSError {
            print(fetchError.localizedDescription)
        }
    }
}
//
//
//  >>>>>>>>>>>>>> IMPLEMENT LATER TO UTILIZE THE LATEST iOS 9 CONTACT API <<<<<<<<<<<<<<<<
//
//
//
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


