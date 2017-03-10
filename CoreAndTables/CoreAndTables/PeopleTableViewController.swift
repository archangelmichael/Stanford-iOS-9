//
//  TasksTableViewController.swift
//  CoreAndTables
//
//  Created by Radi on 3/9/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit
import CoreData

class PeopleTableViewController: UITableViewController {
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    var classPeople : [PersonClass] = PersonClass.getSome()
    var corePeople : [NSManagedObject] = []
    
    var usingCoreData : Bool = false {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
            
            do {
                self.corePeople = try managedContext.fetch(fetchRequest)
            }
            catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        
        self.segment.selectedSegmentIndex = 0
        
        self.tableView.estimatedRowHeight = 60.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.changeModel(self.segment)
    }
    
    @IBAction func onAdd(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) {
                                        [unowned self] action in
                                        
                                        guard let tfName = alert.textFields?.first,
                                            let name = tfName.text,
                                            let tfAge = alert.textFields?.last,
                                            let age = Int(tfAge.text!),
                                            age > 0 && age < 100 else {
                                                return
                                        }
                                        
                                        if self.usingCoreData {
                                            self.save(name: name)
                                        }
                                        else {
                                            let person = PersonClass(name: name,
                                                                     age: age,
                                                                     gender: Gender.Male)
                                            self.classPeople.append(person)
                                        }
                                        
                                        self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { (tf) in
            tf.tag = 1
            tf.placeholder = "name"
        }
        
        alert.addTextField { (tf) in
            tf.tag = 2
            tf.placeholder = "age"
            tf.keyboardType = .phonePad
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func save(name: String) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Person",
                                                    in: managedContext)!
            let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            person.setValue(name, forKeyPath: "name")
            do {
                try managedContext.save()
                self.corePeople.append(person)
            }
            catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    @IBAction func changeModel(_ sender: UISegmentedControl) {
        usingCoreData = sender.selectedSegmentIndex == 0
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return self.usingCoreData ? self.corePeople.count : self.classPeople.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.usingCoreData {
            let reuseCell = tableView.dequeueReusableCell(withIdentifier: "NameCell",
                                                          for: indexPath)
            
            if let cell = reuseCell as? NameTableViewCell {
                let person = self.corePeople[indexPath.row]
                cell.lblName.text = person.value(forKeyPath: "name") as? String
            }
            
            return reuseCell
        }
        else {
            let reuseCell = tableView.dequeueReusableCell(withIdentifier: "PersonCell",
                                                          for: indexPath)
            
            if let cell = reuseCell as? PersonTableViewCell {
                let person = self.classPeople[indexPath.row]
                cell.person = person
                cell.btnDone.tag = indexPath.row
                cell.btnDone.addTarget(self,
                                       action: #selector(marry(sender:)),
                                       for: .touchUpInside)
            }
            
            return reuseCell
        }
    }
    
    func marry(sender: UIButton) -> Void {
        let row = sender.tag
        let indexPath = IndexPath(row: row, section: 0)
        let person = self.classPeople[indexPath.row]
        person.isMarried = true
        self.tableView.reloadRows(at: [indexPath],
                                  with: UITableViewRowAnimation.fade)
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt
        indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView,
                            canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            if self.usingCoreData {
                let person = self.corePeople[indexPath.row]
                self.corePeople.remove(at: indexPath.row)
                guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
                        return
                }
                
                if #available(iOS 10.0, *) {
                    let managedContext = appDelegate.persistentContainer.viewContext
                    managedContext.delete(person)
                    do {
                        try managedContext.save()
                    }
                    catch let error as NSError {
                        print("Could not delete. \(error), \(error.userInfo)")
                    }
                }
            }
            else {
                self.classPeople.remove(at: indexPath.row)
            }
            
            self.tableView.deleteRows(at: [indexPath],
                                      with: UITableViewRowAnimation.fade)
        }
    }
}
