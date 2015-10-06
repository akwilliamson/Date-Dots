//
//  AddDateViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/5/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit

class AddDateViewController: UIViewController {

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning in AddDateVC")
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
        yearLabel.text = String(round(sender.value))
    }
    
    @IBAction func monthSlider(sender: UISlider) {
        monthLabel.text = String(round(sender.value))
    }
    
    @IBAction func daySlider(sender: UISlider) {
        dayLabel.text = String(round(sender.value))
    }
    
}
