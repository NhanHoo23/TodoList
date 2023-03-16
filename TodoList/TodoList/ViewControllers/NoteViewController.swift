//
//  NoteViewController.swift
//  TodoList
//
//  Created by NhanHoo23 on 09/03/2023.
//

import MTSDK


//MARK: Init and Variables
class NoteViewController: UIViewController {
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    init(taskViewModel: TaskViewModel? = nil, taskModel: TaskModel) {
        super.init(nibName: nil, bundle: nil)
        if let taskViewModel = taskViewModel {
            self.taskViewModel = taskViewModel
            self.noteText.text = taskViewModel.note
        } else {
            self.noteText.text = taskModel.note
        }
        
    }
    
    //Variables
    let titleLb = UILabel()
    let doneBt = UIButton()
    let lineHorizol = UIView()
    let noteText = UITextView()
    let textOptions = TextOptionsView()
    
    var taskViewModel: TaskViewModel!
    var selectedFont: UIFont = TextFont.regular.font
    var lineMarkLine: LineMarkType = .none
    var doneHandle: ((String) -> Void)?
}

//MARK: Lifecycle
extension NoteViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        self.updateTextAttributes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
}

//MARK: SetupView
extension NoteViewController {
    private func setupView() {
        view.backgroundColor = .white
        
        titleLb >>> view >>> {
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(16)
            }
            $0.text = "Note"
            $0.textColor = Color.textColor
            $0.font = UIFont(name: FNames.medium, size: 18)
        }
        
        doneBt >>> view >>> {
            $0.snp.makeConstraints {
                $0.centerY.equalTo(titleLb)
                $0.trailing.equalToSuperview().offset(-16)
                $0.width.height.equalTo(45)
            }
            $0.setTitle("Done", for: .normal)
            $0.setTitleColor(.blue, for: .normal)
            $0.titleLabel?.font = UIFont(name: FNames.medium, size: 18)
            $0.handle {
                self.dismiss(animated: true, completion: {
                    if let text = self.noteText.text {
                        if let taskViewModel = self.taskViewModel {
                            taskViewModel.note = text
                        }
                        if let doneHandle = self.doneHandle {
                            doneHandle(text)
                        }
                    }
                })
            }
        }
        
        lineHorizol >>> view >>> {
            $0.snp.makeConstraints   {
                $0.top.equalTo(titleLb.snp.bottom).offset(16)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(1)
            }
            $0.backgroundColor = .gray
        }
        
        textOptions >>> view >>> {
            $0.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview().offset(0)
                $0.height.equalTo(45)
            }
        }
        
        noteText >>> view >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(lineHorizol.snp.bottom).offset(16)
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
                $0.bottom.equalTo(textOptions.snp.top)
            }
            $0.backgroundColor = .clear
            $0.textColor = Color.textColor
            $0.font = self.selectedFont
            $0.becomeFirstResponder()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.updateUI()
            })
            $0.delegate = self
        }
        
        self.textOptionsEvent()
    }
}


//MARK: Funtions
extension NoteViewController {
    func updateUI() {
        if AppManager.shared.keyboardHeight > 0 {
            self.textOptions.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(-AppManager.shared.keyboardHeight)
            }

            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: {_ in

            })
        } else {
            self.textOptions.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(0)
            }

        }
    }
    
    func textOptionsEvent() {
        self.textOptions.fontBt.handle {
            if self.textOptions.textFont == .regular {
                self.selectedFont = TextFont.regular.font
                self.updateTextAttributes()
            } else if self.textOptions.textFont == .medium {
                self.selectedFont = TextFont.medium.font
                self.updateTextAttributes()
            } else {
                self.selectedFont = TextFont.bold.font
                self.updateTextAttributes()
            }
        }
            
        self.textOptions.boldBt.handle {
            if self.textOptions.textFont == .regular {
                self.selectedFont = TextFont.regular.font
            }
            self.updateTextAttributes()
        }
        
        self.textOptions.italicBt.handle {
            self.updateTextAttributes()
        }
        
        self.textOptions.underlineBt.handle {
            self.updateTextAttributes()
        }
        
        self.textOptions.dotListStyleBt.handle {
//            self.updateTextAttributes()
        }
        
        self.textOptions.numberListStyleBt.handle {
//            self.updateTextAttributes()
        }
        
        self.textOptions.linkBt.handle {
            self.showInputAlert(title: "Add Link", actionTile: "Done", cancelTitle: "Cancel", placeHolder1: "Text Display", placeHolder2: "Url", completion: { text, link in
                if let text = text, let link = link {
                    print("\(text)\n\(link)")
                   
                }
            })
        }
    }
 
    func updateTextAttributes() {
        noteText.typingAttributes.removeAll()
        let font = selectedFont
        updateTextAttributes(font: font,
                             isBold: self.textOptions.isSelectedBold,
                             isItalic: self.textOptions.isSelectedItalic,
                             isUnderlined: self.textOptions.isSelectedUnderline,
                             isBullet: self.textOptions.isSelectedDotList,
                             isNumbered: self.textOptions.isSeletedNumberList)
    }
    
    func updateTextAttributes(font: UIFont, isBold: Bool = false, isItalic: Bool = false, isUnderlined: Bool = false, isBullet: Bool = false, isNumbered: Bool = false) {
        var attributes: [NSAttributedString.Key: Any] = [:]
        
        if isBold && isItalic {
            attributes[.font] = UIFont(name: FNames.boldItalic, size: font.pointSize)
        } else if isBold {
            attributes[.font] = UIFont(name: FNames.bold, size: font.pointSize)
        } else if isItalic {
            attributes[.font] = UIFont(name: FNames.italic, size: font.pointSize)
        } else {
            attributes[.font] = font
        }
        
        if isUnderlined {
            attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        
        noteText.typingAttributes = attributes
    }

    

}


//MARK: Delegate
extension NoteViewController: UITextViewDelegate {
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
////            if text == "\n" {
////                textView.text.append("\n• ")
////                return false
////            }
//            return true
//        }
}

