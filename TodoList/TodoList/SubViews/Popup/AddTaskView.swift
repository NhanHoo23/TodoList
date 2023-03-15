//
//  AddTaskView.swift
//  TodoList
//
//  Created by NhanHoo23 on 08/03/2023.
//

import MTSDK

class AddTaskView: UIView, UITextFieldDelegate, UIScrollViewDelegate {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    //Variables
    let gradientView = UIView()
    let containerView = UIView()
    let textInput = UITextField()
    let calendarImg = UIImageView()
    let noteImg = UIImageView()
    let notiImage = UIImageView()
    let pinBt = UIButton()
    let tagBt = UIButton()
    let colorView = TagColorView()
    let calendarBt = UIView()
    let dateLb = UILabel()
    let cancelDate = UIButton()
    let timeBt = UIView()
    let timeLb = UILabel()
    let cancelTime = UIButton()
    let noteBt = UIView()
    let noteLb = UILabel()
    let cancelNote = UIButton()
    
    var isSelectedColor: Bool = false {
        didSet {
            self.showColorView(self.isSelectedColor)
        }
    }
    
    var isSelectedPin: Bool = false {
        didSet {
            self.taskViewModel.pin = self.isSelectedPin
            let image = isSelectedPin ? UIImage(systemName: "pin.slash") : UIImage(systemName: "pin")
            self.pinBt.setImage(image, for: .normal)
        }
    }
    
    let taskViewModel = TaskViewModel()
    var doneHandle: ((TaskModel) -> Void)? = nil
    var cancelHandle: (() -> Void)? = nil
}


//MARK: SetupView
extension AddTaskView {
    private func setupView() {
        gradientView >>> self >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.backgroundColor = .clear
            $0.isUserInteractionEnabled = true
            $0.tapHandle {
                if self.isSelectedColor {
                    self.isSelectedColor = false
                }
                
                if let cancelHandle = self.cancelHandle {
                    cancelHandle()
                }
            }
        }
        
