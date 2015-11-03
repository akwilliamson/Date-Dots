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

protocol ResetDateDelegate {
    func resetDate(date: Date)
}

class AddDateVC: UIViewController {
    
// MARK: PROPERTIES
    
    // Passed from DatesTableVC for new date
    var managedContext: NSManagedObjectContext?
    var isBeingEdited: Bool!
    var incomingColor: UIColor!
    
    // Additionally passed from DateDetailsVC for edit date
    var dateToSave: Date!
    var notificationDelegate: SetNotificationDelegate?
    
    
    var street: String?
    var region: String?
    var buttonForType: [String: TypeButton]!
    
    let colorForType = ["birthday": UIColor.birthdayColor(), "anniversary": UIColor.anniversaryColor(), "custom": UIColor.customColor()]
    let months = ["J","F","M","A","M","Jn","Jl","A","S","O","N","D"]
    let fullMonths = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
    let fullDays = ["1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th",
                    "11th","12th","13th","14th","15th","16th","17th","18th","19th","20th",
                    "21st","22nd","23rd","24th","25th","26th","27th","28th","29th","30th","31st"]
    
// MARK: OUTLETS

    @IBOutlet weak var nameField: AddNameTextField!
    
    @IBOutlet weak var birthdayButton: TypeButton!
    @IBOutlet weak var anniversaryButton: TypeButton!
    @IBOutlet weak var customButton: TypeButton!
    
    @IBOutlet weak var monthSlider: ValueSlider!
    @IBOutlet weak var daySlider: ValueSlider!
    
    @IBOutlet weak var editDetailsButton: UIButton!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var yearField: UITextField!
    
// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = addOrEdit()
        createDateToSaveIfThereIsNo(dateToSave)
        setInitialValuesWhether(isBeingEdited)
        setButtonAndSliderColors()
        addValueChangedTargetOn([monthSlider, daySlider])
        setDataSourceFor([monthSlider, daySlider])
        
        buttonForType = ["birthday": birthdayButton, "anniversary": anniversaryButton, "custom": customButton]
    }
    
    override func viewDidLayoutSubviews() {
        addLabelOnThumbForSliders()
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
    
    func createDateToSaveIfThereIsNo(date: Date?) {
        if dateToSave == nil {
            let incomingColorType = colorForType.allKeysForValue(incomingColor).first!
            
            let entity = NSEntityDescription.entityForName("Date", inManagedObjectContext: managedContext!)
            dateToSave = Date(entity: entity!, insertIntoManagedObjectContext: managedContext)
            dateToSave.type = incomingColorType
        }
    }
    
    func addValueChangedTargetOn(sliders: [ValueSlider]) {
        sliders.forEach { $0.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged) }
    }
    
    func setInitialValuesWhether(isBeingEdited: Bool) {
        
        switch isBeingEdited {
        case true:
            if let name = dateToSave.name, let year = dateToSave.date?.getYear(), let month = dateToSave.date?.getMonth(), let day = dateToSave.date?.getDay() {
                nameField.text = name
                monthLabel.text = fullMonths[month-1]
                dayLabel.text = fullDays[day-1]
                yearField.text = year != 1604 ? String(year) : nil
                monthSlider.setValues(max: 12, value: Float(month))
                daySlider.setValues(max: 31, value: Float(day))
            }
        case false:
            monthSlider.setValues(max: 12, value: 1)
            daySlider.setValues(max: 31, value: 1)
            monthLabel.text = fullMonths[Int(monthSlider.value)-1]
            dayLabel.text = fullDays[Int(daySlider.value)-1]
        }
        monthSlider.minimumValue = 1
        daySlider.minimumValue = 1
    }
    
    func setButtonAndSliderColors() {
        if let color = colorForType[dateToSave!.type!] {
            [monthSlider, daySlider].forEach { $0.setColorTo(color) }
            editDetailsButton.tintColor = color
        }
    }
    
    func addLabelOnThumbForSliders() {
            monthSlider.addLabel("month")
            daySlider.addLabel("day")
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
            if nameFieldIsPopulated() {
                setValuesOnDateToSave()
                editDetailsVC.dateObject = dateToSave
                editDetailsVC.managedContext = managedContext
                editDetailsVC.addressDelegate = self
                editDetailsVC.notificationDelegate = notificationDelegate
            } else {
                showAlertForNoName()
            }
        }
    }
    
    func nameFieldIsPopulated() -> Bool {
        if nameField.text?.characters.count == 0 || nameField.text == nil {
            return false
        } else {
            return true
        }
    }
    
    func showAlertForNoName() {
        let alert = UIAlertController(title: "No Name", message: "Please add a name before continuing", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func setDateFromValues() -> NSDate {
        var dateString = "-\(Int(monthSlider.value))-\(Int(daySlider.value))"
        if let year = Int(yearField.text!) {
            dateString = year <= NSDate().getYear() ? String(year) + dateString : "1604" + dateString
        } else {
            dateString = "1604" + dateString
        }
        return NSCalendar.currentCalendar().startOfDayForDate(NSDate(dateString: dateString))
    }
    
    // Action Helpers
    func switchDateTypeAndColorsTo(type: String) {
        dateToSave.type = type
        setButtonAndSliderColors()
    }
    
    func setValuesOnDateToSave() {
        dateToSave.name = nameField.text?.stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
        dateToSave.abbreviatedName = dateToSave.name?.abbreviateName()
        dateToSave.date = setDateFromValues()
        dateToSave.equalizedDate = dateToSave.date?.formatDateIntoString()
        
        if dateToSave.address == nil {
            let addressEntity = NSEntityDescription.entityForName("Address", inManagedObjectContext: managedContext!)
            let newAddress = Address(entity: addressEntity!, insertIntoManagedObjectContext: managedContext)
            dateToSave.address = newAddress
        }
        dateToSave.address?.street = street
        dateToSave.address?.region = region
    }
    
    func saveContext() {
        do { try managedContext!.save()
        } catch let error as NSError {
            print(error.localizedDescription)
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

extension AddDateVC: ResetDateDelegate {
    
    func resetDate(date: Date) {
        self.dateToSave = date
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
    
    func setDataSourceFor(sliders: [ASValueTrackingSlider]) {
        sliders.forEach { $0.dataSource = self }
    }
    
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

// MARK: Actions

extension AddDateVC {

    @IBAction func birthdayButton(sender: UIButton) {
        switchDateTypeAndColorsTo("birthday")
        [anniversaryButton, customButton].forEach { $0.titleLabel!.layer.removeAllAnimations() }
        animateButton(sender)
    }
    
    @IBAction func anniversaryButton(sender: UIButton) {
        switchDateTypeAndColorsTo("anniversary")
        [birthdayButton, customButton].forEach { $0.titleLabel!.layer.removeAllAnimations() }
        animateButton(sender)
    }
    
    @IBAction func customButton(sender: UIButton) {
        switchDateTypeAndColorsTo("custom")
        [birthdayButton, anniversaryButton].forEach { $0.titleLabel!.layer.removeAllAnimations() }
        animateButton(sender)
    }
    
    @IBAction func saveButton(sender: UIBarButtonItem) {
        
        if nameFieldIsPopulated() {
            setValuesOnDateToSave()
            saveContext()
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            showAlertForNoName()
        }
    }
    
}
