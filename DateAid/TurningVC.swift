//
//  CalendarVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/26/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CVCalendar
import CoreData

class TurningVC: UIViewController {
    
    var fetchedResults: [Date]?
    var filteredResults: [Date]?
    let managedContext = CoreDataStack().managedObjectContext

    @IBOutlet weak var turningSlider: ValueSlider!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Who's turning..."
        fetchDatesIfNotBeenFetched()
        configureNavigationBar()
        registerDateCellNib()
        turningSlider.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
        turningSlider.setValues(max: 100, value: 1)
        turningSlider.minimumValue = 1
        turningSlider.setColorTo(UIColor.birthdayColor())
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func registerDateCellNib() {
        let dateCellNib = UINib(nibName: "DateCell", bundle: nil)
        tableView.registerNib(dateCellNib, forCellReuseIdentifier: "DateCell")
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
            filteredResults = fetchedResults
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
        return filteredResults!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dateCell = tableView.dequeueReusableCellWithIdentifier("DateCell", forIndexPath: indexPath) as! DateCell
        
        if let results = filteredResults {
            let date = results[indexPath.row]
            if let abbreviatedName = date.abbreviatedName, let readableDate = date.date?.readableDate() {
                dateCell.name = abbreviatedName
                dateCell.date = readableDate
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




