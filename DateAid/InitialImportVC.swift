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
    
    lazy var contactImporter: ContactImporter = {
        return ContactImporter()
    }()
    
    // MARK: OUTLETS
    
    @IBOutlet weak var importButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    // MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        contactImporter.syncContacts()
        self.performSegueWithIdentifier("HomeScreen", sender: self)
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

















