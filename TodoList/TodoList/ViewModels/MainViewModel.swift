//
//  ViewModel.swift
//  TodoList
//
//  Created by NhanHoo23 on 07/03/2023.
//

import MTSDK

//MARK: Variables
class MainViewModel {
    //headerView
    var appImage = UIImage(named: "img_app")
    var sortType: String = AppManager.shared.sortType
    
    //groupTasks
    var groups: [GroupModel] = [GroupModel(name: "All"),
                                           GroupModel(name: "Today"),
                                           GroupModel(name: "Default"),
                                           GroupModel(name: "+")]
    var selectedGroupIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    //taskList
    var tasks: [TaskModel] = []
    var tasksDone: [TaskModel] = []
    var taskNotDone: [TaskModel] = []
    var selectedTaskIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
}


//MARK: Functions
extension MainViewModel {
    //sort
    func sortTasks() {
        switch sortType {
        case "by Scheduled":
            self.tasks.sort(by: {$0.date > $1.date})
            break
        case "by Alphabetical":
            self.tasks.sort(by: {$0.task < $1.task})
            break
        default:
            self.tasks.sort(by: {$0.timeCreation > $1.timeCreation})
            break
        }
    }
    
    //updateHeaderView
    func updateSortButtonLabel(_ title: String, _ label: UILabel) {
        let lb = label
        lb.text = title
        AppManager.shared.sortType = title
        self.sortType = title
    }
    
    //updateGroupView
    func addGroup(_ group: GroupModel, _ colletionView: UICollectionView) {
        DispatchQueue.main.async {
            self.groups.insert(group, at: self.groups.count - 1)
            
            colletionView.reloadData()
            self.selectedGroupIndexPath = IndexPath(item: self.groups.count - 2, section: 0)
            colletionView.scrollToItem(at: self.selectedGroupIndexPath, at: .centeredHorizontally, animated: true)
            
            let realmModel = RealmGroupModel(from: group)
            RealmDB.shared.update(realmModel)
        }
    }
    
    func deleteGroup(_ group: GroupModel) {
        DispatchQueue.main.async {
            self.groups.removeAll(where: {$0.id == group.id})
            
            let realmModel = RealmGroupModel(from: group)
            RealmDB.shared.update(realmModel)
            RealmDB.shared.delete(object: realmModel)
        }
    }
    
    //updateTasksView
    func updateTaskCheck(_ addTask: Bool,_ task: TaskModel, _ tableView: UITableView, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            if addTask {
                self.tasks.insert(task, at: 0)
//                self.sortTasks()
                if let completion = completion {
                    completion()
                }
                tableView.insertRows(at: [self.selectedTaskIndexPath], with: .left)
            } else {
                if let index = self.tasks.firstIndex(where: {$0.id == task.id}) {
                    self.tasks[index] = task
                }
//                self.sortTasks()
//                tableView.reloadData()
                if let completion = completion {
                    completion()
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
        let groupObject = RealmDB.shared.getObjects(type: RealmGroupModel.self)
        let groupArr = groupObject.compactMap({GroupModel(from: $0)})
        self.groups.insert(contentsOf: groupArr, at: self.groups.count - 1)
        
        let tasksObject = RealmDB.shared.getObjects(type: RealmTaksModel.self)
        let taskArr = tasksObject.compactMap({TaskModel(from: $0)})
        self.tasks = taskArr.reversed()
        self.tasks.append(TaskModel())
        
        self.tasksDone = self.tasks.filter({$0.doneCheck})
        self.taskNotDone = self.tasks.filter({$0.doneCheck == false})
//        self.sortTasks()
    }
}
