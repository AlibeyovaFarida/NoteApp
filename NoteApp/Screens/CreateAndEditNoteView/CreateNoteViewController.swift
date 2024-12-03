//
//  CreateNoteViewController.swift
//  NoteApp
//
//  Created by Apple on 02.12.24.
//

import UIKit
import CoreData

protocol CreateNoteViewControllerDelegate: AnyObject{
    func didUpdateNote()
}

class CreateNoteViewController: UIViewController {
    
    var note: Note?
    weak var delegate: CreateNoteViewControllerDelegate?
    
    private let titleInputLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        lb.textColor = .systemTeal
        lb.text = "Title"
        return lb
    }()
    private let titleTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.borderColor = UIColor.systemTeal.cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 5
        return tf
    }()
    private let descriptionInputLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        lb.textColor = .systemTeal
        lb.text = "Description"
        return lb
    }()
    private let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isEditable = true
        tv.textContainer.lineBreakMode = .byWordWrapping
        tv.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        tv.layer.borderColor = UIColor.systemTeal.cgColor
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 10
        return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = .init(title: "Save", style: .done, target: self, action: #selector(didTapSaveNote))
        setupUI()
        
        if let note = note {
            titleTextField.text = note.title
            descriptionTextView.text = note.desc
        }
    }

    private func setupUI(){
        view.addSubview(titleInputLabel)
        view.addSubview(titleTextField)
        view.addSubview(descriptionInputLabel)
        view.addSubview(descriptionTextView)
        
        NSLayoutConstraint.activate([
            titleInputLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleInputLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            titleInputLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            titleTextField.topAnchor.constraint(equalTo: titleInputLabel.bottomAnchor, constant: 6),
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
            
            descriptionInputLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            descriptionInputLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            descriptionInputLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionInputLabel.bottomAnchor, constant: 6),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc private func didTapSaveNote(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        if let note = note {
            note.title = titleTextField.text
            note.desc = descriptionTextView.text
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
            let newNote = Note(entity: entity!, insertInto: context)
            newNote.id = noteList.count as NSNumber
            newNote.title = titleTextField.text
            newNote.desc = descriptionTextView.text
            noteList.append(newNote)
        }
        do {
            try context.save()
            delegate?.didUpdateNote()
            navigationController?.popViewController(animated: true)
        } catch {
            print("Context save error")
        }
        
    }
}
