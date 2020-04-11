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
        .birthday: false,
        .anniversary: false,
        .holiday: false,
        .other: false
    ]

    private var dotDates: [DateType: [Date]] = [:]
    
    private var isSearching = false
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
        interactor?.fetchDotDates()
    }
    
    func datesToShow() -> [Date] {
        let birthdays     = dotStates[.birthday]    ?? false ? dotDates[.birthday] ?? []    : []
        let anniversaries = dotStates[.anniversary] ?? false ? dotDates[.anniversary] ?? [] : []
        let holidays      = dotStates[.holiday]     ?? false ? dotDates[.holiday] ?? []     : []
        let other         = dotStates[.other]       ?? false ? dotDates[.other] ?? []       : []

        return birthdays + anniversaries + holidays + other
    }
    
    func searchButtonPressed() {
        isSearching = true
        view?.showSearchBar(frame: Constant.Layout.searchBarFrame, duration: Constant.Animation.searchBarDisplay)
    }

    func textChanged(to searchText: String) {
//        let lowerSearchText = searchText.lowercased()
        
//        filteredDates = allDates.filter { savedDate in
//            if let lowerFirstName = savedDate.firstName?.lowercased() {
//                if lowerFirstName.contains(lowerSearchText) { return true }
//            }
//            if let lowerLastName = savedDate.lastName?.lowercased() {
//                if lowerLastName.contains(lowerSearchText) { return true }
//            }
//            return false
//        }
//        view?.reloadTableView(sections: [0], animation: .fade)
    }
    
    func cancelButtonPressed() {
        isSearching = false
        view?.hideSearchBar(duration: Constant.Animation.searchBarDisplay)
    }

    func dotPressed(for dateType: DateType) {
        let isSelected = !(dotStates[dateType] ?? true)
        dotStates[dateType] = isSelected
        // filter dots
        view?.updateDot(for: dateType, isSelected: isSelected)
        view?.reloadTableView(sections: [0], animation: .fade)
    }
    
    func deleteDatePressed(at indexPath: IndexPath) {
//        interactor?.delete(dates[indexPath.row], complete: { success in
//            if success {
//                view?.deleteTableView(rows: [indexPath], animation: .automatic)
//            }
//        })
    }
}

extension DatesPresenter: DatesInteractorOutputting {
    
    func set(_ dates: [Date]) {
        dotDates[.birthday]    = dates.filter { $0.dateType == .birthday }
        dotDates[.anniversary] = dates.filter { $0.dateType == .anniversary }
        dotDates[.holiday]     = dates.filter { $0.dateType == .holiday }
        dotDates[.other]       = dates.filter { $0.dateType == .other }

        view?.reloadTableView(sections: [0], animation: .fade)
    }
}
