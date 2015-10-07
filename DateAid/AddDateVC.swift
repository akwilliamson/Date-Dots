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
    var editingDate: Bool? // To change view's title
    
// MARK: OUTLETS

    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var birthdayButton: UIButton!
    @IBOutlet weak var anniversaryButton: UIButton!
    @IBOutlet weak var holidayButton: UIButton!
    @IBOutlet weak var yearSlider: DateSlider!
    @IBOutlet weak var monthSlider: DateSlider!
    @IBOutlet weak var daySlider: DateSlider!

// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkType()
        setTitle(editingDate)
        addBarButtonItem()
        configureTypeButtons()
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
        type = "birthday"
        yearSlider.setThumbImage(UIImage(named: "birthday-button.png"), forState: .Normal)
        yearSlider.minimumTrackTintColor = UIColor.birthdayColor()
        monthSlider.setThumbImage(UIImage(named: "birthday-button.png"), forState: .Normal)
        monthSlider.minimumTrackTintColor = UIColor.birthdayColor()
        daySlider.setThumbImage(UIImage(named: "birthday-button.png"), forState: .Normal)
        daySlider.minimumTrackTintColor = UIColor.birthdayColor()
    }
    
    @IBAction func anniversaryButton(sender: AnyObject) {
        type = "anniversary"
        yearSlider.setThumbImage(UIImage(named: "anniversary-button.png"), forState: .Normal)
        yearSlider.minimumTrackTintColor = UIColor.anniversaryColor()
        monthSlider.setThumbImage(UIImage(named: "anniversary-button.png"), forState: .Normal)
        monthSlider.minimumTrackTintColor = UIColor.anniversaryColor()
        daySlider.setThumbImage(UIImage(named: "anniversary-button.png"), forState: .Normal)
        daySlider.minimumTrackTintColor = UIColor.anniversaryColor()
    }
    
    @IBAction func holidayButton(sender: AnyObject) {
        type = "holiday"
        yearSlider.setThumbImage(UIImage(named: "holiday-button.png"), forState: .Normal)
        yearSlider.minimumTrackTintColor = UIColor.holidayColor()
        monthSlider.setThumbImage(UIImage(named: "holiday-button.png"), forState: .Normal)
        monthSlider.minimumTrackTintColor = UIColor.holidayColor()
        daySlider.setThumbImage(UIImage(named: "holiday-button.png"), forState: .Normal)
        daySlider.minimumTrackTintColor = UIColor.holidayColor()
    }
    
    func saveButton(sender: UIBarButtonItem) {
        if name != nil { // if user is editing a date
            let fetchRequest = NSFetchRequest(entityName: "Date")
            fetchRequest.predicate = NSPredicate(format: "name = %@ AND type = %@", nameField.text!, type!)
            
            do { let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
                let managedObject = fetchedResults![0]
                managedObject.setValue(self.type, forKey: "type")
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
        } else { // user is creating a new date
            let entity = NSEntityDescription.entityForName("Date", inManagedObjectContext: managedContext)
            let date = Date(entity: entity!, insertIntoManagedObjectContext: managedContext)
            date.type = type!
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
    
    func addBarButtonItem() {
        let saveButton = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "saveButton:")
        self.navigationItem.setRightBarButtonItem(saveButton, animated: false)
    }
    
    func setDelegates() {
        nameField.delegate = self
    }
    
    func checkType() {
        if type == nil {
            type = "birthday"
        }
    }
    
    func setTitle(editing: Bool?) {
        if editingDate == true {
            title = "Edit"
        } else {
            title = "Add"
        }
    }
    
    func configureTypeButtons() {
        birthdayButton.layer.cornerRadius = 20
        anniversaryButton.layer.cornerRadius = 20
        holidayButton.layer.cornerRadius = 20
    }
    
    func populateEditableValues() {
//        if let type = type {
//            show which type is currently selected
//        }
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
        setUpYearSlider()
        setUpMonthSlider()
        setUpDaySlider()
    }
    
    func setUpGenericSlider(slider: DateSlider) {
        slider.popUpViewCornerRadius = 10
        slider.popUpViewArrowLength = 7
        slider.setMaxFractionDigitsDisplayed(0)
        slider.font = UIFont(name: "AvenirNext-Bold", size: 15)
        slider.textColor = UIColor.whiteColor()
        switch type! {
        case "birthday":
            slider.setThumbImage(UIImage(named: "birthday-button.png"), forState: .Normal)
            slider.popUpViewColor = UIColor.birthdayColor()
        case "anniversary":
            slider.setThumbImage(UIImage(named: "anniversary-button.png"), forState: .Normal)
            slider.popUpViewColor = UIColor.anniversaryColor()
        default:
            slider.setThumbImage(UIImage(named: "holiday-button.png"), forState: .Normal)
            slider.popUpViewColor = UIColor.holidayColor()
        }
        slider.addTarget(self, action: Selector("valueChanged:"), forControlEvents: .ValueChanged)
    }
    
    func setUpYearSlider() {
        yearSlider.minimumValue = 1900
        yearSlider.maximumValue = 2015
        yearSlider.value = 2015
        setUpGenericSlider(yearSlider)
    }
    
    func setUpMonthSlider() {
        monthSlider.minimumValue = 1
        monthSlider.maximumValue = 12
        monthSlider.value = 1
        setUpGenericSlider(monthSlider)
    }
    
    func setUpDaySlider() {
        daySlider.minimumValue = 1
        daySlider.maximumValue = 31
        daySlider.value = 1
        setUpGenericSlider(daySlider)
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





