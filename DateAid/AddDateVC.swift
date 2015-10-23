//
//  AddDateVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/5/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

protocol SetAddressDelegate {
    func setAddressProperties(street: String?, region: String?)
}

class AddDateVC: UIViewController, SetAddressDelegate {
    
// MARK: PROPERTIES
    
    var managedContext: NSManagedObjectContext?
    var dateToSave: Date!
    var isBeingEdited: Bool!
    let birthdayColor = UIColor.birthdayColor()
    let anniversaryColor = UIColor.anniversaryColor()
    let holidayColor = UIColor.holidayColor()
    let months = ["J","F","M","A","M","Jn","Jl","A","S","O","N","D"]
    var sliderLabelsAdded = false
    var street: String?
    var region: String?
    var incomingColor: UIColor!
    
// MARK: OUTLETS

    @IBOutlet weak var nameField: AddNameTextField!
    
    @IBOutlet weak var birthdayButton: TypeButton!
    @IBOutlet weak var anniversaryButton: TypeButton!
    @IBOutlet weak var holidayButton: TypeButton!
    @IBOutlet weak var editDetailsButton: UIButton!
    
    @IBOutlet weak var yearSlider: ValueSlider!
    @IBOutlet weak var monthSlider: ValueSlider!
    @IBOutlet weak var daySlider: ValueSlider!
    @IBOutlet weak var nameFieldBlankView: UIView!
    @IBOutlet weak var dismissNameFieldBlankButton: UIButton!
    
// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDateToSave()
        setUpSliderValues()
        setUpViewColors(dateToSave!.type!)
        populateEditableValues()
        setDelegates()
        addLabelsToSliders([yearSlider, monthSlider, daySlider])
        
        yearSlider.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
        monthSlider.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
        daySlider.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
    }
    
    override func viewDidLayoutSubviews() {
        addLabelsToSliders([yearSlider, monthSlider, daySlider])
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        title = setNavBarTitle()
        
        switch dateToSave.type! {
        case "birthday":
            animateButton(birthdayButton)
        case "anniversary":
            animateButton(anniversaryButton)
        case "holiday":
            animateButton(holidayButton)
        default:
            break
        }
    }
    
    @IBAction func dismissWarning(sender: AnyObject) {
        nameFieldBlankView.hidden = true
    }
    
    func setAddressProperties(street: String?, region: String?) {
        self.street = street
        self.region = region
    }
    
    func setUpViewColors(type: String) {
        switch type {
        case "birthday":
            changeColorOfSlidersTo(birthdayColor, sliders: [yearSlider, monthSlider, daySlider])
            editDetailsButton.tintColor = birthdayColor
        case "anniversary":
            changeColorOfSlidersTo(anniversaryColor, sliders: [yearSlider, monthSlider, daySlider])
            editDetailsButton.tintColor = anniversaryColor
        case "holiday":
            changeColorOfSlidersTo(holidayColor, sliders: [yearSlider, monthSlider, daySlider])
            editDetailsButton.tintColor = holidayColor
        default:
            break
        }
    }
    
    func animateButton(button: UIButton) {
        button.titleLabel!.transform = CGAffineTransformScale(button.transform, 0.3, 0.3);
        UIControl.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.Repeat, .Autoreverse, .AllowUserInteraction], animations: { () -> Void in
            button.titleLabel!.transform = CGAffineTransformScale(button.transform, 1, 1);
        }, completion: nil)
    }
    
    func addLabelsToSliders(sliders: [ValueSlider]) {
        for slider in sliders {
            let handleView = slider.subviews.last
            if handleView?.viewWithTag(1) == nil {
                let label = UILabel(frame: handleView!.bounds)
                label.backgroundColor = UIColor.clearColor()
                label.textAlignment = .Center
                label.textColor = UIColor.whiteColor()
                label.text = self.slider(slider, stringForValue: slider.value)
                label.tag = 1
                handleView?.addSubview(label)
            }
        }
    }
    
    func setUpDateToSave() {
        if dateToSave == nil {
            let entity = NSEntityDescription.entityForName("Date", inManagedObjectContext: managedContext!)
            dateToSave = Date(entity: entity!, insertIntoManagedObjectContext: managedContext)
            switch incomingColor! {
            case birthdayColor:
                dateToSave.type = "birthday"
            case anniversaryColor:
                dateToSave.type = "anniversary"
            case holidayColor:
                dateToSave.type = "holiday"
            default:
                break
            }
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditDetails" {
            let editDetailsVC = segue.destinationViewController as! EditDetailsVC
            editDetailsVC.date = dateToSave
            editDetailsVC.managedContext = managedContext
            editDetailsVC.delegate = self
        }
    }
    
