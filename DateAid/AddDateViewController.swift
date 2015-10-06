//
//  AddDateViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/5/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

class AddDateViewController: UIViewController, UITextFieldDelegate {
    
    var managedContext = CoreDataStack().managedObjectContext
    
    var type: String?
    var name: String?
    var date: NSDate?

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var yearSlider: UISlider!
    @IBOutlet weak var monthSlider: UISlider!
    @IBOutlet weak var daySlider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSliderValues()
        populateEditValues()
        nameField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning in AddDateVC")
    }
    
    // Dismissing keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let _ = touches.first {
            view.endEditing(true)
        }
        super.touchesBegan(touches , withEvent:event)
    }
    
    // Dismissing keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        view.endEditing(true)
        return true
    }
    
    // Clearing text
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return false
    }
    
    func populateEditValues() {
        if let typeToEdit = type {
            typeLabel.text = typeToEdit.capitalizedString
        }
        if let nameToEdit = name {
            nameField.text = nameToEdit
        }
        if let dateToEdit = date {
            yearSlider.value = Float(dateToEdit.getYear())
            monthSlider.value = Float(dateToEdit.getMonth())
            daySlider.value = Float(dateToEdit.getDay())
        }
    }
    
    func setUpSliderValues() {
        yearSlider.minimumValue = 1900
        yearSlider.maximumValue = 2015
        yearSlider.continuous = true
        yearSlider.addTarget(self, action: Selector("valueChanged:"), forControlEvents: .ValueChanged)
        monthSlider.minimumValue = 1
        monthSlider.maximumValue = 12
        monthSlider.continuous = true
        monthSlider.addTarget(self, action: Selector("valueChanged:"), forControlEvents: .ValueChanged)
        daySlider.minimumValue = 1
        daySlider.maximumValue = 31
        daySlider.continuous = true
        daySlider.addTarget(self, action: Selector("valueChanged:"), forControlEvents: .ValueChanged)
    }
    
    func valueChanged(sender: UISlider) {
        let value = round(sender.value)
        sender.setValue(value, animated: false)
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
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func saveManagedContext() {
        do { try managedContext.save() } catch {}
    }
    
    func abbreviateName(name: String) -> String {
        return name.containsString(" ") ? name[0...((name as NSString).rangeOfString(" ").location + 1)] : (name as String)
    }
}





