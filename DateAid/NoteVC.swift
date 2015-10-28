//
//  NoteVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/21/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit

class NoteVC: UIViewController {

    var note: String!
    var typeColor: UIColor!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = note
        textView.delegate = self
        setPlaceholderText()
    }
    
    func setPlaceholderText() {
        textView.textColor = UIColor.lightGrayColor()
        textView.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        switch note {
        case "Gifts":
            textView.text = "A place for gift ideas"
        case "Plans":
            textView.text = "A place for event plans"
        case "Other":
            textView.text = "A place for any other notes"
        default:
            break
        }
    }
}

extension NoteVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = typeColor
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            setPlaceholderText()
        }
    }
}
