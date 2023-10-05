//
//  Notes+CoreDataClass.swift
//  AllMyNotes
//
//  Created by Dragos Neacsu on 05.10.2023.
//
//

import Foundation
import CoreData

@objc(Notes)
public class Notes: NSManagedObject {
    
    var title: String {
        return text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).first ?? "" // returns the first line of the text
    }
    
    var desc: String {
        var lines = text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
        lines.removeFirst()
        return "\(lastUpdated.format()) \(lines.first ?? "")" // return second line
    }
}
