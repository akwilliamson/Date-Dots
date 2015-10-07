//
//  AddDateVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/5/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

class AddDateVC: UIViewController, UITextFieldDelegate {
    
// MARK: PROPERTIES
    
    let managedContext = CoreDataStack().managedObjectContext
    var type: String?
    var name: String?
    var date: NSDate?
    
// MARK: OUTLETS

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var yearSlider: ASValueTrackingSlider!
    @IBOutlet weak var monthSlider: ASValueTrackingSlider!
    @IBOutlet weak var daySlider: ASValueTrackingSlider!

// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSliderValues()
        populateEditableValues()
        setDelegates()
    }
    
// MARK: MEMORY
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning in AddDateVC")
    }
    
// MARK: TEXTFIELDS
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let _ = touches.first {
            view.endEditing(true)
        }
        super.touchesBegan(touches , withEvent:event)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        view.endEditing(true)
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return false
    }
    
    @IBAction func birthdayButton(sender: AnyObject) {
        typeLabel.text = "Birthday"
    }
    
    @IBAction func anniversaryButton(sender: AnyObject) {
        typeLabel.text = "Anniversary"
    }
    
    @IBAction func holidayButton(sender: AnyObject) {
        typeLabel.text = "Holiday"
    }
    
    @IBAction func yearSlider(sender: UISlider) {
        yearLabel.text = String(Int(round(sender.value)))
    }
    
    @IBAction func monthSlider(sender: UISlider) {
        monthLabel.text = String(Int(round(sender.value)))
    }
    
    @IBAction func daySlider(sender: UISlider) {
        dayLabel.text = String(Int(round(sender.value)))
    }
    
    @IBAction func saveButton(sender: AnyObject) {
        if let type = type {
            let fetchRequest = NSFetchRequest(entityName: "Date")
            fetchRequest.predicate = NSPredicate(format: "name = %@ AND type = %@", nameField.text!, type)
            
            do { let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
                let managedObject = fetchedResults![0]
                managedObject.setValue(self.typeLabel.text!.lowercaseString, forKey: "type")
                managedObject.setValue(self.nameField.text!, forKey: "name")
                managedObject.setValue(self.abbreviateName(self.nameField.text!), forKey: "abbreviatedName")
                let editedDate = NSDate(dateString: "\(self.yearLabel.text!)-\(self.monthLabel.text!)-\(self.dayLabel.text!)")
                managedObject.setValue(editedDate, forKey: "date")
                let equalizedDate = formatCurrentDateIntoString(editedDate)
                managedObject.setValue(equalizedDate, forKey: "equalizedDate")
                self.saveManagedContext()
            } catch let fetchError as NSError {
                print(fetchError.localizedDescription)
            }
        } else {
            let entity = NSEntityDescription.entityForName("Date", inManagedObjectContext: managedContext)
            let date = Date(entity: entity!, insertIntoManagedObjectContext: managedContext)
            date.type = typeLabel.text!.lowercaseString
            date.name = nameField.text!
            date.abbreviatedName = abbreviateName(nameField.text!)
            date.date = NSDate(dateString: "\(yearLabel.text!)-\(monthLabel.text!)-\(dayLabel.text!)")
            let formatString = NSDateFormatter.dateFormatFromTemplate("MM dd", options: 0, locale: NSLocale.currentLocale())
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = formatString
            date.equalizedDate = dateFormatter.stringFromDate(date.date)   
            saveManagedContext()
        }
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
// MARK: HELPERS
    
    func setDelegates() {
        nameField.delegate = self
    }
    
    func populateEditableValues() {
        if let typeToEdit = type {
            typeLabel.text = typeToEdit.capitalizedString
        }
        if let nameToEdit = name {
            nameField.text = nameToEdit
        }
        if let dateToEdit = date {
            yearSlider.value = Float(dateToEdit.getYear())
            yearLabel.text = String(Int(round(yearSlider.value)))
            monthSlider.value = Float(dateToEdit.getMonth())
            monthLabel.text = String(Int(round(monthSlider.value)))
            daySlider.value = Float(dateToEdit.getDay())
            dayLabel.text = String(Int(round(daySlider.value)))
        }
    }
    
    func setUpSliderValues() {
        setUpYearSlider()
        setUpMonthSlider()
        setUpDaySlider()
    }
    
    func setUpYearSlider() {
        yearSlider.minimumValue = 1900
        yearSlider.maximumValue = 2015
        yearSlider.popUpViewCornerRadius = 12.0
        yearSlider.setMaxFractionDigitsDisplayed(0)
        yearSlider.value = 2015
        yearSlider.setThumbImage(UIImage(named: "birthday-button.png"), forState: .Normal)
        yearSlider.addTarget(self, action: Selector("valueChanged:"), forControlEvents: .ValueChanged)
    }
    
    func setUpMonthSlider() {
        monthSlider.minimumValue = 1
        monthSlider.maximumValue = 12
        monthSlider.popUpViewCornerRadius = 12.0
        monthSlider.setMaxFractionDigitsDisplayed(0)
        monthSlider.value = 1
        monthSlider.addTarget(self, action: Selector("valueChanged:"), forControlEvents: .ValueChanged)
    }
    
    func setUpDaySlider() {
        daySlider.minimumValue = 1
        daySlider.maximumValue = 31
        daySlider.popUpViewCornerRadius = 12.0
        daySlider.setMaxFractionDigitsDisplayed(0)
        daySlider.value = 1
        daySlider.addTarget(self, action: Selector("valueChanged:"), forControlEvents: .ValueChanged)
    }
    
    func valueChanged(sender: UISlider) {
        let value = round(sender.value)
        sender.setValue(value, animated: false)
    }
    
    func abbreviateName(name: String) -> String {
        return name.containsString(" ") ? name[0...((name as NSString).rangeOfString(" ").location + 1)] : (name as String)
    }
    
    func formatCurrentDateIntoString(date: NSDate) -> String {
        let formatString = NSDateFormatter.dateFormatFromTemplate("MM dd", options: 0, locale: NSLocale.currentLocale())
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = formatString
        return dateFormatter.stringFromDate(NSDate())
    }
    
    func saveManagedContext() {
        do { try managedContext.save() } catch {}
    }
}





