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

class AddDateVC: UIViewController {
    
// MARK: PROPERTIES
    
    var managedContext: NSManagedObjectContext?
    var dateToSave: Date!
    var isBeingEdited: Bool!
    var incomingColor: UIColor!
    var street: String?
    var region: String?
    
    var buttonForType: [String: TypeButton]!
    let colorForType = ["birthday": UIColor.birthdayColor(), "anniversary": UIColor.anniversaryColor(), "holiday": UIColor.holidayColor()]
    
    let months = ["J","F","M","A","M","Jn","Jl","A","S","O","N","D"]
    let fullMonths = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
    let fullDays = ["1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th",
                    "11th","12th","13th","14th","15th","16th","17th","18th","19th","20th",
                    "21st","22nd","23rd","24th","25th","26th","27th","28th","29th","30th","31st"]
    
// MARK: OUTLETS

    @IBOutlet weak var nameField: AddNameTextField!
    
    @IBOutlet weak var birthdayButton: TypeButton!
    @IBOutlet weak var anniversaryButton: TypeButton!
    @IBOutlet weak var holidayButton: TypeButton!
    
    @IBOutlet weak var monthSlider: ValueSlider!
    @IBOutlet weak var daySlider: ValueSlider!
    
    @IBOutlet weak var editDetailsButton: UIButton!
    @IBOutlet weak var dismissNameFieldBlankButton: UIButton!
    
    @IBOutlet weak var nameFieldBlankView: UIView!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = addOrEdit()
        buttonForType = ["birthday": birthdayButton, "anniversary": anniversaryButton, "holiday": holidayButton]
        if dateToSave == nil {
            createDateToSaveEntity()
        }
        setInitialValues()
        setUpViewColors(dateToSave!.type!)
        setDataSources()
        addLabelsToSliders([monthSlider, daySlider])
        setMonthAndDayLabelText()
        monthSlider.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
        daySlider.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
    }
    
    override func viewDidLayoutSubviews() {
        addLabelsToSliders([monthSlider, daySlider])
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if let dateType = dateToSave.type {
            animateButton(buttonForType[dateType]!)
        }
    }
    
    func addOrEdit() -> String {
        return isBeingEdited! == true ? "Edit" : "Add"
    }
    
    func createDateToSaveEntity() {
        let entity = NSEntityDescription.entityForName("Date", inManagedObjectContext: managedContext!)
        dateToSave = Date(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        let incomingColorType = colorForType.allKeysForValue(incomingColor).first!
        dateToSave.type = incomingColorType
    }
    
    func setInitialValues() {
        switch isBeingEdited! {
        case true: // <<<<<<<<<< Remember to add year field
            nameField.text = dateToSave!.name
            monthSlider.value = Float(dateToSave!.date!.getMonth())
            daySlider.value = Float(dateToSave!.date!.getDay())
        case false:
            monthSlider.setValues(min: 1, max: 12, value: 1)
            daySlider.setValues(min: 1, max: 31, value: 1)
        }
    }
    
    func setUpViewColors(type: String) {
        monthSlider.setColorTo(colorForType[type]!)
        daySlider.setColorTo(colorForType[type]!)
        editDetailsButton.tintColor = colorForType[type]
    }
    
    func setDataSources() {
        monthSlider.dataSource = self
        daySlider.dataSource = self
    }
    
    func addLabelsToSliders(sliders: [ValueSlider]) {
        for slider in sliders {
            let thumbView = slider.subviews.last
            if thumbView?.viewWithTag(1) == nil {
                let label = UILabel(frame: thumbView!.bounds)
                label.backgroundColor = UIColor.clearColor()
                label.textAlignment = .Center
                label.textColor = UIColor.whiteColor()
                label.tag = 1
                switch slider {
                case monthSlider:
                    label.text = "M"
                case daySlider:
                    label.text = "D"
                default:
                    break
                }
                thumbView?.addSubview(label)
            }
        }
    }
    
    func setMonthAndDayLabelText() {
        monthLabel.text = fullMonths[Int(monthSlider.value)-1]
        dayLabel.text = fullDays[Int(daySlider.value)-1]
    }
    
    func animateButton(button: UIButton) {
        button.titleLabel!.transform = CGAffineTransformScale(button.transform, 0.3, 0.3);
        UIControl.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.Repeat,.Autoreverse,.AllowUserInteraction], animations: { () -> Void in
            button.titleLabel!.transform = CGAffineTransformScale(button.transform, 1, 1);
        }, completion: nil)
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
    
    @IBAction func birthdayButton(sender: UIButton) {
        switchDateTypeAndColorsTo("birthday")
        anniversaryButton.titleLabel!.layer.removeAllAnimations()
        holidayButton.titleLabel!.layer.removeAllAnimations()
        animateButton(sender)
    }
    
    @IBAction func anniversaryButton(sender: UIButton) {
        switchDateTypeAndColorsTo("anniversary")
        birthdayButton.titleLabel!.layer.removeAllAnimations()
        holidayButton.titleLabel!.layer.removeAllAnimations()
        animateButton(sender)
    }
    
    @IBAction func holidayButton(sender: UIButton) {
        switchDateTypeAndColorsTo("holiday")
        birthdayButton.titleLabel!.layer.removeAllAnimations()
        anniversaryButton.titleLabel!.layer.removeAllAnimations()
        animateButton(sender)
    }
    
    @IBAction func dismissWarning(sender: AnyObject) {
        nameFieldBlankView.hidden = true
    }
    
    @IBAction func saveButton(sender: UIBarButtonItem) {
        
        if nameField.text?.characters.count == 0 || nameField.text == nil {
            nameFieldBlankView.hidden = false
        } else {
            let dateString = "2015-\(Int(monthSlider.value))-\(Int(daySlider.value))" // <<<<<<<<<<<<<<<<<<<<<<<< Fix Year value
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
    
    // Action Helpers
    func switchDateTypeAndColorsTo(type: String) {
        dateToSave.type = type
        setUpViewColors(type)
    }
    
    func saveContext() {
        do { try managedContext!.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
// MARK: SELECTORS
    
    func valueChanged(sender: ValueSlider) {
        if sender == monthSlider {
            monthLabel.text = fullMonths[Int(sender.value)-1]
        } else {
            dayLabel.text = fullDays[Int(sender.value)-1]
        }
    }
}

extension AddDateVC: SetAddressDelegate {
    
    func setAddressProperties(street: String?, region: String?) {
        self.street = street
        self.region = region
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
        monthSlider.userInteractionEnabled = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let name = nameField.text!
        dateToSave.name = name
        dateToSave.abbreviatedName = name.abbreviateName()
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
        case monthSlider:
            return months[intValue - 1]
        case daySlider:
            return String(intValue)
        default:
            return "No String"
        }
    }
}
