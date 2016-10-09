//
//  DatesViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/8/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

protocol ReloadDatesTableDelegate {
    func reloadTableView()
}

class DatesViewController: UIViewController {
    
    var menuIndexPath: Int?
    var typePredicate: NSPredicate?
    
    var fetchedDates: [Date?] = []
    var filteredDates: [Date?] = []
    
    var managedContext = CoreDataStack().managedObjectContext
    
    // Search
    var searchController = UISearchController()
    
    var dateTypeForNewDate = "birthday" // nil menu index path defaults to birthday type for add new date segue
    let typeStrings = ["dates", "birthdays", "anniversaries", "custom"]
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Foundation.Date().formatted("MMMM dd")
        logEvents(forString: "Main View")
        tableView.register("DateCell")
        fetchedDates = fetch(dateType: nil)
        
        addSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchedDates = fetch(dateType: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        searchController.isActive = false
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
    
    // MARK: SEGUE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DateDetailsVC" {
            let dateDetailsVC = segue.destination as! DateDetailsVC
            if searchController.isActive == true {
                dateDetailsVC.dateObject = filteredDates[(tableView.indexPathForSelectedRow! as NSIndexPath).row]
            } else {
                dateDetailsVC.dateObject = fetchedDates[(tableView.indexPathForSelectedRow! as NSIndexPath).row]
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
    
    func addSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = UIColor.birthday
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
}

extension DatesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContentFor(searchText: searchText)
        }
    }
    
    func filterContentFor(searchText: String, scope: String = "All") {
        filteredDates = fetchedDates.filter { date in
            date?.name?.lowercased().contains(searchText.lowercased()) ?? false
        }
        tableView.reloadData()
    }
}

extension DatesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredDates.count
        }
        return fetchedDates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! DateCell
        let date = searchController.isActive == true ? filteredDates[indexPath.row] : fetchedDates[indexPath.row]
        
        cell.date = date
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.logEvents(forString: "Swiped to Delete")
            let dateToDelete = fetchedDates[(indexPath as NSIndexPath).row]
            managedContext.delete(dateToDelete!)
            fetchedDates.remove(at: (indexPath as NSIndexPath).row)
            
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
        self.performSegue(withIdentifier: "DateDetailsVC", sender: self)
    }
}

extension DatesViewController: ReloadDatesTableDelegate {
    
    func reloadTableView() {
        fetchedDates = fetch(dateType: nil)
        tableView.reloadData()
    }
    
}
