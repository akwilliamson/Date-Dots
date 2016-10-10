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
    
    var fetchedDates: [Date?] = []
    var filteredDates: [Date?] = []
    
    var managedContext = CoreDataStack().managedObjectContext
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Foundation.Date().formatted("MMMM dd")
        logEvents(forString: "Main View")
        tableView.register("DateCell")
        setupSearchController()
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchedDates = fetch(dateType: nil)
    }
    
    func setupSearchController() {
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = UIColor.birthday
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DateDetailsVC" {
            let dateDetailsVC = segue.destination as? DateDetailsVC
            dateDetailsVC?.managedContext = managedContext
            dateDetailsVC?.reloadDatesTableDelegate = self
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            dateDetailsVC?.dateObject = searchController.isActive ? filteredDates[indexPath.row] : fetchedDates[indexPath.row]
        }
        if segue.identifier == "AddDateVC" {
            let addDateVC = segue.destination as! AddDateVC
            addDateVC.isBeingEdited = false
            addDateVC.managedContext = managedContext
            addDateVC.dateType = "birthday"
            addDateVC.reloadDatesTableDelegate = self
        }
    }
}

extension DatesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let searching = searchController.isActive == true && searchController.searchBar.text != ""
        return searching ? filteredDates.count : fetchedDates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! DateCell
        
        let searching = searchController.isActive == true && searchController.searchBar.text != ""
        cell.date = searching ? filteredDates[indexPath.row] : fetchedDates[indexPath.row]
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            guard let date = fetchedDates[indexPath.row] else { return }
            fetchedDates.remove(at: indexPath.row)
            managedContext.delete(date)
            managedContext.trySave()

            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension DatesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "DateDetailsVC", sender: self)
    }
}

extension DatesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text else { return }
        filterContentFor(searchText: searchText)
    }
    
    func filterContentFor(searchText: String, scope: String = "All") {
        
        filteredDates = fetchedDates.filter { date in
            date?.name?.lowercased().contains(searchText.lowercased()) ?? false
        }
        tableView.reloadData()
    }
}

extension DatesViewController: ReloadDatesTableDelegate {
    
    func reloadTableView() {
        fetchedDates = fetch(dateType: nil)
        tableView.reloadData()
    }
}
