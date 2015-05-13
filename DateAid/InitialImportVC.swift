//
//  ViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/7/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import AddressBook
import AddressBookUI

class InitialImportVC: UIViewController {
    
    var addressBook: ABAddressBook!
    var datesDictionary = [String: (NSDate, String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var userHasSeenInitialVIew = NSUserDefaults.standardUserDefaults().valueForKey("seenInitialView") as? Bool
        if userHasSeenInitialVIew == !true {
            return
        } else if userHasSeenInitialVIew == true {
            self.performSegueWithIdentifier("HomeScreen", sender: self)
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
    
    @IBAction func syncContacts(sender: AnyObject) {
        getContactNames()
    }
    
    func daysBetween(date1: NSDate, date2: NSDate) -> Int {
        var unitFlags = NSCalendarUnit.CalendarUnitDay
        var calendar = NSCalendar.currentCalendar()
        var components = calendar.components(unitFlags, fromDate: date1, toDate: date2, options: nil)
        return 365 - (components.day)
    }
    
    func getContactNames() {
        if !self.determineStatus() {
            println("determineStatus() returns false. Exiting getContactNames()")
            return
        }
        let people = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray as [ABRecord]
        for people in people {
            let date = ABRecordCopyValue(people, kABPersonBirthdayProperty)
            if date != nil {
                let name = ABRecordCopyCompositeName(people)
                let contactDate = date.takeUnretainedValue() as! NSDate
                var daysAway = daysBetween(contactDate, date2: NSDate())
                while daysAway < 0 {
                    daysAway = daysAway + 365
                }
                let dateName = name.takeUnretainedValue() as! String
                let dateDaysAway = "\(daysAway) days away"
                
                var thing = [contactDate, dateDaysAway]
                
                datesDictionary.updateValue((contactDate, dateDaysAway), forKey: dateName)
                
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "seenInitialView")
        let destinationVC = segue.destinationViewController as! DatesTableVC
    }
    
}

