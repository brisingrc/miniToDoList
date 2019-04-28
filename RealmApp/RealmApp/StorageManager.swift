//
//  StorageManager.swift
//  RealmApp
//
//  Created by Alexey Efimov on 16/04/2019.
//  Copyright © 2019 Alexey Efimov. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveData(_ tasksList: TasksList) {
        
        try! realm.write {
            realm.add(tasksList)
        }
    }
    
    static func saveTask(_ tasksList: TasksList, task: Task) {
        
        try! realm.write {
            tasksList.tasks.append(task)
        }
    }
    
    static func editList(_ tasksList: TasksList, newList: String) {
        
        try! realm.write {
            tasksList.name = newList
        }
    }
    
    static func editTask(_ task: Task, newTask: String, newNote: String) {
        
        try! realm.write {
            task.name = newTask
            task.note = newNote
        }
    }
    
    static func makeAllDone(_ tasksList: TasksList) {
        
        try! realm.write {
            tasksList.tasks.setValue(true, forKey: "completed")
        }
    }
    
    static func makeDone(_ task: Task) {
        
        try! realm.write {
            task.completed.toggle()
        }
    }
    
    static func deleteList(_ tasksList: TasksList) {
        
        try! realm.write {
            let tasks = tasksList.tasks
            realm.delete(tasks)
            realm.delete(tasksList)
        }
    }
    
    static func deleteTask(_ task: Task) {
        
        try! realm.write {
            realm.delete(task)
        }
    }
}
