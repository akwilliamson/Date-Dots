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
        configureNavigationBar()
        
        menuView.delegate = self
        calendarView.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
    
    func configureNavigationBar() {
        if let navBar = navigationController?.navigationBar {
            navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "AvenirNext-Bold", size: 23)!]
            navBar.barTintColor = UIColor.birthdayColor()
            navBar.tintColor = UIColor.whiteColor()
        }
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
    
    func shouldScrollOnOutDayViewSelection() -> Bool {
        return true
    }
    
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return false
    }
    
//    func didSelectDayView(dayView: DayView) { <<<< Use to show any dates with a matching date attribute below the calendar
//        
//    }
    
//    func presentedDateUpdated(date: Date) { <<<< Use to notify delegate to change navigation title to new month name
//        
//    }
    
//    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {  <<<< Loop through dates to show dotMarker on date
//        
//    }
    
//    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {   <<<< loop through dates to set dotMarker color
//        
//    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: DayView) -> Bool {
        return true
    }
    
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return 2.0
    }
}

extension CalendarVC: CVCalendarViewAppearanceDelegate {

    func dayLabelPresentWeekdayHighlightedTextColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    func dayLabelPresentWeekdayHighlightedBackgroundColor() -> UIColor {
        return UIColor.darkGrayColor()
    }
    
}













































