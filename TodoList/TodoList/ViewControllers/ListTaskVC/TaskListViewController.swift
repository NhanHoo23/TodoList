//
//  TaskListViewControllerViewController.swift
//  TodoList
//
//  Created by NhanHoo23 on 17/03/2023.
//

import MiTu

//MARK: Init and Variables
class TaskListViewController: UIViewController {

    //Variables
    let headerView = HeaderView()
    var groupCV: UICollectionView!
    let tasksTV = UITableView()
    let addBt = UIButton()
    
    let addTaskView = AddTaskView()
    let datePickerView = DatePickerView()
    let timePickerView = TimePickerView()
    
    let groupManager = GroupManager()
    let taskManager = TaskManager()
}

//MARK: -Lifecycle
extension TaskListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.groupManager.loadData()
        self.taskManager.loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {return .darkContent}
}

//MARK: -SetupView
extension TaskListViewController {
    private func setupView() {
        view.backgroundColor = Color.mainBackground
        
        headerView >>> view >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(topSafe).offset(PaddingScreen.topLeft)
                $0.leading.equalToSuperview().offset(PaddingScreen.topLeft)
                $0.trailing.equalToSuperview().offset(PaddingScreen.bottomRight)
                $0.height.equalTo(30)
            }
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        groupCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        groupCV >>> view >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(headerView.snp.bottom).offset(16)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(40)
            }
            $0.delegate = self
            $0.dataSource = self
            $0.registerReusedCell(GroupCollectionViewCell.self)
            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = false
            $0.alwaysBounceHorizontal = true
        }
        
        UIView() >>> view >>> {
            $0.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.top.equalTo(groupCV.snp.bottom)
                $0.height.equalTo(1)
            }
            $0.backgroundColor = .gray
        }
        
        tasksTV >>> view >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(groupCV.snp.bottom).offset(1)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
            $0.delegate = self
            $0.dataSource = self
            $0.registerReusedCell(TaskTableViewCell.self)
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
        }
        
        addBt >>> view >>> {
            $0.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(PaddingScreen.bottomRight - botSafeHeight)
                $0.trailing.equalToSuperview().offset(PaddingScreen.bottomRight)
                $0.width.height.equalTo(60)
            }
            $0.setTitle("+", for: .normal)
            $0.titleLabel?.font = UIFont(name: FNames.regular, size: 40)
            $0.layer.cornerRadius = 60 / 2
            $0.backgroundColor = .black
            $0.addDropShadow(color: .black, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0.5, height: 0.5), shadowRadius: 5)
            $0.handle {
                self.showAddTaskView()
            }
        }
    }
}

//MARK: -CollectionView
extension TaskListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.groupManager.groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusable(cellClass: GroupCollectionViewCell.self, indexPath: indexPath)
        cell.configsCell(group: self.groupManager.groups[indexPath.item], isSelected: self.groupManager.selectedGroupIndexPath == indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = self.groupManager.groups[indexPath.item]
        let name = model.name
        let label = UILabel()
        label.text = "\(name) (\(model.taskCount))"
        label.sizeToFit()
        
        return CGSize(width: label.frame.width + 16, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == self.groupManager.groups.count - 1 {
            self.showInputGroup()
            return
        }
        
        if self.groupManager.selectedGroupIndexPath == indexPath {return}
        let oldIndexPath = self.groupManager.selectedGroupIndexPath
        groupManager.selectedGroupIndexPath = indexPath
        
        if let oldCell = collectionView.cellForItem(at: oldIndexPath) as? GroupCollectionViewCell {
            oldCell.updateUI(isSelected: false)
        }
        
        if let newCell = collectionView.cellForItem(at: indexPath) as? GroupCollectionViewCell {
            newCell.updateUI(isSelected: true)
        }
        
        self.groupCV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

//MARK: -TableView
extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taskManager.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cellClass: TaskTableViewCell.self, indexPath: indexPath)
        
        cell.configsCell(taskModel: self.taskManager.tasks[indexPath.row])
        cell.delegate = self
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.taskManager.tasks[indexPath.row]
        let taskDetailVC = TaskDetailViewController(taskModel: model)
        taskDetailVC.delegate = self
        self.navigationController?.pushViewController(taskDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        self.taskManager.selectedTaskIndexPath = indexPath
        let model = self.taskManager.tasks[indexPath.row]
        let delete = UIContextualAction(style: .destructive, title: "Delete", handler: {_, _, _ in
            self.taskManager.deleteTask(model, self.tasksTV)
        })
        delete.image = UIImage(systemName: "trash")
        delete.backgroundColor = .red
        
        let pin = UIContextualAction(style: .normal, title: "Pin", handler: {_, _, _ in
            model.pin.toggle()
            self.taskManager.updateTaskCheck(false, model, self.tasksTV, completion: {
                self.tasksTV.reloadData()
            })
        })
        pin.image = model.pin ? UIImage(systemName: "pin.slash") : UIImage(systemName: "pin")
        pin.backgroundColor = .gray
        
        let swipe = UISwipeActionsConfiguration(actions: [delete, pin])
        
        return swipe
    }
}


//MARK: -Delegate
extension TaskListViewController: TaskTableViewCellDelegate, TaskDetailViewControllerDelegate {
    func updateTask(taskModel: TaskModel) {
        self.taskManager.updateTaskCheck(false, taskModel, self.tasksTV, completion: {
            self.tasksTV.reloadData()
        })
    }
    
    func deleteTask(taskModel: TaskModel) {
        self.taskManager.deleteTask(taskModel, self.tasksTV)
    }
    
    func checkDoneTask(cell: TaskTableViewCell) {
        guard let indexPath = tasksTV.indexPath(for: cell) else {return}
        self.taskManager.selectedTaskIndexPath = indexPath
        
        let model = self.taskManager.tasks[indexPath.row]
        model.doneCheck.toggle()
        self.taskManager.updateTaskCheck(false, model, tasksTV, completion: {
            if let cell = self.tasksTV.cellForRow(at: indexPath) as? TaskTableViewCell {
                cell.updateUI(taskModel: model)
            }
        })
    }
    
    
}

//MARK: -Functions
extension TaskListViewController {
    func showInputGroup() {
        self.showInputAlert(title: "Add New Group",
                            actionTile: "Add",
                            cancelTitle: "Cancel",
                            placeHolder: "Add new group",
                            completion: { text in
              if let text = text {
                  self.groupManager.addGroup(GroupModel(name: text), self.groupCV)
              }
        })
    }
    
    func showAddTaskView() {
        self.showAddTaskView(addTaskView: self.addTaskView,
                             datePikerView: self.datePickerView,
                             timePickerView: self.timePickerView,
                             doneHandle: {taskModel in
            self.taskManager.updateTaskCheck(true, taskModel, self.tasksTV)
        })
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            AppManager.shared.keyboardHeight = keyboardSize.height
            self.addTaskView.updateUI(showKeyboard: true, keyboardHeight: keyboardSize.height)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.addTaskView.updateUI(showKeyboard: false, keyboardHeight: 0)
        AppManager.shared.keyboardHeight = 0
    }
}
