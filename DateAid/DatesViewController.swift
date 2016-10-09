//
//  DatesViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/8/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

class DatesViewController: UIViewController {
    
    var menuIndexPath: Int?
    var typePredicate: NSPredicate?
    var dates: [Date?] = []
    var managedContext = CoreDataStack().managedObjectContext
    
    // Search
    var filteredResults = [Date]()
    var resultSearchController = UISearchController()
    
    var dateTypeForNewDate = "birthday" // nil menu index path defaults to birthday type for add new date segue
    let typeStrings = ["dates", "birthdays", "anniversaries", "custom"]
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Foundation.Date().formatted("MMMM dd")
        self.logEvents(forString: "Main View")
        dates = fetch(dateType: nil)
        register("DateCell")
        addSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dates = fetch(dateType: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        resultSearchController.isActive = false
    }
    
    func fetch(dateType: DateType?, sort descriptors: [String]? = ["equalizedDate", "name"]) -> [Date?] {
        
        let request: NSFetchRequest<Date> = NSFetchRequest(entityName: "Date")
        
        if let type = dateType?.lowercased {
            request.predicate = NSPredicate(format: "type = %@", type)
        }
        
        var sortDescriptors: [NSSortDescriptor] = []
        descriptors?.forEach { sortDescriptors.append(NSSortDescriptor(key: $0, ascending: true)) }
        request.sortDescriptors = sortDescriptors
        
        let dates = managedContext.tryFetch(request)
        
        return arrange(dates)
    }
    
    func arrange(_ dates: [Date?]) -> [Date?] {
        
        var mutableDates = dates
        
        mutableDates.forEach({
            guard let formattedDate = $0?.equalizedDate else { return }
            if formattedDate < Foundation.Date().formatted("MM/dd") { mutableDates.shift() }
        })
        
        return mutableDates
    }
    
    func addSearchBar() {
        resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.sizeToFit()
        resultSearchController.searchBar.tintColor = UIColor.birthdayColor()
        definesPresentationContext = true
        tableView.tableHeaderView = resultSearchController.searchBar
        tableView.reloadData()
    }
    
    func register(_ cell: String) {
        let nib = UINib(nibName: cell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cell)
    }
    
    func addNoDatesLabel() {
        if resultSearchController.isActive == false {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            if let indexPath = menuIndexPath {
                label.text = "No \(typeStrings[indexPath]) added"
            } else {
                label.text = "No dates found"
            }
            label.font = UIFont(name: "AvenirNext-Bold", size: 25)
            label.textColor = UIColor.lightGray
            label.textAlignment = .center
            label.sizeToFit()
            tableView.backgroundView = label
            tableView.separatorStyle = .none
        }
    }
    
    // MARK: SEGUE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DateDetailsVC" {
            let dateDetailsVC = segue.destination as! DateDetailsVC
            if resultSearchController.isActive == true {
                dateDetailsVC.dateObject = filteredResults[(tableView.indexPathForSelectedRow! as NSIndexPath).row]
            } else {
                dateDetailsVC.dateObject = dates[(tableView.indexPathForSelectedRow! as NSIndexPath).row]
            }
            dateDetailsVC.managedContext = managedContext
            dateDetailsVC.reloadDatesTableDelegate = self
        }
        if segue.identifier == "AddDateVC" {
            let addDateVC = segue.destination as! AddDateVC
            addDateVC.isBeingEdited = false
            addDateVC.managedContext = managedContext
            addDateVC.dateType = dateTypeForNewDate
            addDateVC.reloadDatesTableDelegate = self
        }
    }
}

extension DatesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if resultSearchController.isActive {
            if filteredResults.count == 0 {
                addNoDatesLabel()
            }
            return filteredResults.count
        } else {
            if dates.count == 0 {
                addNoDatesLabel()
            }
            return dates.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dateCell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! DateCell
        
        let date = resultSearchController.isActive == true ? filteredResults[(indexPath as NSIndexPath).row] : dates[(indexPath as NSIndexPath).row]
        
        if let firstName = date?.name?.firstName(), let readableDate = date?.date?.readableDate(), let lastName = date?.name?.lastName() {
            
            if date?.type! == "custom" {
                dateCell.firstName = (date?.name!)!
                dateCell.lastName = ""
            } else {
                
                dateCell.firstName = firstName
                dateCell.lastName = lastName
            }
            dateCell.date = readableDate
        }
        
        dateCell.firstNameLabel.textColor = date?.type?.associatedColor()
        
        return dateCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.logEvents(forString: "Swiped to Delete")
            let dateToDelete = dates[(indexPath as NSIndexPath).row]
            managedContext.delete(dateToDelete!)
            dates.remove(at: (indexPath as NSIndexPath).row)
            
            do { try managedContext.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
    }
}

extension DatesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        resultSearchController.searchBar.isHidden = true
        self.performSegue(withIdentifier: "DateDetailsVC", sender: self)
    }
}

extension DatesViewController: ReloadDatesTableDelegate {
    
    func reloadTableView() {
        dates = fetch(dateType: nil)
        tableView.reloadData()
    }
    
}

extension DatesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredResults.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "name CONTAINS %@", searchController.searchBar.text!)
        let array = (dates as NSArray).filtered(using: searchPredicate)
        filteredResults = array as! [Date]
        tableView.reloadData()
    }
    
}
