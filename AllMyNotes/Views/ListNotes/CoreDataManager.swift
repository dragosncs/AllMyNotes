//
//  CoreDataManager.swift
//  AllMyNotes
//
//  Created by Dragos Neacsu on 05.10.2023.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager(modelName: "AllMyNotes")
    
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init (modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (description, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
    func save() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("An error ocurred while saving: \(error.localizedDescription)")
            }
        }
    }
    
    
}


// MARK: Helper functions
extension CoreDataManager {
    func createNote() -> Notes {
        let note = Notes(context: viewContext)
        note.id = UUID()
        note.text = ""
        note.lastUpdated = Date()
        save()
        return note
    }
    
    func fetchNotes(filter: String? = nil) -> [Notes] {
        let request: NSFetchRequest<Notes> = Notes.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Notes.lastUpdated, ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        if let filter = filter {
            let predicate = NSPredicate(format: "text contains[cd] %@", filter)
            request.predicate = predicate
        }
        
        return (try? viewContext.fetch(request)) ?? []
    }
    
    func deleteNote(_ note: Notes) {
        viewContext.delete(note)
        save()
    }
}
