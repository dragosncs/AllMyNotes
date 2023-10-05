//
//  Notes+CoreDataProperties.swift
//  AllMyNotes
//
//  Created by Dragos Neacsu on 05.10.2023.
//
//

import Foundation
import CoreData


extension Notes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notes> {
        return NSFetchRequest<Notes>(entityName: "Notes")
    }

    @NSManaged public var id: UUID!
    @NSManaged public var text: String!
    @NSManaged public var lastUpdated: Date!

}

extension Notes : Identifiable {

}
