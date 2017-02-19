//
//  DatesPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/22/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

class DatesPresenter {

    weak var wireframe: DatesWireframe?
    weak var view: DatesViewOutputting?
    var interactor: DatesInteractorInputting?
    
    var title: String = "Dates"
    var cellId: String = Constant.CellId.dateCell.value
    var filterValues: [FilterDateType] = [.all, .birthday, .anniversary, .holiday]
    var filterSelection: Int = 0 {
        didSet { interactor?.fetch(dates: filterValues[filterSelection].lowerCaseString) }
    }
    var dates: [Date?] = [] {
        didSet { view?.reloadTableView(sections: [0], animation: .fade) }
    }
    var filteredDates: [Date?] = []
    var isSearching: Bool = false
}

extension DatesPresenter: DatesEventHandling {
    
    func setupView() {
        view?.setNavigation(title: title)
        view?.setSegmentedControl(items: filterValues.map { $0.pluralString })
        view?.setSegmentedControl(selectedIndex: filterSelection)
        view?.registerTableView(nib: cellId)
        view?.setTableView(footerView: UIView())
        view?.setTabBarItemNamed(selectedName: "people-selected", unselectedName: "people-outline")
        interactor?.fetch(dates: "all")
    }
    
    func pressedSearchButton() {
        isSearching = true
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.75, height: 44)
        view?.showSearchBar(frame: frame, duration: 0.25)
    }
    
    func pressedCancelButton() {
        isSearching = false
        view?.hideSearchBar(duration: 0.25)
    }
    
    func filterDatesFor(searchText: String) {
        let lowerSearchText = searchText.lowercased()
        
        filteredDates = dates.filter {
            if let lowerFirstName = $0?.firstName?.lowercased() {
                if lowerFirstName.contains(lowerSearchText) {
                    return true
                }
            }
            if let lowerLastName = $0?.lastName?.lowercased() {
                if lowerLastName.contains(lowerSearchText) {
                    return true
                }
            }
            return false
        }
        view?.reloadTableView(sections: [0], animation: .fade)
    }
    
    func segmentedControl(indexSelected: Int) {
        self.filterSelection = indexSelected
    }
    
    func deleteDate(atIndexPath indexPath: IndexPath) {
        interactor?.delete(dates[indexPath.row], complete: { success in
            if success {
                view?.deleteTableView(rows: [indexPath], animation: .automatic)
            } else {
                // TODO: Some sort of error handling?
                view?.reloadTableView(sections: [0], animation: .fade)
            }
        })
    }
    
    func resetView() {
        view?.setNavigation(titleView: nil)
        view?.reloadTableView(sections: [0], animation: .fade)
    }
}

extension DatesPresenter: DatesInteractorOutputting {}
