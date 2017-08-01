//
//  SFHomeViewController.swift
//  ServiceFusionDemo
//
//  Created by Jerónimo Valli on 7/31/17.
//  Copyright © 2017 Service Fusion. All rights reserved.
//

import UIKit
import CoreData

class SFHomeViewController: UITableViewController {

    // MARK: - # Variables
    
    var contactController: SFContactController?
    
    // MARK: - # Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactController = SFContactController(withFetchedResultsControllerDelegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SFConstants.Segues.contactVC, let contactVC = segue.destination as? SFContactViewController {
            contactVC.contactController = contactController
        }
    }
    
    // MARK: - # UITableView

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SFConstants.CellIdentifiers.contact, for: indexPath) as? SFContactTableViewCell else {
            fatalError("Wrong cell type dequeued")
        }
        
        guard let contact = contactController?.getFetchedResultsController().object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        
        cell.configureCell(withContact: contact)
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = contactController?.getFetchedResultsController().sections else {
            fatalError("No sections in fetchedResultsController")
        }
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = contactController?.getFetchedResultsController().sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let contact = contactController?.getFetchedResultsController().object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        contactController?.setSelectedContact(contact: contact)
        performSegue(withIdentifier: SFConstants.Segues.contactVC, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let contact = contactController?.getFetchedResultsController().object(at: indexPath) else {
                fatalError("Attempt to configure cell without a managed object")
            }
            contactController?.deleteContact(contact, handler: { success in
                if success {
                    self.tableView.reloadData()
                }
            })
        }
    }
}

extension SFHomeViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
