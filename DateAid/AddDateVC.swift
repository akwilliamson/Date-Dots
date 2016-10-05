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
    func repopulateAddressFor(dateObject date: Date)
}

protocol ResetDateDelegate {
    func resetDate(_ date: Date)
}

class AddDateVC: UIViewController {
    
// MARK: PROPERTIES
    
    // Passed from DatesTableVC for new date
    var managedContext: NSManagedObjectContext?
    var isBeingEdited: Bool!
    var reloadDatesTableDelegate: ReloadDatesTableDelegate?
    
    var dateType: String!
    
    // Additionally passed from DateDetailsVC for edit date
    var dateToSave: Date?
    var notificationDelegate: SetNotificationDelegate?
    
    var street: String?
    var region: String?
    
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
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var yearField: UITextField!
    
    @IBOutlet weak var monthSlider: ValueSlider!
    @IBOutlet weak var daySlider: ValueSlider!
    
    @IBOutlet weak var editDetailsButton: UIButton!
    
    @IBOutlet weak var minusMonthLabel: UIButton!
    @IBOutlet weak var plusMonthLabel: UIButton!
    @IBOutlet weak var minusDayLabel: UIButton!
    @IBOutlet weak var plusDayLabel: UIButton!
    
// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logEvents(forString: "View Add Date")
        title = addOrEdit()
        
        setColorTheme(forDateType: dateToSave?.type)
        addColoredArrows()
        
        setDataSourceFor([monthSlider, daySlider])
        addTarget(onSliders: [monthSlider, daySlider], forAction: "valueChanged:")
        
