//
//  CustomView.swift
//  TodoList
//
//  Created by NhanHoo23 on 14/03/2023.
//

import MTSDK

class CustomView: UIView {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    init(imageStr: String, labelStr: String, isNoti: Bool, timePickerView: TimePickerView, datePickerView: DatePickerView, taskModel: TaskModel) {
        super.init(frame: .zero)
        self.setupView()
        
        self.imgView.image = UIImage(systemName: imageStr)
        self.timePickerView = timePickerView
        self.datePickerView = datePickerView
        if let time = taskModel.time {
            self.notiString = "Remind me at \(time.getFormattedDate(format: "h:mm a E, d MMM"))"
        } else {
            self.notiString = labelStr
        }
        self.dateString = "\(taskModel.date.getFormattedDate(format: "E, d MMM"))"
        self.isNoti = isNoti
        
        if isNoti {
            label.text = notiString
        } else {
            label.text = dateString
        }
    }
    
    //Variables
    let imgView = UIImageView()
    let label = UILabel()
    var isNoti: Bool = false
    var timePickerView: TimePickerView!
    var datePickerView: DatePickerView!
    var notiString: String = ""
    var dateString: String = ""
    
    var doneTimeHandle: ((Date) -> Void)?
    var doneDateHandle: ((Date) -> Void)?
}


//MARK: SetupView
extension CustomView {
    private func setupView() {
        self.isUserInteractionEnabled = true
        
        imgView >>> self >>> {
            $0.snp.makeConstraints {
                $0.leading.top.equalToSuperview().offset(PaddingScreen.topLeft)
                $0.width.height.equalTo(25)
            }
            $0.tintColor = .black
        }
        
        label >>> self >>> {
            $0.snp.makeConstraints {
                $0.leading.equalTo(imgView.snp.trailing).offset(16)
                $0.centerY.equalTo(imgView)
            }
        }
        
        self.tapHandle {
            self.showPopup(isNoti: self.isNoti)
        }
    }

}


//MARK: Functions
extension CustomView {
    func showPopup(isNoti: Bool) {
        if let vc = self.window?.rootViewController {
            if isNoti {
                vc.showTimePickerView(toView: self.timePickerView, doneHandle: {time in
                    if let doneTimeHandle = self.doneTimeHandle {
                        doneTimeHandle(time)
                    } else {
                        print(" khong done dc time: \(time)")
                    }
                })
            } else {
                vc.showDatePickerView(toView: self.datePickerView, doneHandle: {date in
                    if let doneDate = self.doneDateHandle {
                        doneDate(date)
                    }
                })
            }
        }
    }
    
    func updateLableTime(taskModel: TaskModel) {
        if let time = taskModel.time {
            if isNoti {
                self.notiString = "Remind me at \(time.getFormattedDate(format: "h:mm a E, d MMM"))"
                self.label.text = self.notiString
            }
        }
    }
    
    func updateLableDate(taskModel: TaskModel) {
        if !isNoti {
            self.dateString = "\(taskModel.date.getFormattedDate(format: "E, d MMM"))"
            self.label.text = dateString
        }
    }
}
