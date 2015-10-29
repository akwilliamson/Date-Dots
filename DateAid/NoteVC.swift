//
//  NoteVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/21/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

class NoteVC: UIViewController {

    var note: String!
    var noteToSave: Note?
    var typeColor: UIColor!
    var managedContext: NSManagedObjectContext?
    var date: Date!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = note
        textView.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        
        textView.delegate = self
        if date.notes!.count > 0 {
            for noteInSet in date.notes! {
                let extractedNote = noteInSet as! Note
                if extractedNote.title == note {
                    noteToSave = extractedNote
                    textView.text = noteToSave?.body
                }
            }
            if noteToSave == nil {
                setPlaceholderText()
            }
        } else {
            setPlaceholderText()
        }
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
    
    @IBAction func saveNote(sender: AnyObject) {
        noteToSave?.body = textView.text
        print(noteToSave)
        print(noteToSave?.date)
        saveContext()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func saveContext() {
        if noteToSave == nil {
            let entity = NSEntityDescription.entityForName("Note", inManagedObjectContext: managedContext!)
            noteToSave = Note(entity: entity!, insertIntoManagedObjectContext: managedContext)
            noteToSave?.title = title
            noteToSave?.body = textView.text
            let notes = date.notes!.mutableCopy() as! NSMutableSet
            notes.addObject(noteToSave!)
            date.notes = notes.copy() as? NSSet
        }
        
        do { try managedContext?.save()
        } catch let error as NSError {
            print(error.localizedDescription)
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
