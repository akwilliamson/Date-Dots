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
    @IBOutlet weak var downArrow: UIButton!
    @IBOutlet weak var upArrow: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Who's turning 1?"
        self.logEvents(forString: "Turning VC")
        registerDateCellNib()
        fetchDatesIfNotBeenFetched()
        addColoredArrows()
        turningSlider.addTarget(self, action: #selector(TurningVC.valueChanged(_:)), for: .valueChanged)
        turningSlider.setValues(max: 100, value: 1)
        turningSlider.minimumValue = 1
        turningSlider.setColorTo(UIColor.birthdayColor())
        filteredResults = fetchedResults?.filter({ $0.date!.ageTurning() == 1 })
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.addTapGestureRecognizer(onView: downArrow, forAction: "minusDay:")
        self.addTapGestureRecognizer(onView: upArrow, forAction: "plusDay:")
    }
    
    func addColoredArrows() {
        let downArrowImage = UIImage(named: "down-arrow.png")?.withRenderingMode(.alwaysTemplate)
        let upArrowImage = UIImage(named: "up-arrow.png")?.withRenderingMode(.alwaysTemplate)
        
        downArrow.setImage(downArrowImage, for: UIControlState())
        downArrow.tintColor = UIColor.lightGray
        
        upArrow.setImage(upArrowImage, for: UIControlState())
        upArrow.tintColor = UIColor.lightGray
    }
    
    func addTapGestureRecognizer(onView view: UIView, forAction action: String) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(action))
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func minusDay(_ sender: UITapGestureRecognizer) {
        if turningSlider.value > turningSlider.minimumValue {
            turningSlider.value -= 1
            title = "Who's turning \(Int(turningSlider.value))?"
            filteredResults?.removeAll()
            filteredResults = fetchedResults?.filter({ $0.date!.ageTurning() == Int(turningSlider.value) })
            tableView.reloadData()
        }
    }
    
    func plusDay(_ sender: UITapGestureRecognizer) {
        if turningSlider.value < turningSlider.maximumValue {
            turningSlider.value += 1
            title = "Who's turning \(Int(turningSlider.value))?"
            filteredResults?.removeAll()
            filteredResults = fetchedResults?.filter({ $0.date!.ageTurning() == Int(turningSlider.value) })
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDatesIfNotBeenFetched()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func registerDateCellNib() {
        let dateCellNib = UINib(nibName: "DateCell", bundle: nil)
        tableView.register(dateCellNib, forCellReuseIdentifier: "DateCell")
    }
    
    func addNoDatesLabel(thereAreNoDates: Bool) {
        if thereAreNoDates == true {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            label.text = "Nobody"
            label.font = UIFont(name: "AvenirNext-Bold", size: 25)
            label.textColor = UIColor.lightGray
            label.textAlignment = .center
            label.sizeToFit()
            tableView.backgroundView = label
        } else {
            tableView.backgroundView = nil
        }
    }
    
    func fetchDatesIfNotBeenFetched() {
        let fetchRequest = NSFetchRequest(entityName: "Date")
        
        let datesInOrder = NSSortDescriptor(key: "equalizedDate", ascending: true)
        let namesInOrder = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [datesInOrder, namesInOrder]
        
        do { fetchedResults = try managedContext.fetch(fetchRequest) as? [Date]
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func valueChanged(_ sender: ValueSlider) {
        sender.value = round(sender.value)
        title = "Who's turning \(Int(sender.value))?"
        filteredResults?.removeAll()
        filteredResults = fetchedResults?.filter({ $0.date!.ageTurning() == Int(sender.value) })
        tableView.reloadData()
    }
    
    
}

extension TurningVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredResults?.count == 0 {
            addNoDatesLabel(thereAreNoDates: true)
        } else {
            addNoDatesLabel(thereAreNoDates: false)
        }
        return filteredResults!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateCell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! DateCell
        
        if let results = filteredResults {
            let date = results[(indexPath as NSIndexPath).row]
            if let firstName = date.name?.firstName(), let readableDate = date.date?.readableDate(), let lastName = date.name?.lastName() {
                dateCell.firstName = firstName
                dateCell.lastName = lastName
                dateCell.date = readableDate
                dateCell.firstNameLabel.textColor = date.type?.associatedColor()
            }
        }
        dateCell.selectionStyle = .none
        return dateCell
    }
}

extension TurningVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}