        containerView >>> self >>> {
            $0.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview().offset(ItemSize.addTaskViewHeight)
            }
            $0.backgroundColor = Color.popupColor
            $0.layer.cornerRadius = 15
            $0.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            $0.addDropShadow(color: .black, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0, height: -2), shadowRadius: 10)
            $0.isUserInteractionEnabled = true
            $0.tapHandle {
                if self.isSelectedColor {
                    self.isSelectedColor = false
                }
            }
        }
        
        let scrollView = UIScrollView()
        scrollView >>> containerView >>> {
            $0.snp.makeConstraints {
                $0.bottom.leading.trailing.equalToSuperview()
                $0.height.equalTo(81)
            }
            $0.delegate = self
            $0.isScrollEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.alwaysBounceHorizontal = true
        }
        
        let contenView = UIView()
        contenView >>> scrollView >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.height.equalToSuperview()
            }
        }
        
        calendarBt >>> contenView >>> {
            $0.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(-16)
                $0.leading.equalToSuperview().offset(16)
            }
            $0.backgroundColor = .clear
            $0.isUserInteractionEnabled = true
        }
        
        calendarImg >>> calendarBt >>> {
            $0.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(-8)
                $0.leading.equalToSuperview().offset(8)
                $0.top.equalToSuperview().offset(8)
                $0.width.height.equalTo(25)
            }
            $0.image = UIImage(systemName: "calendar")
            $0.tintColor = .black
        }
        
        dateLb >>> calendarBt >>> {
            $0.snp.makeConstraints {
                $0.centerY.equalTo(calendarImg)
                $0.leading.equalTo(calendarImg.snp.trailing).offset(0)
            }
            $0.text = ""
        }
        
        cancelDate >>> calendarBt >>> {
            $0.snp.makeConstraints {
                $0.centerY.equalTo(calendarImg)
                $0.leading.equalTo(dateLb.snp.trailing).offset(-ItemSize.buttonSize)
                $0.trailing.equalToSuperview().offset(-8)
                $0.width.height.equalTo(ItemSize.buttonSize)
            }
            $0.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
            $0.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            $0.contentVerticalAlignment = .fill
            $0.contentHorizontalAlignment = .fill
            $0.tintColor = .black
            $0.isHidden = true
        }
        
        timeBt >>> contenView >>> {
            $0.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(-16)
                $0.leading.equalTo(calendarBt.snp.trailing).offset(0)
            }
            $0.backgroundColor = .clear
            $0.isUserInteractionEnabled = true
        }
        
        notiImage >>> timeBt >>> {
            $0.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(-8)
                $0.leading.equalToSuperview().offset(8)
                $0.top.equalToSuperview().offset(8)
                $0.width.height.equalTo(25)
            }
            $0.image = UIImage(systemName: "bell")
            $0.tintColor = .black
        }
        
        timeLb >>> timeBt >>> {
            $0.snp.makeConstraints {
                $0.centerY.equalTo(notiImage)
                $0.leading.equalTo(notiImage.snp.trailing).offset(0)
                $0.width.equalTo(0)
            }
            $0.text = ""
            $0.numberOfLines = 2
            $0.adjustsFontSizeToFitWidth = true
        }

        cancelTime >>> timeBt >>> {
            $0.snp.makeConstraints {
                $0.centerY.equalTo(notiImage)
                $0.leading.equalTo(timeLb.snp.trailing).offset(-ItemSize.buttonSize)
                $0.trailing.equalToSuperview().offset(-8)
                $0.width.height.equalTo(ItemSize.buttonSize)
            }
            $0.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
            $0.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            $0.contentVerticalAlignment = .fill
            $0.contentHorizontalAlignment = .fill
            $0.tintColor = .black
            $0.isHidden = true
        }
        
        noteBt >>> contenView >>> {
            $0.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(-16)
                $0.leading.equalTo(timeBt.snp.trailing).offset(0)
            }
            $0.backgroundColor = .clear
            $0.isUserInteractionEnabled = true
            $0.tapHandle {
                if let vc = self.window?.rootViewController {
                    let noteVC = NoteViewController(taskViewModel: self.taskViewModel, taskModel: TaskModel())
                    vc.present(noteVC, animated: true)
                    noteVC.doneHandle = { text in
                        if self.taskViewModel.note.isEmpty {
                            self.updateNote(showNote: false)
                        } else {
                            self.updateNote(showNote: true)
                        }
                    }
                }
            }
        }
        
        noteImg >>> noteBt >>> {
            $0.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(-8)
                $0.leading.equalToSuperview().offset(8)
                $0.top.equalToSuperview().offset(8)
                $0.width.height.equalTo(25)
            }
            $0.image = UIImage(systemName: "doc.text")
            $0.tintColor = .black
        }
        
        noteLb >>> noteBt >>> {
            $0.snp.makeConstraints {
                $0.centerY.equalTo(noteImg)
                $0.leading.equalTo(noteImg.snp.trailing).offset(0)
            }
            $0.text = ""
        }
        
        cancelNote >>> noteBt >>> {
            $0.snp.makeConstraints {
                $0.centerY.equalTo(noteBt)
                $0.leading.equalTo(noteLb.snp.trailing).offset(-ItemSize.buttonSize)
                $0.trailing.equalToSuperview().offset(-8)
                $0.width.height.equalTo(ItemSize.buttonSize)
            }
            $0.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
            $0.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            $0.contentVerticalAlignment = .fill
            $0.contentHorizontalAlignment = .fill
            $0.tintColor = .black
            $0.isHidden = true
            $0.tapHandle {
                self.updateNote(showNote: false)
            }
        }
        
        pinBt >>> contenView >>> {
            $0.snp.makeConstraints {
                $0.leading.equalTo(noteBt.snp.trailing).offset(0)
                $0.centerY.equalTo(calendarBt)
                $0.width.height.equalTo(ItemSize.buttonSize)
            }
            $0.setImage(UIImage(systemName: "pin"), for: .normal)
            $0.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            $0.contentVerticalAlignment = .fill
            $0.contentHorizontalAlignment = .fill
            $0.tintColor = .black
            $0.handle {
                self.isSelectedPin.toggle()
            }
        }
        
        tagBt >>> contenView >>> {
            $0.snp.makeConstraints {
                $0.leading.equalTo(pinBt.snp.trailing).offset(0)
                $0.centerY.equalTo(calendarImg)
                $0.width.height.equalTo(ItemSize.buttonSize)
                $0.trailing.equalToSuperview().offset(-16)
            }
            $0.layer.cornerRadius = 5
            $0.setImage(UIImage(systemName: "tag"), for: .normal)
            $0.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            $0.contentVerticalAlignment = .fill
            $0.contentHorizontalAlignment = .fill
            $0.tintColor = .black
            $0.handle {
                self.isSelectedColor.toggle()
            }
        }
        
        textInput >>> containerView >>> {
            $0.snp.makeConstraints {
                $0.bottom.equalTo(calendarImg.snp.top).offset(-32)
                $0.top.equalToSuperview().offset(24)
                $0.leading.equalToSuperview().offset(24)
                $0.trailing.equalToSuperview().offset(-8)
                $0.height.equalTo(30)
            }
            $0.delegate = self
            $0.returnKeyType = .done
            $0.textColor = .black
            $0.placeholder = "Add a Task"
        }
        
        colorView >>> self >>> {
            $0.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-24)
                $0.bottom.equalTo(tagBt.snp.top).offset(-2)
                $0.width.height.equalTo(ItemSize.colorViewHeight)
            }
            $0.alpha = 0
            $0.doneHandle = {color in
                self.taskViewModel.tagColor = color.color
                self.isSelectedColor = false
                self.tagBt.tintColor = color.color == "none" ? .clear : .white
                self.tagBt.backgroundColor = color.color == "none" ? .black : .from(color.color)
            }
        }
    }
    
    
}


