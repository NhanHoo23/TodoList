//
//  TaskDetailViewController.swift
//  TodoList
//
//  Created by NhanHoo23 on 14/03/2023.
//

import MiTu
 
protocol TaskDetailViewControllerDelegate {
    func updateTask(taskModel: TaskModel)
    func deleteTask(taskModel: TaskModel)
}

//MARK: Init and Variables
class TaskDetailViewController: UIViewController {
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    init(taskModel: TaskModel) {
        super.init(nibName: nil, bundle: nil)
        self.taskModel = taskModel
    }
    
    //Variables
    let checkBt = UIButton()
    let taskName = UILabel()
    var customView: CustomView!
    let clearBt = UIButton()
    let dateCreateTaskLb = UILabel()
    let noteView = CustomsLabel(padding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
    let timePickerView = TimePickerView()
    let datePickerView = DatePickerView()
    
    var taskModel: TaskModel!
    var components = [["imgStr": "bell", "labelStr": "Remind Me", "isNoti": true],
                      ["imgStr": "calendar", "labelStr": "Add Date", "isNoti": false]]
    let noteFont = UIFont(name: FNames.regular, size: 18)
    
    var isCheckDone: Bool = false {
        didSet {
            self.taskModel.doneCheck = self.isCheckDone
            self.updateTaskName(isDone: isCheckDone)
        }
    }
    var delegate: TaskDetailViewControllerDelegate?
}


//MARK: Lifecycle
extension TaskDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if let time = self.taskModel.time {
            timePickerView.tPicker.date = time
        }
        datePickerView.dPicker.date = self.taskModel.date
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        datePickerView.isDetail = true
        timePickerView.isDetail = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        datePickerView.isDetail = false
        timePickerView.isDetail = false
        self.saveTask()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {return .darkContent}
}

//MARK: SetupView
extension TaskDetailViewController {
    private func setupView() {
        view.backgroundColor = Color.mainBackground
        
        let taskView = UIView()
        taskView >>> view >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(topSafe)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(50)
            }
        }
        
        checkBt >>> taskView >>> {
            $0.snp.makeConstraints {
                $0.leading.top.equalToSuperview().offset(PaddingScreen.topLeft)
                $0.width.height.equalTo(30)
            }
            $0.contentVerticalAlignment = .fill
            $0.contentHorizontalAlignment = .fill
            $0.tintColor = .black
            $0.handle {
                self.isCheckDone.toggle()
            }
        }
        
        taskName >>> taskView >>> {
            $0.snp.makeConstraints {
                $0.centerY.equalTo(checkBt)
                $0.leading.equalTo(checkBt.snp.trailing).offset(16)
            }
            $0.text = self.taskModel.task
            $0.textColor = Color.textColor
        }
        
        UIView() >>> view >>> {
            $0.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.top.equalTo(taskView.snp.bottom)
                $0.height.equalTo(1)
            }
            $0.backgroundColor = .gray.withAlphaComponent(0.6)
        }
        
        let stackView = UIStackView()
        stackView >>> view >>> {
            $0.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.top.equalTo(taskView.snp.bottom)
                $0.height.equalTo(100)
            }
            $0.axis = .vertical
            $0.spacing = 0
            $0.distribution = .fillEqually
        }
        
        self.components.forEach({ arr in
            guard let imageStr = arr["imgStr"] as? String,
                  let labelDefaul = arr["labelStr"] as? String,
                  let isNoti = arr["isNoti"] as? Bool else {return}
            
            customView = CustomView(imageStr: imageStr,
                                    labelStr: labelDefaul,
                                    isNoti: isNoti,
                                    timePickerView: self.timePickerView,
                                    datePickerView: self.datePickerView,
                                    taskModel: self.taskModel)
            customView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            stackView.addArrangedSubview(customView)
        })
        
        self.customView.doneDateHandle = {date in
            self.taskModel.date = date
            self.customView.updateLableDate(taskModel: self.taskModel)
        }
        self.customView.doneTimeHandle = {time in
            print("xxx: \(time)")
            self.taskModel.time = time
            self.customView.updateLableTime(taskModel: self.taskModel)
        }
        
        UIView() >>> view >>> {
            $0.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.top.equalTo(stackView.snp.bottom)
                $0.height.equalTo(1)
            }
            $0.backgroundColor = .gray.withAlphaComponent(0.6)
        }
        
        let bottomView = UIView()
        bottomView >>> view >>> {
            $0.snp.makeConstraints {
                $0.bottom.equalTo(botSafe)
                $0.leading.trailing.equalToSuperview()
            }
        }
        
        clearBt >>> bottomView >>> {
            $0.snp.makeConstraints {
                $0.bottom.equalToSuperview()
                $0.trailing.equalToSuperview().offset(PaddingScreen.bottomRight)
                $0.width.height.equalTo(ItemSize.buttonSize)
            }
            $0.setImage(UIImage(systemName: "trash"), for: .normal)
            $0.tintColor = .red
            $0.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            $0.contentVerticalAlignment = .fill
            $0.contentHorizontalAlignment = .fill
            $0.handle {
                self.deleteTask()
            }
        }
        
        dateCreateTaskLb >>> bottomView >>> {
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.centerY.equalTo(clearBt)
            }
            let time = self.taskModel.timeCreation.timeIntervalSince1970
            let timeStr = Date(timeIntervalSince1970: time)
            var timeAgo = timeStr.timeAgo
            if timeStr.isYesterday {
                timeAgo = "Yesterday"
            }
            let timeCreate = "\(timeAgo.isEmpty ? "Just now" : timeAgo)"
            $0.text = "Create \(timeCreate)"
            $0.textColor = Color.textColor
        }
        
        noteView >>> view >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(stackView.snp.bottom)
                $0.bottom.equalTo(bottomView.snp.top)
                $0.leading.trailing.equalToSuperview()
            }
            if self.taskModel.note.isEmpty {
                $0.text = "Add Note"
            } else {
                $0.text = self.taskModel.note
            }
            $0.textColor = Color.textColor
            $0.numberOfLines = 0
            $0.isUserInteractionEnabled = true
            $0.tapHandle {
                let noteVC = NoteViewController(taskModel: self.taskModel)
                noteVC.doneHandle = {text in
                    if text != "" {
                        self.taskModel.note = text
                        self.noteView.text = text
                    }
                }
                self.present(noteVC, animated: true)
            }
        }
        
        self.addPopupView(timePickerView: self.timePickerView, datePickerView: self.datePickerView)
        
        let isDone = self.taskModel.doneCheck
        self.updateTaskName(isDone: isDone)
    }
}


//MARK: Functions
extension TaskDetailViewController {
    func deleteTask() {
        self.showAlert(title: "Delete Task", actionTile: "Yes", cancelTitle: "Cancel", completion: {done in
            if done {
                self.navigationController?.popViewController(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.delegate?.deleteTask(taskModel: self.taskModel)
                })
            }
        })
    }
    
    func saveTask() {
        self.delegate?.updateTask(taskModel: self.taskModel)
    }
    
    func updateTaskName(isDone: Bool) {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self.taskModel.task)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
        if isDone {
            taskName.attributedText = attributeString
            checkBt.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        } else {
            attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
            taskName.attributedText = attributeString
            checkBt.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }    
}
