//
//  DatesPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/22/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

class DatesPresenter {

    // MARK: VIPER
    
    public weak var wireframe: DatesWireframe?
    public var view: DatesViewOutputting?
    public var interactor: DatesInteractorInputting?

    // MARK: Constants

    private enum Constant {
        enum String {
            static let tabBarImage = "people-outline"
            static let tabBarSelectedImage = "people-selected"
            static let title = "Dates"
        }
        enum Layout {
            static let searchBarFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.75, height: 44)
        }
        enum Animation {
            static let searchBarDisplay = 0.25
        }
    }

    // MARK: Properties

    private var dotStates: [DateType: Bool] = [
        .birthday: true,
        .anniversary: true,
        .holiday: true,
        .other: true
    ]
    
    private var isSearching = false
    
    public var dates: [Date] {
        get {
            isSearching ? allDates : filteredDates
        }
    }

    private var allDates: [Date] = []
    private var filteredDates: [Date] = []
}

extension DatesPresenter: DatesEventHandling {

    // MARK: Properties
    
    func viewLoaded() {
        view?.configureTabBar(
            title: Constant.String.title,
            image: UIImage(named: Constant.String.tabBarImage)!,
            selectedImage: UIImage(named: Constant.String.tabBarSelectedImage)!
        )
        view?.configureNavigationBar(title: Constant.String.title)
        view?.configureTableView(footerView: UIView())
        interactor?.fetch("all")
    }
    
    func searchButtonPressed() {
        isSearching = true
        view?.showSearchBar(frame: Constant.Layout.searchBarFrame, duration: Constant.Animation.searchBarDisplay)
    }

    func textChanged(to searchText: String) {
        let lowerSearchText = searchText.lowercased()
        
        filteredDates = allDates.filter { savedDate in
            if let lowerFirstName = savedDate.firstName?.lowercased() {
                if lowerFirstName.contains(lowerSearchText) { return true }
            }
            if let lowerLastName = savedDate.lastName?.lowercased() {
                if lowerLastName.contains(lowerSearchText) { return true }
            }
            return false
        }
        view?.reloadTableView(sections: [0], animation: .fade)
    }
    
    func cancelButtonPressed() {
        isSearching = false
        view?.hideSearchBar(duration: Constant.Animation.searchBarDisplay)
    }

    func dotPressed(for dateType: DateType) {
        let isSelected = !(dotStates[dateType] ?? true)
        dotStates[dateType] = isSelected
        view?.updateDot(for: dateType, isSelected: isSelected)
    }
    
    func deleteDatePressed(at indexPath: IndexPath) {
        interactor?.delete(dates[indexPath.row], complete: { success in
            if success {
                view?.deleteTableView(rows: [indexPath], animation: .automatic)
            }
        })
    }
}

extension DatesPresenter: DatesInteractorOutputting {
    
    func set(_ dates: [Date]) {
        allDates = dates
        view?.reloadTableView(sections: [0], animation: .fade)
    }
}
