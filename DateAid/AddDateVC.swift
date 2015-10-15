//
//  AddDateVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/5/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

class AddDateVC: UIViewController {
    
// MARK: PROPERTIES
    
    var managedContext: NSManagedObjectContext?
    var dateToSave: Date!
    var isBeingEdited: Bool?
    let birthdayColor = UIColor.birthdayColor()
    let anniversaryColor = UIColor.anniversaryColor()
    let holidayColor = UIColor.holidayColor()
    let months = ["J","F","M","A","M","Jn","Jl","A","S","O","N","D"]
    
// MARK: OUTLETS

    @IBOutlet weak var nameField: AddNameTextField!
    
    @IBOutlet weak var birthdayButton: TypeButton!
    @IBOutlet weak var anniversaryButton: TypeButton!
    @IBOutlet weak var holidayButton: TypeButton!
    
    @IBOutlet weak var yearSlider: ValueSlider!
    @IBOutlet weak var monthSlider: ValueSlider!
    @IBOutlet weak var daySlider: ValueSlider!
    
// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDateToSave()
        setUpSliderValues()
        changeColorOfSlidersTo(birthdayColor, sliders: [yearSlider, monthSlider, daySlider])
        populateEditableValues()
        setDelegates()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        title = setNavBarTitle()
    }
    
    func setUpDateToSave() {
        if dateToSave == nil {
            let entity = NSEntityDescription.entityForName("Date", inManagedObjectContext: managedContext!)
            dateToSave = Date(entity: entity!, insertIntoManagedObjectContext: managedContext)
            dateToSave.type = "birthday"
        }
    }
    
    func populateEditableValues() {
        if isBeingEdited == true {
            nameField.text = dateToSave!.name
            yearSlider.value = Float(dateToSave!.date!.getYear())
            monthSlider.value = Float(dateToSave!.date!.getMonth())
            daySlider.value = Float(dateToSave!.date!.getDay())
        }
    }
    
    func setDelegates() {
        nameField.delegate = self
        yearSlider.dataSource = self
        monthSlider.dataSource = self
        daySlider.dataSource = self
    }
    
    func setNavBarTitle() -> String {
        return isBeingEdited! == true ? "Edit" : "Add"
    }
    
// MARK: ACTIONS
    
    @IBAction func birthdayButton(sender: AnyObject) {
        changeColorOfSlidersTo(birthdayColor, sliders: [yearSlider, monthSlider, daySlider])
        dateToSave.type = "birthday"
    }
    
    @IBAction func anniversaryButton(sender: AnyObject) {
        changeColorOfSlidersTo(anniversaryColor, sliders: [yearSlider, monthSlider, daySlider])
        dateToSave.type = "anniversary"
    }
    
    @IBAction func holidayButton(sender: AnyObject) {
        changeColorOfSlidersTo(holidayColor, sliders: [yearSlider, monthSlider, daySlider])
        dateToSave.type = "holiday"
    }
    
    func changeColorOfSlidersTo(color: UIColor, sliders: [ValueSlider]) {
        for slider in sliders {
            slider.thumbTintColor = color
            slider.minimumTrackTintColor = color
            slider.popUpViewColor = color
        }
    }
    
    @IBAction func saveButton(sender: UIBarButtonItem) {
        
        let dateString = "\(Int(yearSlider.value))-\(Int(monthSlider.value))-\(Int(daySlider.value))"
        let date = NSDate(dateString: dateString)
        let equalizedDate = date.formatCurrentDateIntoString()
        
        dateToSave.date = date
        dateToSave.equalizedDate = equalizedDate
        save()
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func save() {
        do { try managedContext!.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
// MARK: HELPERS
    
    func setUpSliderValues() {
        yearSlider.setValues(min: 1900, max: 2015, value: 2015)
        monthSlider.setValues(min: 1, max: 12, value: 1)
        daySlider.setValues(min: 1, max: 31, value: 1)
    }
    
    func valueChanged(sender: UISlider) {
        let toNewValue = round(sender.value)
        sender.setValue(toNewValue, animated: false)
    }

}

extension AddDateVC: UITextFieldDelegate {
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let _ = touches.first {
            view.endEditing(true)
        }
        super.touchesBegan(touches, withEvent: event)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let name = textField.text!
        dateToSave.name = name
        dateToSave.abbreviatedName = name.abbreviateName()
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return false
    }
}

extension AddDateVC: ASValueTrackingSliderDataSource {
    
    func slider(slider: ASValueTrackingSlider!, stringForValue value: Float) -> String! {
        let intValue = Int(value)
        switch slider {
        case yearSlider:
            return value % 100 < 10 ? "'0\(intValue % 100)" : "'\(intValue % 100)"
        case monthSlider:
            return months[intValue - 1]
        default: // daySlider
            return String(intValue)
            
        }
    }
}
