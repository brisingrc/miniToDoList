//
//  TasksViewController.swift
//  RealmApp
//
//  Created by Alexey Efimov on 02.07.2018.
//  Copyright © 2018 Alexey Efimov. All rights reserved.
//

import UIKit
import RealmSwift

class TasksViewController: UITableViewController {
    
    var currentList: TasksList!
    
    var currentTasks: Results<Task>!
    var completedTasks: Results<Task>!
    
    var isEditingMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = currentList.name
        filteringTasks()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? currentTasks.count : completedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "CURRENT TASKS" : "COMPLETED TASKS"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksCell", for: indexPath)
        
        var task: Task!
        
        task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.note
        
        return cell
    }
    
    // MARK: Table View Delegate
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var currentTask = Task()
        currentTask = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (_, _) in
            StorageManager.deleteTask(currentTask)
            self.filteringTasks()
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (_, _) in
            self.alertForAddAndUpdateList(currentTask)
        }
        
        let doneAction = UITableViewRowAction(style: .normal, title: "Done") { (_, _) in
            StorageManager.makeDone(currentTask)
            self.filteringTasks()
        }
        
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        return [doneAction, editAction, deleteAction]
    }

    @IBAction func editButtonPressed(_ sender: Any) {
        isEditingMode.toggle()
        tableView.setEditing(isEditingMode, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        alertForAddAndUpdateList()
        
    }
    

}

extension TasksViewController {
    
    // MARK: Private Methods
    private func filteringTasks() {
        currentTasks = currentList.tasks.filter("completed = false")
        completedTasks = currentList.tasks.filter("completed = true")
        
        tableView.reloadData()
    }
    
    private func alertForAddAndUpdateList(_ taskName: Task? = nil) {
        
        var title = "New Task"
        var doneButton = "Save"
        
        if taskName != nil {
            title = "Edit Task"
            doneButton = "Update"
        }
        
        // Создание алёрт контроллер
        let alert = UIAlertController(title: title, message: "Please insert task value", preferredStyle: .alert)
        
        // Текстовое поле для новой задачи
        var taskTextField: UITextField!
        
        // Текстовое поле для заметки
        var noteTextField: UITextField!
        
        // Создание кнопки для сохранения новых значений
        let saveAction = UIAlertAction(title: doneButton, style: .default) { action in
            
            // Проверяем не является ли текстовое поле пустым
            guard let newTask = taskTextField.text , !newTask.isEmpty else { return }
            
            if let taskName = taskName {
                if let newNote = noteTextField.text, !newNote.isEmpty {
                    StorageManager.editTask(taskName, newTask: newTask, newNote: newNote)
                } else {
                    StorageManager.editTask(taskName, newTask: newTask, newNote: "")
                }
            } else {
                let task = Task()
                task.name = newTask
                
                if noteTextField.text?.isEmpty == false {
                    task.note = noteTextField.text!
                }
                
                StorageManager.saveTask(self.currentList, task: task)
            }
            
            self.filteringTasks()
        }
        
        // Создаем кнопку для отмены ввода новой задачи
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction) // Присваиваем алёрту кнопку для сохранения результата
        alert.addAction(cancelAction) // Присваиваем алерут кнопку для отмены ввода новой задачи
        
        alert.addTextField { textField in
            taskTextField = textField
            taskTextField.placeholder = "New task"
            
            if let taskName = taskName {
                taskTextField.text = taskName.name
            }
        }
        
        alert.addTextField { textField in
            noteTextField = textField
            noteTextField.placeholder = "Note"
            
            if let taskName = taskName {
                noteTextField.text = taskName.note
            }
        }
        
        present(alert, animated: true) // Вызываем алёрт контроллер
    }
}
