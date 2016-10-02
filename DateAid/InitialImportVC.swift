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

class InitialImportVC: UIViewController {
    
    // Passed through application(_:didFinishLaunchingWithOptions)
    var managedContext: NSManagedObjectContext!
    // Object to interact with contacts in address book
    lazy var contactManager: ContactManager = {
        return ContactManager()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func syncContacts(_ sender: AnyObject) {
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.transform = CGAffineTransform(scaleX: 2, y: 2)
        activityView.center = self.view.center
        activityView.startAnimating()
        self.view.addSubview(activityView)
        getDatesFromContacts()
        addEntitiesForHolidaysFromPlist()
        saveManagedContext()
        activityView.stopAnimating()
        self.performSegue(withIdentifier: "HomeScreen", sender: self)
    }
    // The main method to extract and save all initial dates
    func getDatesFromContacts() {
        
        let people = contactManager.contacts
        
        people.forEach { person in
            if let person = person {
                addEntitiesForAddressBookBirthdays(person)
                addEntitiesForAddressBookAnniversaries(person)
            }
        }
    }
    
    func addEntitiesForAddressBookBirthdays(_ person: CNContact) {
        let birthdayProperty = person.birthday
        
        if birthdayProperty != nil {
            
            let birthdayEntity = NSEntityDescription.entity(forEntityName: "Date", in: managedContext)
            let birthday = Date(entity: birthdayEntity!, insertInto: managedContext)
            
            birthday.name = "\(person.givenName) \(person.familyName)"
            birthday.abbreviatedName = abbreviate(person.givenName, familyName: person.familyName)
            birthday.date = (person.birthday?.date)!
            
            let dateFormatter = DateFormatter()
            let formatString = DateFormatter.dateFormat(fromTemplate: "MM dd", options: 0, locale: Locale.current)
            dateFormatter.dateFormat = formatString
            birthday.equalizedDate = dateFormatter.string(from: (person.birthday?.date)!)
            birthday.type = "birthday"
        }
    }
    
    func addEntitiesForAddressBookAnniversaries(_ person: CNContact) {
        
        let anniversaryDate = (person.dates.filter { return $0.label?.contains("Anniversary") ?? false }).first
        
        let anniversaryEntity = NSEntityDescription.entity(forEntityName: "Date", in: managedContext)
        let anniversary = Date(entity: anniversaryEntity!, insertInto: managedContext)
        
        anniversary.name = "\(person.givenName) \(person.familyName)"
        anniversary.abbreviatedName = abbreviate(person.givenName, familyName: person.familyName)
        anniversary.date = (anniversaryDate?.value.date)!
        let formatString = DateFormatter.dateFormat(fromTemplate: "MM dd", options: 0, locale: Locale.current)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
        anniversary.equalizedDate = dateFormatter.string(from: (anniversaryDate?.value.date)!)
        anniversary.type = "anniversary"
    }
    
    func saveManagedContext() {
        do {
            try managedContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func addEntitiesForHolidaysFromPlist() {
        if let path = Bundle.main.path(forResource: "Holidays", ofType: "plist") {
            let holidaysDictionary = NSDictionary(contentsOfFile: path)!
            for (holidayName, holidayDate) in holidaysDictionary {
                let holidayEntity = NSEntityDescription.entity(forEntityName: "Date", in: managedContext)
                let holiday = Date(entity: holidayEntity!, insertInto: managedContext)
                holiday.name = holidayName as! String
                holiday.abbreviatedName = holidayName as! String
                let actualDate = holidayDate as! Foundation.Date
                holiday.date = actualDate
                let formatString = DateFormatter.dateFormat(fromTemplate: "MM dd", options: 0, locale: Locale.current)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = formatString
                holiday.equalizedDate = dateFormatter.string(from: actualDate)
                holiday.type = "holiday"
            }
        }
    }
    // Abbreviates an address book name. Ex: Aaron Williamson -> Aaron W.
    func abbreviate(_ givenName: String, familyName: String?) -> String {
        
        guard let familyName = familyName, let character = familyName.characters.first else {
            return givenName
        }
        return givenName + " " + String(character)
    }
}
