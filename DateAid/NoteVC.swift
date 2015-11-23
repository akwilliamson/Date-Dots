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

    var managedContext: NSManagedObjectContext?
    var noteObject: Note?
    var dateObject: Date?
    var noteTitle: String!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Flurry.logEvent("Note Details", withParameters: ["forNote:" : noteTitle])
        AppAnalytics.logEvent("Note Details", parameters: ["forNote:" : noteTitle])
        title = noteTitle
        
        if dateObject?.notes?.count > 0 {
            guard let notesForDate = dateObject?.notes else { return }
            for noteForDate in notesForDate {
                let dateNote = noteForDate as! Note
                if dateNote.title == noteTitle {
                    noteObject = dateNote
                    textView.text = noteObject?.body
                }
            }
            if noteObject == nil {
                setPlaceholderText(inView: textView)
            }
        } else {
            setPlaceholderText(inView: textView)
        }
    }
    
    func setPlaceholderText(inView view: UITextView) {
        view.textColor = UIColor.lightGrayColor()
        switch noteTitle {
        case "Gifts":
            view.text = "A place for gift ideas"
        case "Plans":
            view.text = "A place for event plans"
        case "Other":
            view.text = "A place for any other notes"
        default:
            break
        }
    }
    
    @IBAction func saveNote(sender: AnyObject) {
        self.logEvents(forString: "Save Note")
        noteObject?.body = textView.text
        saveContext()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func saveContext() {
        if noteObject == nil {
            guard let entity = NSEntityDescription.entityForName("Note", inManagedObjectContext: managedContext!) else { return }
            noteObject = Note(entity: entity, insertIntoManagedObjectContext: managedContext)
            
            noteObject?.title = title
            noteObject?.body = textView.text
            
            guard let noteObject = noteObject else { return }
            let notes = dateObject?.notes?.mutableCopy() as! NSMutableSet
            notes.addObject(noteObject)
            dateObject?.notes = notes.copy() as? NSSet
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
            textView.textColor = dateObject?.type?.associatedColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            setPlaceholderText(inView: textView)
        }
    }
}
