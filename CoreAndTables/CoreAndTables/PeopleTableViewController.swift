//
//  TasksTableViewController.swift
//  CoreAndTables
//
//  Created by Radi on 3/9/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController {

    var people : [Person] = [
        Person(name: "George",
               age: 23,
               gender: Gender.Male),
        Person(name: "Natasha",
               age: 33,
               gender: Gender.Female),
        Person(name: "Simon",
               age: 45,
               gender: Gender.Male),
        Person(name: "Marrie",
               age: 27,
               gender: Gender.Female),
        Person(name: "Hulk",
               age: 46,
               gender: Gender.Male),
        Person(name: "Cristie",
               age: 18,
               gender: Gender.Female)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func onAdd(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) {
                                        [unowned self] action in
                                        
                                        guard let textField = alert.textFields?.first,
                                            let nameToSave = textField.text else {
                                                return
                                        }
                                        
                                        let person = Person(name: nameToSave,
                                                            age: 23,
                                                            gender: Gender.Male)
                                        self.people.append(person)
                                        self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }


    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = tableView.dequeueReusableCell(withIdentifier: "PersonCell",
                                                      for: indexPath)

        if let cell = reuseCell as? PersonTableViewCell {
            let person = self.people[indexPath.row]
            cell.person = person
            cell.btnDone.tag = indexPath.row
            cell.btnDone.addTarget(self,
                                   action: #selector(marry(sender:)),
                                   for: .touchUpInside)
        }

        return reuseCell
    }
    
    func marry(sender: UIButton) -> Void {
        let row = sender.tag
        let indexPath = IndexPath(row: row, section: 0)
        let person = self.people[indexPath.row]
        person.isMarried = true
        self.tableView.reloadRows(at: [indexPath],
                                  with: UITableViewRowAnimation.fade)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
