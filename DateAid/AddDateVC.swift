//
//  AddDateVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/5/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

class AddDateVC: UIViewController, UITextFieldDelegate, ASValueTrackingSliderDataSource {
    
// MARK: PROPERTIES
    
    let managedContext = CoreDataStack().managedObjectContext
    var type: String?
    var name: String?
    var date: NSDate?
    var editingDate: Bool? // To change view's title
    let months = ["J","F","M","A","M","Jn","Jl","A","S","O","N","D"]
    
// MARK: OUTLETS

    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var birthdayButton: UIButton!
    @IBOutlet weak var anniversaryButton: UIButton!
    @IBOutlet weak var holidayButton: UIButton!
    @IBOutlet weak var yearSlider: ASValueTrackingSlider!
    @IBOutlet weak var monthSlider: ASValueTrackingSlider!
    @IBOutlet weak var daySlider: ASValueTrackingSlider!

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
    
    func changeSliderStyles(type: String, color: UIColor, sliders: [ASValueTrackingSlider]) {
        for slider in sliders {
            slider.thumbTintColor = color
            slider.minimumTrackTintColor = color
            slider.popUpViewColor = color
        }
    }
    
    @IBAction func birthdayButton(sender: AnyObject) {
        type = "birthday"
        changeSliderStyles("birthday", color: UIColor.birthdayColor(), sliders: [yearSlider, monthSlider, daySlider])
    }
    
    @IBAction func anniversaryButton(sender: AnyObject) {
        type = "anniversary"
        changeSliderStyles("anniversary", color: UIColor.anniversaryColor(), sliders: [yearSlider, monthSlider, daySlider])
    }
    
    @IBAction func holidayButton(sender: AnyObject) {
        type = "holiday"
        changeSliderStyles("holiday", color: UIColor.holidayColor(), sliders: [yearSlider, monthSlider, daySlider])
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
    
    func slider(slider: ASValueTrackingSlider!, stringForValue value: Float) -> String! {
        if slider == monthSlider {
            return months[Int(value)-1]
        } else if slider == yearSlider {
            if value % 100 < 10 {
                return "'0\(Int(value)%100)"
            } else {
                return "'\(Int(value)%100)"
            }
        } else {
            return "\(Int(value))"
        }
    }
    
// MARK: HELPERS
    
    func addBarButtonItem() {
        let saveButton = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "saveButton:")
        self.navigationItem.setRightBarButtonItem(saveButton, animated: false)
    }
    
    func setDelegates() {
        nameField.delegate = self
        yearSlider.dataSource = self
        monthSlider.dataSource = self
        daySlider.dataSource = self
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
    
    func setUpGenericSlider(slider: ASValueTrackingSlider) {
        slider.addTarget(self, action: "sliderTouchDown:", forControlEvents: .TouchDown)
        slider.addTarget(self, action: "sliderTouchUp:", forControlEvents: .TouchUpInside)
        slider.popUpViewCornerRadius = 8
        slider.popUpViewArrowLength = 4
        slider.setMaxFractionDigitsDisplayed(0)
        slider.font = UIFont(name: "AvenirNext-Bold", size: 15)
        slider.textColor = UIColor.whiteColor()
        switch type! {
        case "birthday":
            slider.popUpViewColor = UIColor.birthdayColor()
            slider.thumbTintColor = UIColor.birthdayColor()
        case "anniversary":
            slider.popUpViewColor = UIColor.anniversaryColor()
            slider.thumbTintColor = UIColor.anniversaryColor()
        default:
            slider.popUpViewColor = UIColor.holidayColor()
            slider.thumbTintColor = UIColor.holidayColor()
        }
    }
    
    func sliderTouchDown(sender: ASValueTrackingSlider) {
        
        let handleView = sender.subviews.last
        let label = handleView?.viewWithTag(30) as? UILabel
        if label != nil {
            label!.text = ""
        }
    }
    
    func sliderTouchUp(sender: ASValueTrackingSlider) {
        
        let handleView = sender.subviews.last
        var label = handleView?.viewWithTag(30) as? UILabel
        
        if label == nil {
            label = UILabel(frame: handleView!.bounds)
            label!.tag = 30
            label!.backgroundColor = UIColor.clearColor()
            label!.textColor = UIColor.whiteColor()
            label!.textAlignment = .Center
            handleView?.addSubview(label!)
        }
        var string: String?
        switch sender {
        case yearSlider:
            if sender.value % 100 < 10 {
                string = "'0\(Int(sender.value)%100)"
            } else {
                string = "'\(Int(sender.value)%100)"
            }
            label!.text = string
        case daySlider:
            string = "\(Int(sender.value))"
            label!.text = string
        default:
            string = months[Int(sender.value)-1]
            label!.text = string
        }
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
        monthSlider.addTarget(self, action: Selector("valueChanged:"), forControlEvents: .ValueChanged)
        setUpGenericSlider(monthSlider)
    }
    
    func setUpDaySlider() {
        daySlider.minimumValue = 1
        daySlider.maximumValue = 31
        daySlider.value = 1
        daySlider.addTarget(self, action: Selector("valueChanged:"), forControlEvents: .ValueChanged)
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


