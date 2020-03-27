//
//  DatesNavigationViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 1/15/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

class DatesNavigationViewController: UINavigationController {
    
    var presenter: DatesNavigationEventHandling?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = .birthday
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.white,
                                             NSAttributedString.Key.font.rawValue: UIFont(name: "AvenirNext-Bold", size: 23)!])
        presenter?.showDates(in: self)
    }
}

extension DatesNavigationViewController: DatesNavigationViewOutputting {}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
