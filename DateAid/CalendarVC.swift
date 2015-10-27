//
//  CalendarVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/26/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CVCalendar

class CalendarVC: UIViewController {

    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = CVDate(date: NSDate()).globalDescription
        
        menuView.delegate = self
        calendarView.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
}

extension CalendarVC: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {

// MARK: Required methods
    
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    func firstWeekday() -> Weekday {
        return .Sunday
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return true
    }
    
    
}
