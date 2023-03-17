//
//  TaskManager.swift
//  TodoList
//
//  Created by NhanHoo23 on 17/03/2023.
//

import MTSDK


class TaskManager {
    var tasks: [TaskModel] = []
    var selectedTaskIndexPath: IndexPath = IndexPath(item: 0, section: 0)
}

extension TaskManager {
    func updateTaskCheck(_ addTask: Bool,_ task: TaskModel, _ tableView: UITableView, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            if addTask {
                self.tasks.insert(task, at: 0)
                tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .left)
            } else {
                if task.doneCheck {
                    if let completion = completion {
                        completion()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                        self.deleteTask(task, tableView)
                    })
                } else {
                    if let completion = completion {
                        completion()
                    }
                }                
            }
                    
            let realmModel = RealmTaksModel(from: task)
            RealmDB.shared.update(realmModel)
        }
    }
    
    func deleteTask(_ task: TaskModel, _ tableView: UITableView) {
        DispatchQueue.main.async {
            self.tasks.removeAll(where: {$0.id == task.id})
            tableView.deleteRows(at: [self.selectedTaskIndexPath], with: .fade)
            self.selectedTaskIndexPath = IndexPath(row: 0, section: 0)
            
            let realmModel = RealmTaksModel(from: task)
            RealmDB.shared.update(realmModel)
            RealmDB.shared.delete(object: realmModel)
        }
    }
    
    //loadData
    func loadData() {
        let tasksObject = RealmDB.shared.getObjects(type: RealmTaksModel.self)
        let taskArr = tasksObject.compactMap({TaskModel(from: $0)})
        self.tasks = taskArr.reversed()
        print("alltasks: \(self.tasks.count)")
    }
}
