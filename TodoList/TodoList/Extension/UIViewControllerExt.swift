//
//  UIViewControllerExt.swift
//  TodoList
//
//  Created by NhanHoo23 on 08/03/2023.
//

import MiTu

extension UIViewController {
    func showAddTaskView(addTaskView: AddTaskView, datePikerView: DatePickerView, timePickerView: TimePickerView, doneHandle: ((TaskModel) -> Void)? = nil) {
        addTaskView >>> self.view >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.showUI()
            $0.cancelHandle = {
                datePikerView.isTempStorage = false
                datePikerView.resetDate()
                timePickerView.isTempStorage = false
                timePickerView.resetTime()
                self.removeAddTaskView(view: addTaskView, taskViewModel: addTaskView.taskViewModel)
            }
            $0.doneHandle = { taskModel in
                self.removeAddTaskView(view: addTaskView, taskViewModel: addTaskView.taskViewModel)
                if let done = doneHandle {
                    done(taskModel)
                }
            }
            $0.calendarBt.tapHandle{
                datePikerView.isHidden = false
                self.showDatePickerView(toView: datePikerView, fromView: addTaskView, doneHandle: {date in
                    addTaskView.taskViewModel.date = date
                    addTaskView.updateCalendar(date: date, showDate: true)
                })
            }
            $0.cancelDate.handle {
                datePikerView.isTempStorage = false
                datePikerView.resetDate()
                addTaskView.updateCalendar(showDate: false)
            }
            $0.timeBt.tapHandle {
                timePickerView.isHidden = false
                self.showTimePickerView(toView: timePickerView, fromView: addTaskView, doneHandle: {time in
                    addTaskView.taskViewModel.time = time
                    addTaskView.updateTime(time: time, showTime: true)
                })
            }
            $0.cancelTime.handle {
                timePickerView.isTempStorage = false
                timePickerView.resetTime()
                addTaskView.updateTime(showTime: false)
            }
        }
        
        datePikerView >>> self.view >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.isHidden = true
        }
        
        timePickerView >>> self.view >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.isHidden = true
        }
    }
    
    func removeAddTaskView(view: AddTaskView, taskViewModel: TaskViewModel) {
        taskViewModel.reset()
        view.colorView.selectedIndexPath = nil
        view.colorView.colorCollection.reloadData()
        view.resetUI()
        view.textInput.endEditing(true)
        view.updateUI(showKeyboard: false, keyboardHeight: 0, completion: {
            self.view.subviews.filter{$0 is AddTaskView}.forEach { subview in
                subview.removeFromSuperview()
            }
            self.view.subviews.filter{$0 is DatePickerView}.forEach { subview in
                subview.removeFromSuperview()
            }
            self.view.subviews.filter{$0 is TimePickerView}.forEach { subview in
                subview.removeFromSuperview()
            }
        })
    }
    
    func hideAddTaskView(view: AddTaskView) {
        view.textInput.endEditing(true)
        view.updateUI(showKeyboard: false, keyboardHeight: 0)
    }
    
    func showDatePickerView(toView: DatePickerView, fromView: AddTaskView? = nil, doneHandle: ((Date) -> Void)? = nil) {
        if let fromView = fromView {
            self.hideAddTaskView(view: fromView)
        } else {
            toView.isHidden = false
        }
        
        toView.updateUI(true)
        toView.cancelHandle = {
            if !toView.isTempStorage && !toView.isDetail {
                toView.resetDate()
            }
            if let fromView = fromView {
                self.hideDatePickerView(toView, fromView)
            } else {
                self.hideDatePickerView(toView)
            }
        }
        toView.doneHandle = { date in
            if let doneHandle = doneHandle {
                doneHandle(date)
            }
            if let fromView = fromView {
                self.hideDatePickerView(toView, fromView)
            } else {
                self.hideDatePickerView(toView)
            }
        }
        
    }
    
    func hideDatePickerView(_ hideView: DatePickerView, _ showView: AddTaskView? = nil) {
        hideView.updateUI(false, completion: {
            hideView.isHidden = true
        })
        guard let showView = showView else {return}
        showView.textInput.becomeFirstResponder()
    }
    
    func addPopupView(timePickerView: TimePickerView, datePickerView: DatePickerView) {
        timePickerView >>> self.view >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.isHidden = true
        }
        
        datePickerView >>> self.view >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.isHidden = true
        }
    }
    
    func showTimePickerView(toView: TimePickerView, fromView: AddTaskView? = nil, doneHandle: ((Date) -> Void)? = nil) {
        if let fromView = fromView {
            self.hideAddTaskView(view: fromView)
        } else {
            toView.isHidden = false
        }
        
        toView.updateUI(true)
        toView.cancelHandle = {
            if !toView.isTempStorage && !toView.isDetail {
                toView.resetTime()
            }
            if let fromView = fromView {
                self.hideTimePickerView(toView, fromView)
            } else {
                self.hideTimePickerView(toView)
            }
        }
        toView.doneHandle = { date in
            if let doneHandle = doneHandle {
                doneHandle(date)
            }
            if let fromView = fromView {
                self.hideTimePickerView(toView, fromView)
            } else {
                self.hideTimePickerView(toView)
            }
        }
    }
    
    func hideTimePickerView(_ hideView: TimePickerView, _ showView: AddTaskView? = nil) {
        hideView.updateUI(false, completion: {
            hideView.isHidden = true
        })
        guard let showView = showView else {return}
        showView.textInput.becomeFirstResponder()
    }
    
    func showInputAlert(title: String? = nil, message: String? = nil, actionTile: String? = nil, cancelTitle: String = "Cancel", placeHolder1: String = "", placeHolder2: String = "", userInterface: UIUserInterfaceStyle = .light, completion: @escaping(String?, String?) -> Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.overrideUserInterfaceStyle = userInterface
        alertVC.addTextField(configurationHandler: { textField in
            textField.placeholder = placeHolder1
            textField.clearButtonMode = .always
        })
        alertVC.addTextField(configurationHandler: {textField in
            textField.placeholder = placeHolder2
            textField.clearButtonMode = .always
        })
        
        let action = UIAlertAction(title: actionTile, style: .default, handler: { _ in
            if let text1 = alertVC.textFields![0].text, let text2 = alertVC.textFields![1].text {
                completion(text1, text2)
            }
        })
        action.isEnabled = false
        
        if let popoverController = alertVC.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        }
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: { _ in
            completion(nil, nil)
        })
        
        NotificationCenter.default.addObserver(
            forName: UITextField.textDidChangeNotification,
            object: alertVC.textFields?[0],
            queue: .main) { (notification) -> Void in
                guard let text1 = alertVC.textFields?[0].text else {return}
                action.isEnabled = (self.isValidText(text: text1))
            }
            
        alertVC.addAction(action)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func isValidText(text: String) -> Bool {
        if text.count > 0 {
            return true
        }
        return false
    }
}
