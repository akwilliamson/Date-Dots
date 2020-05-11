//
//  AddDateVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/5/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

protocol ResetDateDelegate {
    func resetDate(_ date: Date)
}

class AddDateVC: UIViewController {
    
    // MARK: Properties
    
    // Passed from DatesVC for new date
    var managedContext: NSManagedObjectContext?
    var isBeingEdited: Bool!
    
    var dateType: String!
    
    // Additionally passed from DateDetailsViewController for edit date
    var dateToSave: Date?
    
    var street: String?
    var region: String?
    
    let colorForType = ["birthday": DateType.birthday.color, "anniversary": DateType.anniversary.color, "custom": DateType.other.color]
    let months = ["J","F","M","A","M","Jn","Jl","A","S","O","N","D"]
    let fullMonths = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
    let fullDays = ["1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th",
                    "11th","12th","13th","14th","15th","16th","17th","18th","19th","20th",
                    "21st","22nd","23rd","24th","25th","26th","27th","28th","29th","30th","31st"]
    
    // MARK: Outlets

    @IBOutlet weak var nameField: AddNameTextField!
    
    @IBOutlet weak var birthdayButton: TypeButton!
    @IBOutlet weak var anniversaryButton: TypeButton!
    @IBOutlet weak var customButton: TypeButton!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var yearField: UITextField!
    
//    @IBOutlet weak var monthSlider: ValueSlider!
//    @IBOutlet weak var daySlider: ValueSlider!
    
    @IBOutlet weak var editDetailsButton: UIButton!
    
    @IBOutlet weak var minusMonthLabel: UIButton!
    @IBOutlet weak var plusMonthLabel: UIButton!
    @IBOutlet weak var minusDayLabel: UIButton!
    @IBOutlet weak var plusDayLabel: UIButton!
    
// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = addOrEdit()
        
        if let dateToSave = dateToSave {
            setTheme(to: dateToSave.color)
        } else {
            setTheme(to: DateType.birthday.color)
        }
        addColoredArrows()
        
//        setDataSourceFor([monthSlider, daySlider])
//        addTarget(onSliders: [monthSlider, daySlider], forAction: "valueChanged:")
        
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
    
//    func minusMonth(_ sender: UITapGestureRecognizer) {
//        if monthSlider.value > monthSlider.minimumValue {
//            monthSlider.value -= 1
//            monthLabel.text = fullMonths[Int(monthSlider.value)-1]
//        }
//    }
//
//    func plusMonth(_ sender: UITapGestureRecognizer) {
//        if monthSlider.value < monthSlider.maximumValue {
//            monthSlider.value += 1
//            monthLabel.text = fullMonths[Int(monthSlider.value)-1]
//        }
//    }
//
//    func minusDay(_ sender: UITapGestureRecognizer) {
//        if daySlider.value > daySlider.minimumValue {
//            daySlider.value -= 1
//            dayLabel.text = fullDays[Int(daySlider.value)-1]
//        }
//    }
//
//    func plusDay(_ sender: UITapGestureRecognizer) {
//        if daySlider.value < daySlider.maximumValue {
//            daySlider.value += 1
//            dayLabel.text = fullDays[Int(daySlider.value)-1]
//        }
//    }
    
    override func viewDidLayoutSubviews() {
        addLabelOnThumbForSliders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        animateButtonInAndOut(for: dateToSave)
    }
    
    func addOrEdit() -> String {
        return isBeingEdited! == true ? "Edit Date" : "Add Date"
    }
    
    func addImagesToButtons() {
        let birthdayImage = UIImage(named: "balloon.png")?.withRenderingMode(.alwaysTemplate)
        birthdayButton.setImage(birthdayImage, for: UIControl.State())
        birthdayButton.tintColor = DateType.birthday.color
        birthdayButton.layer.borderColor = DateType.birthday.color.cgColor
        
        let anniversaryImage = UIImage(named: "heart.png")?.withRenderingMode(.alwaysTemplate)
        anniversaryButton.setImage(anniversaryImage, for: UIControl.State())
        anniversaryButton.tintColor = DateType.anniversary.color
        anniversaryButton.layer.borderColor = DateType.anniversary.color.cgColor
        
        let customImage = UIImage(named: "calendar.png")?.withRenderingMode(.alwaysTemplate)
        customButton.setImage(customImage, for: UIControl.State())
        customButton.tintColor = DateType.other.color
        customButton.layer.borderColor = DateType.other.color.cgColor
        
        [birthdayButton, anniversaryButton, customButton].forEach({
            $0?.layer.borderWidth = 2
            $0?.adjustsImageWhenHighlighted = false
            $0?.imageEdgeInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        })
    }
    
    func setTheme(to color: UIColor) {
//        [monthSlider, daySlider].forEach { $0!.setColorTo(color) }
        editDetailsButton.tintColor = color
    }
    
