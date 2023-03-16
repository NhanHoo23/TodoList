//
//  TasksView.swift
//  TodoList
//
//  Created by NhanHoo23 on 07/03/2023.
//

import MTSDK

class TasksView: UIView {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    init(viewModel: MainViewModel) {
        super.init(frame: .zero)
        self.vm = viewModel
        self.vm.loadData()
        self.setupView()
    }
    
    //Variables
    var vm: MainViewModel!
    
    var headerCollection: UICollectionView!
    let tasksTableView = UITableView()
    let addBt = UIButton()
    let addTaskView = AddTaskView()
    let datePickerView = DatePickerView()
    let timePickerView = TimePickerView()
    let completeView = CompleteView()
    
    var pushViewController: ((TaskModel) -> Void)?
}


//MARK: SetupView
extension TasksView {
    private func setupView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        headerCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        headerCollection >>> self >>> {
            $0.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.height.equalTo(40)
            }
            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = false
            $0.dataSource = self
            $0.delegate = self
            $0.registerReusedCell(GroupCollectionViewCell.self)
            $0.alwaysBounceHorizontal = true
        }
        
        UIView() >>> self >>> {
            $0.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.top.equalTo(headerCollection.snp.bottom)
                $0.height.equalTo(1)
            }
            $0.backgroundColor = .gray
        }
        
        tasksTableView >>> self >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(headerCollection.snp.bottom).offset(1)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
            $0.backgroundColor = .clear
            $0.dataSource = self
            $0.delegate = self
            $0.registerReusedCell(TaskTableViewCell.self)
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: botSafeHeight + 150, right: 0)
        }
        
        
//        completeView >>> self >>> {
//            $0.snp.makeConstraints {
//                $0.top.equalTo(tasksTableView.snp.bottom).offset(-140)
//                $0.leading.equalToSuperview().offset(PaddingScreen.topLeft)
//                $0.width.equalTo(110)
//                $0.height.equalTo(30)
//            }
//        }
    }
}

//MARK: CollectionView
extension TasksView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusable(cellClass: GroupCollectionViewCell.self, indexPath: indexPath)
        cell.configsCell(group: vm.groups[indexPath.item], isSelected: vm.selectedGroupIndexPath == indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == vm.groups.count - 1 {
            showInputGroup()
            return
        }
        
        if vm.selectedGroupIndexPath == indexPath {return}
        let oldIndexPath = vm.selectedGroupIndexPath
        vm.selectedGroupIndexPath = indexPath
        
        if let oldCell = collectionView.cellForItem(at: oldIndexPath) as? GroupCollectionViewCell {
            oldCell.updateUI(isSelected: false)
        }
        
        if let newCell = collectionView.cellForItem(at: indexPath) as? GroupCollectionViewCell {
            newCell.updateUI(isSelected: true)
        }
        
        self.headerCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = vm.groups[indexPath.item]
        let name = model.name
        let label = UILabel()
        label.text = "\(name) (\(model.taskCount))"
        label.sizeToFit()
        
        return CGSize(width: label.frame.width + 16, height: 40)
    }
}

//MARK: TableView
extension TasksView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cellClass: TaskTableViewCell.self, indexPath: indexPath)
        cell.configsCell(task: vm.tasks[indexPath.row])
        cell.delegate = self
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskModel = self.vm.tasks[indexPath.item]
        if let pushVC = self.pushViewController {
            pushVC(taskModel)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.vm.selectedTaskIndexPath = indexPath
        if editingStyle == .delete {
            self.vm.deleteTask(self.vm.tasks[indexPath.row], self.tasksTableView)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        self.vm.selectedTaskIndexPath = indexPath
        let delete = UIContextualAction(style: .destructive, title: "Delete", handler: {_, _, _ in
            self.vm.deleteTask(self.vm.tasks[indexPath.row], self.tasksTableView)
        })
        delete.image = UIImage(systemName: "trash")
        delete.backgroundColor = .red
        
        let pin = UIContextualAction(style: .normal, title: "Pin", handler: {_, _, _ in
            self.vm.tasks[indexPath.row].pin = true
            self.vm.updateTaskCheck(false, self.vm.tasks[indexPath.row], self.tasksTableView)
        })
        pin.image = UIImage(systemName: "pin")
        pin.backgroundColor = .gray
        
        let swipe = UISwipeActionsConfiguration(actions: [delete, pin])
        
        return swipe
    }
}

//MARK: Delegate
extension TasksView: TaskTableViewCellDelegate {
    func checkDoneTask(cell: TaskTableViewCell) {
        guard let indexPath = tasksTableView.indexPath(for: cell) else {
            return
        }
        
        vm.tasks[indexPath.row].doneCheck.toggle()
        vm.updateTaskCheck(false, vm.tasks[indexPath.row], tasksTableView)
    }
    
    
}

//MARK: Functions
extension TasksView {
    func showInputGroup() {
        if let VC = self.window?.rootViewController {
            VC.showInputAlert(title: "Add New Group",
                              actionTile: "Add",
                              cancelTitle: "Cancel",
                              placeHolder: "Add new group",
                              completion: { text in
                if let text = text {
                    self.vm.addGroup(GroupModel(name: text), self.headerCollection)
                }
            })
        }
    }
}
