//
//  ListNoteTableViewCell.swift
//  AllMyNotes
//
//  Created by Dragos Neacsu on 04.10.2023.
//

import UIKit

class ListNoteTableViewCell: UITableViewCell {
    static let identifier = "ListNoteTableViewCell"
    
    @IBOutlet weak private var titleLbl: UILabel!
    @IBOutlet weak private var descriptionLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(note: Notes) {
        titleLbl.text = note.title
        descriptionLbl.text = note.desc
    }

}
