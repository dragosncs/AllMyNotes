//
//  EditNoteViewController.swift
//  AllMyNotes
//
//  Created by Dragos Neacsu on 04.10.2023.
//

import UIKit

class EditNoteViewController: UIViewController {
    
    static let identifier = "EditNoteViewController"

    @IBOutlet weak var textView: UITextView!
    
    var note: Notes!
    weak var delegate: ListNotesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = note?.text
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        textView.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
 
    private func updateNote() {
        note.lastUpdated = Date()
        CoreDataManager.shared.save()
        delegate?.refreshNotes()
    }
    
    private func deleteNote() {
        delegate?.deleteNote(with: note.id)
        CoreDataManager.shared.deleteNote(note)
    }
}

// MARK:- UITextView Delegate
extension EditNoteViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        note?.text = textView.text
        if note?.title.isEmpty ?? true {
            deleteNote()
        } else {
            updateNote()
        }
    }
}
