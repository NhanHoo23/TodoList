//
//  MainViewController.swift
//  TodoList
//
//  Created by NhanHoo23 on 07/03/2023.
//

import MiTu
import UserNotifications

//MARK: Init and Variables
class MainViewController: UIViewController {

    //Variables
    
    let headerView: HeaderView = {
        let v = HeaderView()
       return v
    }()
    
    let addBt = UIButton()
    
    let manager = LocalNotificationManager()
}

//MARK: Lifecycle
extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.localNoti()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {return .darkContent}
}

//MARK: SetupView
extension MainViewController {
    private func setupView() {
        view.backgroundColor = Color.mainBackground
        
        headerView >>> view >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(topSafe).offset(PaddingScreen.topLeft)
                $0.leading.equalToSuperview().offset(PaddingScreen.topLeft)
                $0.trailing.equalToSuperview().offset(PaddingScreen.bottomRight)
                $0.height.equalTo(30)
            }
            $0.sortHandle = {
//                self.tasksView.tasksTableView.reloadData()
            }
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

//MARK: Functions
extension MainViewController {
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            AppManager.shared.keyboardHeight = keyboardSize.height
//            self.tasksView.addTaskView.updateUI(showKeyboard: true, keyboardHeight: keyboardSize.height)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
//        self.tasksView.addTaskView.updateUI(showKeyboard: false, keyboardHeight: 0)
        AppManager.shared.keyboardHeight = 0
    }
    
    func showAddTaskView() {
//        self.showAddTaskView(addTaskView: self.tasksView.addTaskView,
//                             datePikerView: self.tasksView.datePickerView,
//                             timePickerView: self.tasksView.timePickerView ,
//                             doneHandle: {taskModel in
//            MainViewController.vm.updateTaskCheck(true, taskModel, self.tasksView.tasksTableView, completion: {
//                self.tasksView.updateTableViewHeight()
//                self.localNoti()
//            })
//        })
    }
    
    func localNoti() {
//        let tasks = MainViewController.vm.tasks
//        for task in tasks {
//            if let time = task.time {
//                let noti = Notification(id: task.id, title: "To Do", task: "Reminder: \(task.task)", datetime: time)
//                manager.notifications.append(noti)
//            }
//            manager.schedule()
//        }
    }
}

//MARK: Delegate
extension MainViewController: TaskDetailViewControllerDelegate {
    func updateTask(taskModel: TaskModel) {
//        MainViewController.vm.updateTaskCheck(false, taskModel, self.tasksView.tasksTableView, completion: {
//            self.tasksView.tasksTableView.reloadData()
//            self.localNoti()
//        })
    }
    
    func deleteTask(taskModel: TaskModel) {
//        MainViewController.vm.deleteTask(taskModel, self.tasksView.tasksTableView)
    }
    
    
}