// MARK: ACTIONS
    
    @IBAction func birthdayButton(sender: AnyObject) {
        changeColorOfSlidersTo(birthdayColor, sliders: [yearSlider, monthSlider, daySlider])
        editDetailsButton.tintColor = birthdayColor
        anniversaryButton.titleLabel!.layer.removeAllAnimations()
        holidayButton.titleLabel!.layer.removeAllAnimations()
        animateButton(birthdayButton)
        dateToSave.type = "birthday"
    }
    
    @IBAction func anniversaryButton(sender: AnyObject) {
        changeColorOfSlidersTo(anniversaryColor, sliders: [yearSlider, monthSlider, daySlider])
        editDetailsButton.tintColor = anniversaryColor
        birthdayButton.titleLabel!.layer.removeAllAnimations()
        holidayButton.titleLabel!.layer.removeAllAnimations()
        animateButton(anniversaryButton)
        dateToSave.type = "anniversary"
    }
    
    @IBAction func holidayButton(sender: AnyObject) {
        changeColorOfSlidersTo(holidayColor, sliders: [yearSlider, monthSlider, daySlider])
        editDetailsButton.tintColor = holidayColor
        birthdayButton.titleLabel!.layer.removeAllAnimations()
        anniversaryButton.titleLabel!.layer.removeAllAnimations()
        animateButton(holidayButton)
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
        
        if nameField.text?.characters.count == 0 || nameField.text == nil {
            nameFieldBlankView.hidden = false
        } else {
            let dateString = "\(Int(yearSlider.value))-\(Int(monthSlider.value))-\(Int(daySlider.value))"
            let date = NSCalendar.currentCalendar().startOfDayForDate(NSDate(dateString: dateString))
            let equalizedDate = date.formatDateIntoString()

            dateToSave.date = date
            dateToSave.equalizedDate = equalizedDate
            dateToSave.name = nameField.text?.stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
            dateToSave.abbreviatedName = dateToSave.name?.abbreviateName()
            if dateToSave.address == nil {
                let addressEntity = NSEntityDescription.entityForName("Address", inManagedObjectContext: managedContext!)
                let newAddress = Address(entity: addressEntity!, insertIntoManagedObjectContext: managedContext)
                dateToSave.address = newAddress
            }
            dateToSave.address?.street = street
            dateToSave.address?.region = region
            saveContext()
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    func saveContext() {
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
    
    func valueChanged(sender: ValueSlider) {
        let labelToRemove = sender.subviews.last!.subviews.last as! UILabel
        if labelToRemove.text != "" {
            labelToRemove.text = ""
        }
        let toNewValue = round(sender.value)
        sender.setValue(toNewValue, animated: false)
        let sliderLabel = sender.subviews.last?.viewWithTag(1) as! UILabel
        sliderLabel.text = slider(sender, stringForValue: sender.value)
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
        view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        yearSlider.userInteractionEnabled = false
        monthSlider.userInteractionEnabled = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let name = nameField.text!
        dateToSave.name = name
        dateToSave.abbreviatedName = name.abbreviateName()
        yearSlider.userInteractionEnabled = true
        monthSlider.userInteractionEnabled = true
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
