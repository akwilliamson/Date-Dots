//
//  DateSetupViewController.swift
//  DateAid
//
//  Created by Aaron Williamson on 5/3/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

class DateSetupViewController: UIViewController {
    
    // MARK: UI
    
    private let baseView = DateSetupView()
    
    // MARK: Properties
    
    private let viewModel = DateSetupViewModel()
    
    // MARK: Lifecycle
 
    override func loadView() {
        view = baseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseView.populate(with: viewModel.content)
    }
}

// MARK: UITextViewDelegate

extension DateSetupViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        let placeholder = viewModel.placeholderPropertiesFor(editing: true)
        textView.text = placeholder.text
        textView.textColor = placeholder.textColor
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        let placeholder = viewModel.placeholderPropertiesFor(editing: false)
        textView.text = placeholder.text
        textView.textColor = placeholder.textColor
    }
}
