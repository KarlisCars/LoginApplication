//
//  TasksTableViewController.swift
//  LoginApplication
//
//  Created by Karlis Cars on 09/11/2019.
//  Copyright © 2019 Karlis Cars. All rights reserved.
//

import UIKit
import Firebase

class TasksTableViewController: UIViewController {
    
    var user: Users!
    var ref: DatabaseReference!
    var tasks = [Tasks]()
    
    
    // tablewiev outlet
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        user = Users(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("tasks")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref.observe(.value, with: { (snapshot) in
            var newTask = [Tasks]()
            for item in snapshot.children{
                let task = Tasks(snapshot: item as! DataSnapshot)
                newTask.append(task)
            }
            self.tasks = newTask
            self.tableView.reloadData()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ref.removeAllObservers()
    }
    
    
    
    @IBAction func logoutTapped(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            print("leaving")
        }catch let singOutErr{
            print("Failed to sign out", singOutErr)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func toggleCompletion(_ cell: UITableViewCell, isCompleted: Bool){
        cell.accessoryType = isCompleted ? .checkmark : .none
    }
    
    
    @IBAction func addTapped(_ sender: Any) {
        
        
        let alertController = UIAlertController(title: "Link Title", message: "Add New Title and Url link.", preferredStyle: .alert)
        
        alertController.addTextField { (textField:UITextField) in
            textField.placeholder = "Title"
        }
        
        alertController.addTextField { (textField:UITextField) in
            textField.placeholder = "Url"
        }
        
        // alertController.addTextField()
        
        let save = UIAlertAction(title: "Save", style: .cancel) { _ in
            guard let titleTextField = alertController.textFields?.first, titleTextField.text != "" else {return}
            
            guard let urlTextField = alertController.textFields?.last, urlTextField.text != "" else {return}
            
            let task = Tasks(title: titleTextField.text!, userId: self.user.uid, url :urlTextField.text!)
            
            let taskRef = self.ref.child(task.title.lowercased())
            
            taskRef.setValue(task.convertToDict())
            
            //            let taskUrl = self.ref.child(task.url.self)
            //            taskUrl.setValue(task.convertToDict())
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
        
    }
}
// MARK: - Table view data source
//test change for git

extension TasksTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "fireCell", for: indexPath)
        
        let task = tasks[indexPath.row]
        
        let taskTitle = task.title
        let urlTitle = task.url
        
        cell.textLabel?.text = taskTitle
        cell.detailTextLabel?.text = urlTitle
        cell.backgroundColor = .clear
        
        toggleCompletion(cell, isCompleted: task.completed)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            let task = tasks[indexPath.row]
    //            task.ref?.removeValue()
    //        }
    
    //    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            let task = self.tasks[indexPath.row]
            task.ref?.removeValue()
        }
        
        let checkTitle = UIContextualAction(style: .normal, title: "Check") {  (contextualAction, view, boolValue) in
            guard let cell = tableView.cellForRow(at: indexPath) else {return}
            let task = self.tasks[indexPath.row]
            let isCompleted = !task.completed
            self.toggleCompletion(cell, isCompleted: isCompleted)
            task.ref?.updateChildValues(["completed": isCompleted])
        }
        checkTitle.backgroundColor = UIColor.blue
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteItem, checkTitle])
        
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc: WebViewController = storyBoard.instantiateViewController(identifier: "WebViewController") as! WebViewController
        
        vc.passedValue = tasks[indexPath.row].url
        
        navigationController?.pushViewController(vc, animated: true)
        //        let task = tasks[indexPath.row]
        //        let isCompleted = !task.completed
        //        toggleCompletion(cell, isCompleted: isCompleted)
        //        task.ref?.updateChildValues(["completed": isCompleted])
    }
    
    
}//ex