    func addColoredArrows() {
        let downArrow = UIImage(named: "down-arrow.png")?.withRenderingMode(.alwaysTemplate)
        let upArrow = UIImage(named: "up-arrow.png")?.withRenderingMode(.alwaysTemplate)
        
        minusMonthLabel.setImage(downArrow, for: UIControl.State())
        minusMonthLabel.tintColor = UIColor.lightGray
        
        plusMonthLabel.setImage(upArrow, for: UIControl.State())
        plusMonthLabel.tintColor = UIColor.lightGray
        
        minusDayLabel.setImage(downArrow, for: UIControl.State())
        minusDayLabel.tintColor = UIColor.lightGray
        
        plusDayLabel.setImage(upArrow, for: UIControl.State())
        plusDayLabel.tintColor = UIColor.lightGray
    }
    
//    func setDataSourceFor(_ sliders: [ASValueTrackingSlider]) {
//        sliders.forEach { $0.dataSource = self }
//    }
    
//    func addTarget(onSliders sliders: [ValueSlider], forAction action: String) {
//        sliders.forEach { $0.addTarget(self, action: Selector(action), for: .valueChanged) }
//    }
    
    func setInitialValues(forDate date: Date?, whether isBeingEdited: Bool) {
        switch isBeingEdited {
        case true:
            if let name = date?.name, let year = date?.date?.year, let month = date?.date?.month, let day = date?.date?.day {
                
//                monthSlider.setValues(max: 12, value: Float(month))
//                daySlider.setValues(max: 31, value: Float(day))
                nameField.text = name
                yearField.text = year != 1604 ? String(year) : nil
                monthLabel.text = fullMonths[month-1]
                dayLabel.text = fullDays[day-1]
            }
        case false:
//            monthSlider.setValues(max: 12, value: 1)
//            daySlider.setValues(max: 31, value: 1)
            monthLabel.text = "Jan"
            dayLabel.text = "1st"
        }
    }
    
    func addLabelOnThumbForSliders() {
//        monthSlider.addLabelOnThumb(withText: "M")
//        daySlider.addLabelOnThumb(withText: "D")
    }
    
    func animateButtonInAndOut(for date: Date?) {
        if let date = date {
            let button = getProperButton(forTypeColor: date.color)
//            button.animateInAndOut()
        }
    }
    
    func getProperButton(forTypeColor typeColor: UIColor) -> TypeButton {
        switch typeColor {
        case DateType.birthday.color:
            return birthdayButton
        case DateType.anniversary.color:
            return anniversaryButton
        case DateType.other.color:
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
            } else {
                showAlertForNoName()
            }
        }
    }
    
    func nameFieldIsPopulated() -> Bool {
        if nameField.text?.count == 0 || nameField.text == nil {
            return false
        } else {
            return true
        }
    }
    
    func setValuesOnDateToSave() {
        
        if dateToSave == nil {
            guard let entity = NSEntityDescription.entity(forEntityName: "Date", in: managedContext!) else { return }
            dateToSave = Date(entity: entity, insertInto: managedContext)
            dateToSave?.type = "birthday"
        }
        
        if let dateToSave = dateToSave {
            dateToSave.name = nameField.text?.trimmingCharacters(in: .whitespaces)
            dateToSave.abbreviatedName = dateToSave.name?.abbreviatedName
//            dateToSave.date = setDateFromValues()
            dateToSave.equalizedDate = dateToSave.date?.formatted("MM/dd")
            
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
    
//    func setDateFromValues() -> Foundation.Date {
//        var dateString = "-\(Int(monthSlider.value))-\(Int(daySlider.value))"
//        if let year = Int(yearField.text!) {
//            dateString = year <= Foundation.Date().year! ? String(year) + dateString : "1604" + dateString
//        } else {
//            dateString = "1604" + dateString
//        }
//        return Calendar.current.startOfDay(for: Foundation.Date(dateString: dateString))
//    }
    
    func showAlertForNoName() {
        let alert = UIAlertController(title: "No Name", message: "Please add a name before continuing", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
// MARK: SELECTORS
    
//    func valueChanged(_ sender: ValueSlider) {
//        if sender == monthSlider {
//            monthLabel.text = fullMonths[Int(sender.value)-1]
//        } else {
//            dayLabel.text = fullDays[Int(sender.value)-1]
//        }
//    }
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
//        monthSlider.isUserInteractionEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        monthSlider.isUserInteractionEnabled = true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return false
    }
}

//extension AddDateVC: ASValueTrackingSliderDataSource {
//
//    func slider(_ slider: ASValueTrackingSlider!, stringForValue value: Float) -> String! {
//        let intValue = Int(value)
//        switch slider {
//        case monthSlider:
//            return months[intValue - 1]
//        case daySlider:
//            return String(intValue)
//        default:
//            return "No String"
//        }
//    }
//}

// MARK: Actions

extension AddDateVC {

    @IBAction func birthdayButton(_ sender: UIButton) {
        [anniversaryButton, customButton].forEach { $0.stopAnimating() }
        dateType = "birthday"
        setTheme(to: DateType.birthday.color)
//        sender.animateInAndOut()
    }
    
    @IBAction func anniversaryButton(_ sender: UIButton) {
        [birthdayButton, customButton].forEach { $0.stopAnimating() }
        dateType = "anniversary"
        setTheme(to: DateType.anniversary.color)
        sender.animateInAndOut()
    }
    
    @IBAction func customButton(_ sender: UIButton) {
        [birthdayButton, anniversaryButton].forEach { $0.stopAnimating() }
        dateType = "custom"
        setTheme(to: DateType.other.color)
        sender.animateInAndOut()
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        if nameFieldIsPopulated() {
            setValuesOnDateToSave()
            managedContext?.trySave(complete: { success in
            })
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            showAlertForNoName()
        }
    }
}
