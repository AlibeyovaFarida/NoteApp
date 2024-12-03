//
//  NoteListViewController.swift
//  NoteApp
//
//  Created by Apple on 01.12.24.
//

import UIKit
import CoreData

var noteList = [Note]()

class NoteListViewController: UIViewController {
    
    var firstLoad = true
    var selectedNote: Note? = nil
    
    func nonDeletedNotes() -> [Note]{
        
        var noDeleteNoteList = [Note]()
        for note in noteList{
            if(note.deletedDate == nil){
                noDeleteNoteList.append(note)
            }
        }
        return noDeleteNoteList
    }
    private let noteListTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier)
        tv.separatorStyle = .none
        return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        if(firstLoad){
            firstLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do {
                let results = try context.fetch(request) as NSArray
                for result in results {
                    let note = result as! Note
                    noteList.append(note)
                }
            } catch{
                print("Fetch Failed")
            }
        }
        view.backgroundColor = .systemBackground
        noteListTableView.dataSource = self
        noteListTableView.delegate = self
        setupUI()
    }
    
    private func setupUI(){
        view.addSubview(noteListTableView)
        navigationItem.title = "Note"
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(redirectionCreatViewController))
        NSLayoutConstraint.activate([
            noteListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            noteListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            noteListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            noteListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    @objc private func redirectionCreatViewController(){
        let navVC = CreateNoteViewController()
        navigationController?.pushViewController(navVC, animated: true)
    }

}

extension NoteListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nonDeletedNotes().count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as! NoteTableViewCell
        let thisNote: Note!
        thisNote = nonDeletedNotes()[indexPath.row]
        cell.configure(thisNote)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let createNoteVC = CreateNoteViewController()
        createNoteVC.note = nonDeletedNotes()[indexPath.row]
        createNoteVC.delegate = self
        navigationController?.pushViewController(createNoteVC, animated: true)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") { [weak self] contextualAction, view, boolValue in
            guard let self = self else { return }
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            
            let noteToDelete = self.nonDeletedNotes()[indexPath.row]
            noteToDelete.deletedDate = Date()
            
            do {
                try context.save()
                noteList = noteList.filter {$0.deletedDate == nil}
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            } catch {
                print("Error saving context after deletion: \(error)")
            }
        }
        contextItem.image = UIImage(systemName: "trash")
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeActions
    }
    override func viewDidAppear(_ animated: Bool) {
        noteListTableView.reloadData()
    }
}

extension NoteListViewController: CreateNoteViewControllerDelegate {
    func didUpdateNote() {
        noteListTableView.reloadData()
    }
}
