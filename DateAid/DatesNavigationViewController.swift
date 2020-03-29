//
//  DatesNavigationViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 1/15/17.
//  Copyright © 2017 Aaron Williamson. All rights reserved.
//

import UIKit

class DatesNavigationViewController: UINavigationController {
    
    public var presenter: DatesNavigationEventHandling?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        presenter?.showDates(in: self)
    }

    private func configureView() {
        navigationBar.barTintColor = .birthday
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 23)!
        ]
    }
}

extension DatesNavigationViewController: DatesNavigationViewOutputting {}
