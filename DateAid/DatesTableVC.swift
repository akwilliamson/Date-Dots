//
//  DatesTableVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/7/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData



protocol ReloadDatesTableDelegate {
    func reloadTableView()
}

class DatesTableVC: UITableViewController {
    
// MARK: PROPERTIES
    
    var menuIndexPath: Int?
    var typePredicate: NSPredicate?
    var fetchedResults: [Date]?
    var managedContext = CoreDataStack().managedObjectContext
    var sidebarMenuOpen: Bool?
    
    // Search
    var filteredResults = [Date]()
    var resultSearchController = UISearchController()
    
    var dateTypeForNewDate = "birthday" // nil menu index path defaults to birthday type for add new date segue
    let typeStrings = ["dates", "birthdays", "anniversaries", "custom"]
    
// MARK: OUTLETS
    
    @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!
    
// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logEvents(forString: "Main View")
        setAndPerformFetchRequest()
        registerNibCell(withName: "DateCell")
        addRevealVCGestureRecognizers()
        configureNavigationBar()
        addSearchBar()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSearchBar()
        setAndPerformFetchRequest()
        
        for item in tabBarController!.tabBar.items! {
            if let image = item.image {
                item.image = image.imageWithColor(UIColor.white).withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        resultSearchController.isActive = false
        super.viewWillDisappear(true)
    }
    
// MARK: HELPERS
    
    func setAndPerformFetchRequest() {
        let datesFetch: NSFetchRequest<Date> = NSFetchRequest(entityName: "Date")
        let datesInOrder = NSSortDescriptor(key: "equalizedDate", ascending: true)
        let namesInOrder = NSSortDescriptor(key: "name", ascending: true)
        datesFetch.sortDescriptors = [datesInOrder, namesInOrder]
        datesFetch.predicate = typePredicate
        
        do { fetchedResults = try managedContext.fetch(datesFetch)
            
            if fetchedResults!.count > 0 {
                for date in fetchedResults! {
                    if date.equalizedDate! < Foundation.Date().formatted {
                        fetchedResults!.remove(at: 0)
                        fetchedResults!.append(date)
                    }
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
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
    
    func addRevealVCGestureRecognizers() {
        revealViewController().panGestureRecognizer()
        revealViewController().tapGestureRecognizer()
        revealViewController().delegate = self
    }
    
    func registerNibCell(withName name: String) {
        let dateCellNib = UINib(nibName: name, bundle: nil)
        tableView.register(dateCellNib, forCellReuseIdentifier: name)
    }
    
    func configureNavigationBar() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        title = formatter.string(from: Foundation.Date())
        menuBarButtonItem.target = self.revealViewController()
        menuBarButtonItem.action = #selector(SWRevealViewController.revealToggle(_:))
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
                dateDetailsVC.dateObject = fetchedResults![(tableView.indexPathForSelectedRow! as NSIndexPath).row]
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

extension DatesTableVC { // UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if resultSearchController.isActive {
            if filteredResults.count == 0 {
                addNoDatesLabel()
            }
            return filteredResults.count
        } else {
            if fetchedResults!.count == 0 {
                addNoDatesLabel()
            }
            return fetchedResults!.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateCell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! DateCell
        
        let date = resultSearchController.isActive == true ? filteredResults[(indexPath as NSIndexPath).row] : fetchedResults![(indexPath as NSIndexPath).row]
        
        if let firstName = date.name?.firstName(), let readableDate = date.date?.readableDate(), let lastName = date.name?.lastName() {
            if date.type! == "custom" {
                dateCell.firstName = date.name!
                dateCell.lastName = ""
            } else {
                dateCell.firstName = firstName
                dateCell.lastName = lastName
            }
            dateCell.date = readableDate
        }
        
        dateCell.firstNameLabel.textColor = date.type?.associatedColor()
        
        return dateCell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.logEvents(forString: "Swiped to Delete")
            let dateToDelete = fetchedResults![(indexPath as NSIndexPath).row]
            managedContext.delete(dateToDelete)
            fetchedResults?.remove(at: (indexPath as NSIndexPath).row)
            
            do { try managedContext.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
    }
}

extension DatesTableVC { // UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return sidebarMenuOpen == true ? nil : indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        resultSearchController.searchBar.isHidden = true
        self.performSegue(withIdentifier: "DateDetailsVC", sender: self)
    }
}

extension DatesTableVC: ReloadDatesTableDelegate {

    func reloadTableView() {
        setAndPerformFetchRequest()
        tableView.reloadData()
    }
    
}

extension DatesTableVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredResults.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "name CONTAINS %@", searchController.searchBar.text!)
        let array = (fetchedResults! as NSArray).filtered(using: searchPredicate)
        filteredResults = array as! [Date]
        tableView.reloadData()
    }
    
}

extension DatesTableVC: SWRevealViewControllerDelegate {

    func revealController(_ revealController: SWRevealViewController!,  willMoveTo position: FrontViewPosition) {
        if position == .left {
             self.view.isUserInteractionEnabled = true
            sidebarMenuOpen = false
        } else {
             self.view.isUserInteractionEnabled = false
            sidebarMenuOpen = true
        }
    }

}
