//
//  BackTableVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/7/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import Foundation

class BackTableVC: UITableViewController {
    
    let dateTypeCategories = ["All", "Birthdays", "Anniversaries", "Custom"]
    let dateTypePredicates: [String?] = [nil, "birthday", "anniversary", "custom"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logEvents(forString: "Back Table Shown")
        registerNibCell(withName: "NavigationCell")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func registerNibCell(withName name: String) {
        let navigationCellNib = UINib(nibName: name, bundle: nil)
        tableView.register(navigationCellNib, forCellReuseIdentifier: name)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateTypeCategories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let navigationCell = tableView.dequeueReusableCell(withIdentifier: "NavigationCell", for: indexPath) as! NavigationCell
        
        navigationCell.setIcon(forIndexPath: indexPath)
        navigationCell.navigationTitle.text = dateTypeCategories[(indexPath as NSIndexPath).row]
        navigationCell.navigationTitle.textColor = dateTypeCategories[(indexPath as NSIndexPath).row].associatedColor()
        
        return navigationCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowDatesTableVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedIndex = (self.tableView.indexPathForSelectedRow as NSIndexPath?)?.row else { return }
        self.logEvents(forString: "View \(dateTypeCategories[selectedIndex])")
        
        guard let navigationVC = segue.destination as? UINavigationController else { return }
        guard let datesTableVC = navigationVC.topViewController as? DatesTableVC else { return }
        
        let predicate: NSPredicate? = dateTypePredicates[selectedIndex] != nil ? NSPredicate(format: "type = %@", dateTypePredicates[selectedIndex]!) : nil
        datesTableVC.menuIndexPath = selectedIndex
        datesTableVC.typePredicate = predicate
        datesTableVC.dateTypeForNewDate = dateTypeCategories[selectedIndex]
    }
}
