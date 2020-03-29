//
//  DatesPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/22/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

class DatesPresenter {

    // MARK: Components
    
    public weak var wireframe: DatesWireframe?
    public var view: DatesViewOutputting?
    public var interactor: DatesInteractorInputting?

    // MARK: Constants

    private enum Constant {
        enum String {
            static let title = "Dates"
            static let dateCellID = "DateCell"
        }
    }

    // MARK: Properties

    private var tabs: [DateType] = [.birthday, .anniversary, .holiday, .other]

    private var tabStrings: [String] {
        return tabs.map { $0.pluralString }
    }

    var selectedTabIndex = 0 {
        didSet { interactor?.fetch(dates: tabs[selectedTabIndex].lowercased) }
    }
    var dates: [Date?] = [] {
        didSet { view?.reloadTableView(sections: [0], animation: .fade) }
    }
    var filteredDates: [Date?] = []
    var isSearching: Bool = false
}

extension DatesPresenter: DatesEventHandling {

    // MARK: Properties
    
    func setupView() {
        view?.setNavigation(title: Constant.String.title)

        view?.setSegmentedControl(tabStrings: tabStrings)
        view?.setSegmentedControl(selectedIndex: selectedTabIndex)

        view?.registerTableView(cellClass: DateCell.self, reuseIdentifier: Constant.String.dateCellID)
        view?.setupTableView(with: UIView())

        view?.setTabBarItemNamed(selectedName: "people-selected", unselectedName: "people-outline")

        interactor?.fetch(dates: "all")
    }

    var dateCellID: String {
        return Constant.String.dateCellID
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
        selectedTabIndex = indexSelected
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
        view?.reloadTableView(sections: [0], animation: .fade)
    }
}

extension DatesPresenter: DatesInteractorOutputting {}