//MARK: Functions
extension AddTaskView {
    func showUI() {
        self.textInput.becomeFirstResponder()
    }
    
    func resetUI() {
        self.updateTime(showTime: false)
        self.updateCalendar(showDate: false)
        self.updateNote(showNote: false)
        self.pinBt.setImage(UIImage(systemName: "pin"), for: .normal)
        self.tagBt.tintColor = .black
        self.textInput.text = ""
    }
    
    func showColorView(_ show: Bool) {
        DispatchQueue.main.async {
            if show {
                self.colorView.isHidden = false
                UIView.animate(withDuration: 0.3, animations: {
                    self.colorView.alpha = 1
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.colorView.alpha = 0
                }, completion: {_ in
                    self.colorView.isHidden = true
                })
            }
        }
    }
    
    func updateUI(showKeyboard: Bool, keyboardHeight: CGFloat, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            if showKeyboard {
                self.containerView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-keyboardHeight)
                }
                UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseOut, animations: {
                    self.layoutIfNeeded()
                }, completion: {_ in
                    
                })
            } else {
                self.isSelectedColor = false
                self.isSelectedPin = false
                self.containerView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(ItemSize.addTaskViewHeight)
                }
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.layoutIfNeeded()
                }, completion: {_ in
                    
                })
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    if let completion = completion {
                        completion()
                    }
                })
            }
        }
    }
    
    func updateCalendar(date: Date? = nil, showDate: Bool) {
        if showDate {
            var dateString: String = ""
            if let date = date {
                dateString = date.getFormattedDate(format: "E, d MMM")
            }
            calendarBt.backgroundColor = .from("DEA754")
            calendarBt.layer.cornerRadius = ItemSize.buttonSize / 2
            
            dateLb.snp.updateConstraints {
                $0.leading.equalTo(calendarImg.snp.trailing).offset(8)
            }
            dateLb.text = dateString
            
            cancelDate.snp.updateConstraints {
                $0.leading.equalTo(dateLb.snp.trailing).offset(0)
                $0.trailing.equalToSuperview().offset(0)
            }
            cancelDate.isHidden = false
        } else {
            calendarBt.backgroundColor = .clear
            calendarBt.layer.cornerRadius = 0
            
            dateLb.snp.updateConstraints {
                $0.leading.equalTo(calendarImg.snp.trailing).offset(0)
            }
            dateLb.text = ""
            
            cancelDate.snp.updateConstraints {
                $0.leading.equalTo(dateLb.snp.trailing).offset(-ItemSize.buttonSize)
                $0.trailing.equalToSuperview().offset(-8)
            }
            cancelDate.isHidden = true
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
            }, completion: {_ in})
        }
    }
    
    func updateTime(time: Date? = nil, showTime: Bool) {
        if showTime {
            var timeString: String = ""
            if let time = time {
                timeString = time.getFormattedDate(format: "h:mm a E, d MMM")
            }
            timeBt.snp.updateConstraints {
                $0.leading.equalTo(calendarBt.snp.trailing).offset(8)
            }
            timeBt.backgroundColor = .from("DEA754")
            timeBt.layer.cornerRadius = ItemSize.buttonSize / 2
            
            timeLb.snp.remakeConstraints {
                $0.leading.equalTo(notiImage.snp.trailing).offset(8)
                $0.width.equalTo(175)
            }
            timeLb.text = "Remind me at \(timeString)"
            
            cancelTime.snp.updateConstraints {
                $0.leading.equalTo(timeLb.snp.trailing).offset(0)
                $0.trailing.equalToSuperview().offset(0)
            }
            cancelTime.isHidden = false
        } else {
            timeBt.snp.updateConstraints {
                $0.leading.equalTo(calendarBt.snp.trailing).offset(0)
            }
            timeBt.backgroundColor = .clear
            timeBt.layer.cornerRadius = 0

            timeLb.snp.remakeConstraints {
                $0.leading.equalTo(notiImage.snp.trailing).offset(0)
                $0.width.equalTo(0)
            }
            timeLb.text = ""
            
            cancelTime.snp.updateConstraints {
                $0.leading.equalTo(timeLb.snp.trailing).offset(-ItemSize.buttonSize)
                $0.trailing.equalToSuperview().offset(-8)
            }
            cancelTime.isHidden = true
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
            }, completion: {_ in})
        }
    }
    
    func updateNote(showNote: Bool) {
        if showNote {
            noteBt.snp.updateConstraints {
                $0.leading.equalTo(timeBt.snp.trailing).offset(8)
            }
            noteBt.backgroundColor = .from("DEA754")
            noteBt.layer.cornerRadius = ItemSize.buttonSize / 2
            
            noteLb.snp.updateConstraints {
                $0.leading.equalTo(noteImg.snp.trailing).offset(8)
            }
            noteLb.text = "Note"
            
            cancelNote.snp.updateConstraints {
                $0.leading.equalTo(noteLb.snp.trailing).offset(0)
                $0.trailing.equalToSuperview().offset(0)
            }
            cancelNote.isHidden = false
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
            }, completion: {_ in})
        } else {
            noteBt.snp.updateConstraints {
                $0.leading.equalTo(timeBt.snp.trailing).offset(0)
            }
            noteBt.backgroundColor = .clear
            noteBt.layer.cornerRadius = 0

            noteLb.snp.updateConstraints {
                $0.leading.equalTo(noteImg.snp.trailing).offset(0)
            }
            noteLb.text = ""
            
            cancelNote.snp.updateConstraints {
                $0.leading.equalTo(noteLb.snp.trailing).offset(-ItemSize.buttonSize)
                $0.trailing.equalToSuperview().offset(-8)
            }
            cancelNote.isHidden = true
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
            }, completion: {_ in
                self.taskViewModel.note = ""
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = self.textInput.text {
            if text.isEmpty {
                textField.resignFirstResponder()
                if let hideHandle = self.cancelHandle {
                    hideHandle()
                }
            } else {
                textField.resignFirstResponder()
                if let doneHandle = self.doneHandle {
                    let date = self.taskViewModel.date
                    let time = self.taskViewModel.time
                    let pin = self.taskViewModel.pin
                    let note = self.taskViewModel.note
                    let tagColor = self.taskViewModel.tagColor
                    let taskModel = TaskModel(task: text, date: date, note: note, time: time, tagColor: tagColor, pin: pin)
                    doneHandle(taskModel)
                }
            }
        }
        
        return true
    }
}
