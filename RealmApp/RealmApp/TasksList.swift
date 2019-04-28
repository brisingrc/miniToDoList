//
//  TasksList.swift
//  RealmApp
//
//  Created by Alexey Efimov on 15/04/2019.
//  Copyright © 2019 Alexey Efimov. All rights reserved.
//

import RealmSwift

class TasksList: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    var tasks = List<Task>()
}
