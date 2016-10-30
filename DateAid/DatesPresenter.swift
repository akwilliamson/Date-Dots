//
//  DatesPresenter.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/22/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

class DatesPresenter {

    weak var view: DatesViewProtocol?
    var interactor: DatesPresenterInteractorProtocol!
    
    required init(view: DatesViewProtocol) {
        self.view = view
        self.interactor = DatesInteractor(presenter: self)
    }
}

extension DatesPresenter: DatesViewPresenterProtocol {
    
    func styleSegmentedControl() {
        interactor.dateFilterCategories()
    }
    
    func toggleDisplay(for button: UIBarButtonItem, navigationItem: UINavigationItem) {
        
    }

    func updateView() {
        interactor.fetchDates(for: nil, sort: ["equalizedDate", "name"])
    }
    
    func showDetails(for date: Date) {
        // view
    }
}

extension DatesPresenter: DatesInteractorPresenterProtocol {

    func fetched(_ dates: [Date?]) -> Void {
        view?.display(dates)
    }
    
    func styleSegmentedControl(with categories: [String]) -> Void {
        let items = categories
        let font = UIFont(name: "Avenir-Black", size: 12) ?? UIFont()
        let selectedIndex = 0
        
        view?.setSegmentedControl(items, font: font, selectedIndex: selectedIndex)
    }
}