        setInitialValues(forDate: dateToSave, whether: isBeingEdited)
        addImagesToButtons()
        addGestureRecognizers()
    }
    
    func addGestureRecognizers() {
        self.addTapGestureRecognizer(onView: minusMonthLabel, forAction: "minusMonth:")
        self.addTapGestureRecognizer(onView: plusMonthLabel, forAction: "plusMonth:")
        self.addTapGestureRecognizer(onView: minusDayLabel, forAction: "minusDay:")
        self.addTapGestureRecognizer(onView: plusDayLabel, forAction: "plusDay:")
    }
    
    func addTapGestureRecognizer(onView view: UIView, forAction action: String) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(action))
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func minusMonth(_ sender: UITapGestureRecognizer) {
        if monthSlider.value > monthSlider.minimumValue {
            monthSlider.value -= 1
            monthLabel.text = fullMonths[Int(monthSlider.value)-1]
        }
    }
    
    func plusMonth(_ sender: UITapGestureRecognizer) {
        if monthSlider.value < monthSlider.maximumValue {
            monthSlider.value += 1
            monthLabel.text = fullMonths[Int(monthSlider.value)-1]
        }
    }
    
    func minusDay(_ sender: UITapGestureRecognizer) {
        if daySlider.value > daySlider.minimumValue {
            daySlider.value -= 1
            dayLabel.text = fullDays[Int(daySlider.value)-1]
        }
    }
    
    func plusDay(_ sender: UITapGestureRecognizer) {
        if daySlider.value < daySlider.maximumValue {
            daySlider.value += 1
            dayLabel.text = fullDays[Int(daySlider.value)-1]
        }
    }
    
    override func viewDidLayoutSubviews() {
        addLabelOnThumbForSliders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        animateButtonInAndOut(forDateType: dateToSave?.type)
    }
    
    func addOrEdit() -> String {
        return isBeingEdited! == true ? "Edit Date" : "Add Date"
    }
    
    func addImagesToButtons() {
        let birthdayImage = UIImage(named: "balloon.png")?.withRenderingMode(.alwaysTemplate)
        birthdayButton.setImage(birthdayImage, for: UIControlState())
        birthdayButton.tintColor = UIColor.birthdayColor()
        birthdayButton.layer.borderColor = UIColor.birthdayColor().cgColor
        
        let anniversaryImage = UIImage(named: "heart.png")?.withRenderingMode(.alwaysTemplate)
        anniversaryButton.setImage(anniversaryImage, for: UIControlState())
        anniversaryButton.tintColor = UIColor.anniversaryColor()
        anniversaryButton.layer.borderColor = UIColor.anniversaryColor().cgColor
        
        let customImage = UIImage(named: "calendar.png")?.withRenderingMode(.alwaysTemplate)
        customButton.setImage(customImage, for: UIControlState())
        customButton.tintColor = UIColor.customColor()
        customButton.layer.borderColor = UIColor.customColor().cgColor
        
        [birthdayButton, anniversaryButton, customButton].forEach({
            $0?.layer.borderWidth = 2
            $0?.adjustsImageWhenHighlighted = false
            $0?.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        })
    }
    
    func setColorTheme(forDateType dateType: String?) {
        if let typeColor = dateType != nil ? dateType?.associatedColor() : dateType?.associatedColor() {
            [monthSlider, daySlider].forEach { $0!.setColorTo(typeColor) }
            editDetailsButton.tintColor = typeColor
        }
    }
    
    func addColoredArrows() {
        let downArrow = UIImage(named: "down-arrow.png")?.withRenderingMode(.alwaysTemplate)
        let upArrow = UIImage(named: "up-arrow.png")?.withRenderingMode(.alwaysTemplate)
        
        minusMonthLabel.setImage(downArrow, for: UIControlState())
        minusMonthLabel.tintColor = UIColor.lightGray
        
        plusMonthLabel.setImage(upArrow, for: UIControlState())
        plusMonthLabel.tintColor = UIColor.lightGray
        
        minusDayLabel.setImage(downArrow, for: UIControlState())
        minusDayLabel.tintColor = UIColor.lightGray
        
        plusDayLabel.setImage(upArrow, for: UIControlState())
        plusDayLabel.tintColor = UIColor.lightGray
    }
    
    func setDataSourceFor(_ sliders: [ASValueTrackingSlider]) {
        sliders.forEach { $0.dataSource = self }
    }
    
    func addTarget(onSliders sliders: [ValueSlider], forAction action: String) {
        sliders.forEach { $0.addTarget(self, action: Selector(action), for: .valueChanged) }
    }
    
    func setInitialValues(forDate date: Date?, whether isBeingEdited: Bool) {
        switch isBeingEdited {
        case true:
            if let name = date?.name, let year = date?.date?.getYear(), let month = date?.date?.getMonth(), let day = date?.date?.getDay() {
                
                monthSlider.setValues(max: 12, value: Float(month))
                daySlider.setValues(max: 31, value: Float(day))
                nameField.text = name
                yearField.text = year != 1604 ? String(year) : nil
                monthLabel.text = fullMonths[month-1]
                dayLabel.text = fullDays[day-1]
            }
        case false:
            monthSlider.setValues(max: 12, value: 1)
            daySlider.setValues(max: 31, value: 1)
            monthLabel.text = "Jan"
            dayLabel.text = "1st"
        }
    }
    
    func addLabelOnThumbForSliders() {
        monthSlider.addLabelOnThumb(withText: "M")
        daySlider.addLabelOnThumb(withText: "D")
    }
    
    func animateButtonInAndOut(forDateType dateType: String?) {
        if let typeColor = dateType != nil ? dateType?.associatedColor() : UIColor.birthdayColor() {
            let button = getProperButton(forTypeColor: typeColor)
            button.animateInAndOut()
        }
    }
    
    func getProperButton(forTypeColor typeColor: UIColor) -> TypeButton {
        switch typeColor {
        case UIColor.birthdayColor():
            return birthdayButton
        case UIColor.anniversaryColor():
            return anniversaryButton
        case UIColor.customColor():
            return customButton
        default:
            return customButton
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditDetails" {
            let editDetailsVC = segue.destination as! EditDetailsVC
            if nameFieldIsPopulated() {
                setValuesOnDateToSave()
                editDetailsVC.dateObject = dateToSave
                editDetailsVC.managedContext = managedContext
                editDetailsVC.addressDelegate = self
                editDetailsVC.notificationDelegate = notificationDelegate
                editDetailsVC.reloadDatesTableDelegate = reloadDatesTableDelegate
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
    
    func setValuesOnDateToSave() {
        
        if dateToSave == nil {
            guard let entity = NSEntityDescription.entity(forEntityName: "Date", in: managedContext!) else { return }
            dateToSave = Date(entity: entity, insertInto: managedContext)
            
            let typeForIncomingColor = colorForType.allKeysForValue(dateType.associatedColor()).first!
            dateToSave?.type = typeForIncomingColor
        }
        
        if let dateToSave = dateToSave {
            dateToSave.name = nameField.text?.trimmingCharacters(in: .whitespaces)
            dateToSave.abbreviatedName = dateToSave.name?.abbreviatedName()
            dateToSave.date = setDateFromValues()
            dateToSave.equalizedDate = dateToSave.date?.formatted
            
            if dateToSave.address == nil {
                guard let addressEntity = NSEntityDescription.entity(forEntityName: "Address", in: managedContext!) else { return }
                let newAddress = Address(entity: addressEntity, insertInto: managedContext)
                dateToSave.address = newAddress
            }
            if let street = street {
                dateToSave.address?.street = street
            }
            if let region = region {
                dateToSave.address?.region = region
            }
        }
        
    }
    
    func setDateFromValues() -> Foundation.Date {
        var dateString = "-\(Int(monthSlider.value))-\(Int(daySlider.value))"
        if let year = Int(yearField.text!) {
            dateString = year <= Foundation.Date().getYear() ? String(year) + dateString : "1604" + dateString
        } else {
            dateString = "1604" + dateString
        }
        return Calendar.current.startOfDay(for: Foundation.Date(dateString: dateString))
    }
    
    func showAlertForNoName() {
        let alert = UIAlertController(title: "No Name", message: "Please add a name before continuing", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
// MARK: SELECTORS
    
    func valueChanged(_ sender: ValueSlider) {
        if sender == monthSlider {
            monthLabel.text = fullMonths[Int(sender.value)-1]
        } else {
            dayLabel.text = fullDays[Int(sender.value)-1]
        }
    }
}

extension AddDateVC: SetAddressDelegate {
    
    func repopulateAddressFor(dateObject date: Date) {
        self.street = date.address?.street
        self.region = date.address?.region
    }

}

extension AddDateVC: ResetDateDelegate {
    
    func resetDate(_ date: Date) {
        self.dateToSave = date
    }
}

extension AddDateVC: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        monthSlider.isUserInteractionEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        monthSlider.isUserInteractionEnabled = true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return false
    }
}

extension AddDateVC: ASValueTrackingSliderDataSource {
    
    func slider(_ slider: ASValueTrackingSlider!, stringForValue value: Float) -> String! {
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

    @IBAction func birthdayButton(_ sender: UIButton) {
        [anniversaryButton, customButton].forEach { $0.stopAnimating() }
        switchDateTypeAndColorsTo("birthday")
        sender.animateInAndOut()
    }
    
    @IBAction func anniversaryButton(_ sender: UIButton) {
        [birthdayButton, customButton].forEach { $0.stopAnimating() }
        switchDateTypeAndColorsTo("anniversary")
        sender.animateInAndOut()
    }
    
    @IBAction func customButton(_ sender: UIButton) {
        [birthdayButton, anniversaryButton].forEach { $0.stopAnimating() }
        switchDateTypeAndColorsTo("custom")
        sender.animateInAndOut()
    }
    
    func switchDateTypeAndColorsTo(_ type: String) {
        dateType = type
        setColorTheme(forDateType: type)
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        self.logEvents(forString: "Save Date on AddDateVC")
        if nameFieldIsPopulated() {
            setValuesOnDateToSave()
            managedContext?.trySave()
            reloadDatesTableDelegate?.reloadTableView()
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            showAlertForNoName()
        }
    }
}
