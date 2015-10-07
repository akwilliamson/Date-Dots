//
//  DateDetailsVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/23/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

class DateDetailsVC: UIViewController {
    
// MARK: PROPERTIES

    var date: Date!

// MARK: OUTLETS
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var daysUntilLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureFormattedDate()
        configureDaysUntil()
        configureAge()
    }
    
// MARK: MEMORY
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning in DateDetailsVC")
    }
    
// MARK: ACTIONS
    
    @IBAction func editDate(sender: AnyObject) {
    }
    
// MARK: SEGUE
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let addDateVC = segue.destinationViewController as! AddDateVC
        addDateVC.type = date.type
        addDateVC.name = date.name
        addDateVC.date = date.date
        addDateVC.editingDate = true
    }
    
// MARK: HELPERS
    
    func configureNavBar() {
        self.title = abbreviateName(date.name)
    }
    
    func configureFormattedDate() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        let dateString = dateFormatter.stringFromDate(date.date)
        dateLabel.text = dateString
    }
    
    func configureDaysUntil() {
        let numberOfDays = date.date.daysBetween()
        daysUntilLabel.text = "\(numberOfDays) days away"
    }
    
    func configureAge() {
        ageLabel.text = "turning \(date.date.ageTurning())"
    }
    
    func abbreviateName(name: String) -> String {
        return name.containsString(" ") ? name[0...((name as NSString).rangeOfString(" ").location + 1)] : (name as String)
    }
}