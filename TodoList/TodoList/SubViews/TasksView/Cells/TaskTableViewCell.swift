//
//  TaskTableViewCell.swift
//  TodoList
//
//  Created by NhanHoo23 on 08/03/2023.
//

import MTSDK

protocol TaskTableViewCellDelegate {
    func checkDoneTask(cell: TaskTableViewCell)
}


class TaskTableViewCell: UITableViewCell {
    
    
    //Variables
    var containerView: UIView!
    
    let checkImg = UIImageView()
    let taskName = UILabel()
    let lineTag = UIView()
    let calendarImg = UIImageView()
    let taskDate = UILabel()
    let noteImg = UIImageView()
    let bellImg = UIImageView()
    let pinImg = UIImageView()
    
    var delegate: TaskTableViewCellDelegate?
}


//MARK: Functions
extension TaskTableViewCell {
    func configsCell(task: TaskModel) {
        if containerView == nil {
            self.setupView()
        }
        lineTag.backgroundColor = task.tagColor == TagColor.none.color ? .clear : .from(task.tagColor)
        taskDate.text = task.date.getFormattedDate(format: "E, d MMM")
        
        if !checkDay(task.date) {
            taskDate.textColor = .red
        } else {
            taskDate.textColor = Color.textColor
        }
        
        let currentDate = Date().timeIntervalSince1970
        if let time = task.time {
            if currentDate - time.timeIntervalSince1970 > 0 {
                bellImg.tintColor = .red
            } else {
                bellImg.tintColor = .black
            }
        }
        
        self.showIcon(noteString: task.note, time: task.time)
        pinImg.isHidden = !task.pin
        
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: task.task)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
        if task.doneCheck {
            taskName.attributedText = attributeString
            checkImg.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
            taskName.attributedText = attributeString
            checkImg.image = UIImage(systemName: "circle")
        }
        
    }
    
    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        containerView = UIView()
        containerView >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalToSuperview()
                $0.trailing.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        }
        
        UIView() >>> containerView >>> {
            $0.snp.makeConstraints {
                $0.bottom.equalToSuperview()
                $0.leading.equalToSuperview().offset(10)
                $0.trailing.equalToSuperview().offset(-10)
                $0.height.equalTo(1)
            }
            $0.backgroundColor = .gray.withAlphaComponent(0.6)
        }
        
        lineTag >>> containerView >>> {
            $0.snp.makeConstraints {
                $0.top.equalToSuperview().offset(16)
                $0.bottom.equalToSuperview().offset(-16)
                $0.leading.equalToSuperview().offset(8)
                $0.width.equalTo(5)
            }
            $0.layer.cornerRadius = 3
        }
        
        checkImg >>> containerView >>> {
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(16)
                $0.width.height.equalTo(30)
            }
            $0.tintColor = .black
            $0.isUserInteractionEnabled = true
            $0.tapHandle {
                self.delegate?.checkDoneTask(cell: self)
            }
        }
        
        taskName >>> containerView >>> {
            $0.snp.makeConstraints  {
                $0.top.equalToSuperview().offset(16)
                $0.leading.equalTo(checkImg.snp.trailing).offset(16)
            }
            $0.font = UIFont(name: FNames.regular, size: 18)
            $0.textColor = Color.textColor
        }
        
        calendarImg >>> containerView >>> {
            $0.snp.makeConstraints {
                $0.leading.equalTo(taskName.snp.leading)
                $0.bottom.equalToSuperview().offset(-16)
                $0.width.height.equalTo(15)
            }
            $0.image = UIImage(systemName: "calendar")
            $0.tintColor = .black
        }
        
        taskDate >>> containerView >>> {
            $0.snp.makeConstraints {
                $0.centerY.equalTo(calendarImg)
                $0.leading.equalTo(calendarImg.snp.trailing).offset(8)
            }
            $0.font = UIFont(name: FNames.regular, size: 18)
            $0.textColor = Color.textColor
        }
        
        noteImg >>> containerView >>> {
            $0.snp.makeConstraints {
                $0.leading.equalTo(taskDate.snp.trailing).offset(16)
                $0.centerY.equalTo(calendarImg)
                $0.width.height.equalTo(15)
            }
            $0.image = UIImage(systemName: "doc.text")
            $0.tintColor = .black
            $0.isHidden = true
        }
        
        bellImg >>> containerView >>> {
            $0.snp.makeConstraints {
                $0.leading.equalTo(noteImg.snp.trailing).offset(16)
                $0.centerY.equalTo(calendarImg)
                $0.width.height.equalTo(15)
            }
            $0.image = UIImage(systemName: "bell")
            $0.tintColor = .black
        }
        
        pinImg >>> containerView >>> {
            $0.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-16)
                $0.top.equalToSuperview().offset(8)
                $0.width.height.equalTo(40)
            }
            $0.contentMode = .scaleAspectFit
            $0.image = UIImage(named: "img_pin")
        }
    }
    
    func showIcon(noteString: String, time: Date? = nil) {
        if !noteString.isEmpty && time == nil {
            self.noteImg.isHidden = false
            self.bellImg.isHidden = true
            
            noteImg.snp.remakeConstraints {
                $0.leading.equalTo(taskDate.snp.trailing).offset(16)
                $0.centerY.equalTo(calendarImg)
                $0.width.height.equalTo(15)
            }
        } else if noteString.isEmpty && time != nil {
            self.noteImg.isHidden = true
            self.bellImg.isHidden = false
            
            noteImg.snp.remakeConstraints {
                $0.leading.equalTo(taskDate.snp.trailing).offset(0)
                $0.centerY.equalTo(calendarImg)
                $0.width.height.equalTo(0)
            }
        } else if !noteString.isEmpty && time != nil {
            self.noteImg.isHidden = false
            self.bellImg.isHidden = false
            
            noteImg.snp.remakeConstraints {
                $0.leading.equalTo(taskDate.snp.trailing).offset(16)
                $0.centerY.equalTo(calendarImg)
                $0.width.height.equalTo(15)
            }
        } else {
            self.noteImg.isHidden = true
            self.bellImg.isHidden = true
            
            noteImg.snp.remakeConstraints {
                $0.leading.equalTo(taskDate.snp.trailing).offset(16)
                $0.centerY.equalTo(calendarImg)
                $0.width.height.equalTo(15)
            }
        }
    }
    
    func checkDay(_ lastDate: Date) -> Bool {
        let calendar = Calendar.current

        // Replace the hour (time) of both dates with 00:00
        let startOfLastDate =  calendar.startOfDay(for: lastDate)
        let startOfToday = calendar.startOfDay(for: Date(timeIntervalSinceNow: 0))

        if let numberOfDays = calendar.dateComponents([.day], from: startOfToday, to: startOfLastDate).day {
            return numberOfDays >= 0
        } else {
            return false
        }
    }
}
