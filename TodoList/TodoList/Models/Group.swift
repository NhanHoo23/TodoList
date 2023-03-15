//
//  Category.swift
//  TodoList
//
//  Created by NhanHoo23 on 07/03/2023.
//

import MTSDK
import RealmSwift

class RealmGroupModel: Object {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var name: String = ""
    @Persisted var taskCount: Int = 0
    
    convenience init(id: String = UUID().uuidString, name: String, taskCount: Int = 0) {
        self.init()
        self.id = id
        self.name = name
        self.taskCount = taskCount
    }
    
    convenience init(from: GroupModel) {
        self.init()
        self.id = from.id
        self.name = from.name
        self.taskCount = from.taskCount
    }
}

class GroupModel {
    var id: String = ""
    var name: String = ""
    var taskCount: Int = 0
    var tasks: [TaskModel] = []
    
    init(id: String = UUID().uuidString, name: String, taskCount: Int = 0) {
        self.id = id
        self.name = name
        self.taskCount = taskCount
    }
    
    init(from: RealmGroupModel) {
        self.id = from.id
        self.name = from.name
        self.taskCount = from.taskCount
    }
}
