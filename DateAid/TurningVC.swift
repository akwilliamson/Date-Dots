//
//  CalendarVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/26/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

class TurningVC: UIViewController {
    
    var fetchedResults: [Date]?
    var filteredResults: [Date]?
    let managedContext = CoreDataStack().managedObjectContext
    let colorForType = ["birthday": UIColor.birthdayColor(), "anniversary": UIColor.anniversaryColor(), "custom": UIColor.customColor()]

    @IBOutlet weak var turningSlider: ValueSlider!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Flurry.logEvent("Turning VC")
        AppAnalytics.logEvent("Turning VC")
        title = "Who's turning 1?"
        fetchDatesIfNotBeenFetched()
        configureNavigationBar()
        registerDateCellNib()
        turningSlider.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
        turningSlider.setValues(max: 100, value: 1)
        turningSlider.minimumValue = 1
        turningSlider.setColorTo(UIColor.birthdayColor())
        filteredResults = fetchedResults?.filter({ $0.date!.ageTurning() == 1 })
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchDatesIfNotBeenFetched()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func registerDateCellNib() {
        let dateCellNib = UINib(nibName: "DateCell", bundle: nil)
        tableView.registerNib(dateCellNib, forCellReuseIdentifier: "DateCell")
    }
    
    func addNoDatesLabel(thereAreNoDates thereAreNoDates: Bool) {
        if thereAreNoDates == true {
            let label = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height))
            label.text = "Nobody"
            label.font = UIFont(name: "AvenirNext-Bold", size: 25)
            label.textColor = UIColor.lightGrayColor()
            label.textAlignment = .Center
            label.sizeToFit()
            tableView.backgroundView = label
        } else {
            tableView.backgroundView = nil
        }
    }
    
    func configureNavigationBar() {
        if let navBar = navigationController?.navigationBar {
            navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "AvenirNext-Bold", size: 23)!]
            navBar.barTintColor = UIColor.birthdayColor()
            navBar.tintColor = UIColor.whiteColor()
        }
    }
    
    func fetchDatesIfNotBeenFetched() {
        let fetchRequest = NSFetchRequest(entityName: "Date")
        
        let datesInOrder = NSSortDescriptor(key: "equalizedDate", ascending: true)
        let namesInOrder = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [datesInOrder, namesInOrder]
        
        do { fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [Date]
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func valueChanged(sender: ValueSlider) {
        sender.value = round(sender.value)
        title = "Who's turning \(Int(sender.value))?"
        filteredResults?.removeAll()
        filteredResults = fetchedResults?.filter({ $0.date!.ageTurning() == Int(sender.value) })
        
        tableView.reloadData()
    }
    
    
}

extension TurningVC: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredResults!.count == 0 {
            addNoDatesLabel(thereAreNoDates: true)
        } else {
            addNoDatesLabel(thereAreNoDates: false)
        }
        return filteredResults!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dateCell = tableView.dequeueReusableCellWithIdentifier("DateCell", forIndexPath: indexPath) as! DateCell
        
        if let results = filteredResults {
            let date = results[indexPath.row]
            if let abbreviatedName = date.abbreviatedName, let readableDate = date.date?.readableDate() {
                dateCell.firstName = date.type! == "birthday" ? abbreviatedName : date.name!
                dateCell.date = readableDate
                
                if let dateType = date.type {
                    dateCell.firstNameLabel.textColor = colorForType[dateType]
                }
            }
        }
        return dateCell
    }
}

extension TurningVC: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
}




