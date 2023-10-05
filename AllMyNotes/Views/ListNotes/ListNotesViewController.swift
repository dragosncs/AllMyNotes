//
//  ViewController.swift
//  AllMyNotes
//
//  Created by Dragos Neacsu on 04.10.2023.
//

import UIKit

protocol ListNotesDelegate: AnyObject {
    func refreshNotes()
    func deleteNote(with id: UUID)
}

class ListNotesViewController: UIViewController {
  
    

    @IBOutlet weak var notesCountLbl: UILabel!
    @IBOutlet weak var tableViewNotes: UITableView!
    
    private let searchController = UISearchController()
    
    private var allNotes: [Notes] = [] {
        didSet {
            notesCountLbl.text = "\(allNotes.count) \(allNotes.count == 1 ? "Note" : "Notes")"
            filteredNotes = allNotes
        }
    }
    
    private var filteredNotes: [Notes] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        tableViewNotes.contentInset = .init(top: 0, left: 0, bottom: 30, right: 0)
        configureSearchBar()
        fetchNotesFromStorage()
    }

    @IBAction func createNewNoteClicked(_ sender: UIButton) {
        goToEditNote(createNote())
    }
    
    private func configureSearchBar() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.delegate = self
    }
    
    private func indexForNote(id: UUID, in list: [Notes]) -> IndexPath {
        let row = Int(list.firstIndex(where: { $0.id == id }) ?? 0)
        return IndexPath(row: row, section: 0)
    }
    
    private func createNote() -> Notes {
        let note = CoreDataManager.shared.createNote()
        allNotes.insert(note, at: 0)
        tableViewNotes.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        
        return note
    }
    
    private func goToEditNote(_ note: Notes) {
        let controller = storyboard?.instantiateViewController(identifier: EditNoteViewController.identifier) as! EditNoteViewController
        controller.note = note
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func fetchNotesFromStorage() {
       allNotes =  CoreDataManager.shared.fetchNotes()
        
    }
    
    private func deleteNoteFromStorage(_ note: Notes) {
        deleteNote(with: note.id)
        CoreDataManager.shared.deleteNote(note)
       
    }
    
    private func searchNotesFromStorage(_ text: String) {
        allNotes = CoreDataManager.shared.fetchNotes(filter: text)
        tableViewNotes.reloadData()
    }
}

// MARK: TableView Configuration
extension ListNotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListNoteTableViewCell.identifier) as! ListNoteTableViewCell
        cell.setup(note: filteredNotes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToEditNote(filteredNotes[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNoteFromStorage(filteredNotes[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

// MARK:- Search Controller Configuration
extension ListNotesViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search("")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchNotesFromStorage(query)
    }
    
    func search(_ query: String) {
        if query.count >= 1 {
            filteredNotes = allNotes.filter { $0.text.lowercased().contains(query.lowercased()) }
        } else{
            filteredNotes = allNotes
        }
        
        tableViewNotes.reloadData()
    }
}

extension ListNotesViewController: ListNotesDelegate {
    
    func refreshNotes() {
        allNotes = allNotes.sorted { $0.lastUpdated > $1.lastUpdated }
        tableViewNotes.reloadData()
    }
    
    func deleteNote(with id: UUID) {
        let indexPath = indexForNote(id: id, in: filteredNotes)
        filteredNotes.remove(at: indexPath.row)
        tableViewNotes.deleteRows(at: [indexPath], with: .automatic)
        
        // just so that it doesn't come back when we search from the array
        allNotes.remove(at: indexForNote(id: id, in: allNotes).row)
    }
}

