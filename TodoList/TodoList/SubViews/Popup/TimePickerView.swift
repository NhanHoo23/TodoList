//
//  TimePickerView.swift
//  TodoList
//
//  Created by NhanHoo23 on 09/03/2023.
//

import MTSDK

class TimePickerView: UIView, UIGestureRecognizerDelegate {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    //Variables
    let tPicker = UIDatePicker()
    let doneBt = UIButton()
    let touchLine = UIView()
    let gradientView = UIView()
    let containerView = UIView()
    let touchArea = UIView()
    let bottomView = UIView()
    
    var yOffset: CGFloat = 0
    var tempDate: Date!
    var isTempStorage: Bool = false
    var isDetail: Bool = false
    
    var cancelHandle: (() -> Void)? = nil
    var doneHandle: ((Date) -> Void)? = nil
}


//MARK: Functions
extension TimePickerView {
    private func setupView() {
        gradientView >>> self >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.backgroundColor = .black.withAlphaComponent(0.6)
            $0.isUserInteractionEnabled = true
            $0.alpha = 0
            $0.tapHandle {
                if let cancelHandle = self.cancelHandle {
                    cancelHandle()
                }
            }
        }
        
        containerView >>> self >>> {
            $0.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview().offset(ItemSize.timePickerViewHeight)
            }
            $0.backgroundColor = Color.popupColor
            $0.layer.cornerRadius = 15
            $0.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }
        
        bottomView >>> self >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(containerView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(1)
            }
            $0.backgroundColor = Color.popupColor
        }
        
        tPicker >>> containerView >>> {
            $0.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(-botSafeHeight)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(390)
            }
            $0.overrideUserInterfaceStyle = .light
            $0.backgroundColor = .clear
            $0.tintColor = .black
            $0.datePickerMode = .dateAndTime
            $0.preferredDatePickerStyle = .inline
            $0.locale = .current
            $0.minimumDate = Date()
            $0.addTarget(self, action: #selector(handle(sender: )), for: .valueChanged)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
        
        touchArea >>> containerView >>> {
            $0.snp.makeConstraints {
                $0.bottom.equalTo(tPicker.snp.top)
                $0.leading.trailing.equalToSuperview()
                $0.top.equalToSuperview()
            }
            $0.isUserInteractionEnabled = true
        }
        let slideGesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged))
        touchArea.addGestureRecognizer(slideGesture)
        slideGesture.delegate = self
        
        doneBt >>> touchArea >>> {
            $0.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-16)
                $0.bottom.equalToSuperview()
                $0.top.equalToSuperview().offset(8)
                $0.width.height.equalTo(40)
            }
            $0.disable()
            $0.setTitle("Set", for: .normal)
            $0.setTitleColor(.blue, for: .normal)
            $0.titleLabel?.font = UIFont(name: FNames.medium, size: 18)
            $0.handle {
                self.isTempStorage = true
                if let doneHandle = self.doneHandle {
                    doneHandle(self.tempDate)
                }
            }
        }
        
        touchLine >>> touchArea >>> {
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(8)
                $0.width.equalTo(30)
                $0.height.equalTo(5)
            }
            $0.backgroundColor = .gray
            $0.layer.cornerRadius = 2.5
        }
    }
    
    @objc func tapHandler(_ sender: UITapGestureRecognizer) {
        guard
            !self.containerView.frame.contains(sender.location(in: self))  else {
            return
        }
        removeFromSuperview()
    }
    
    @objc func handle(sender: UIDatePicker) {
        self.doneBt.enable()
        self.tempDate = sender.date
        debugPrint(self.tempDate)
    }
    
    @objc func wasDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: self.containerView)
            yOffset = translation.y < 0 ? translation.y / 10 : translation.y
            
            if yOffset < 0 {
                self.containerView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(yOffset)
                }
            } else {
                self.containerView.transform = CGAffineTransform(translationX: 0, y: yOffset)
            }
            
        } else if gestureRecognizer.state == .ended {
            let translation = gestureRecognizer.translation(in: self.containerView)
            let moveY = translation.y < 0 ? 0 : translation.y
            
            if moveY > 50 {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.containerView.transform = CGAffineTransform(translationX: 0, y: ItemSize.timePickerViewHeight)
                    })
                }
                
                if let cancelHandle = self.cancelHandle {
                    cancelHandle()
                }
            } else {
                DispatchQueue.main.async {
                    self.containerView.snp.updateConstraints {
                        $0.bottom.equalToSuperview().offset(0)
                    }
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, animations: {
                        self.layoutIfNeeded()
                    })
                }
            }
        }
    }
    
    func updateUI(_ show: Bool, completion: (() -> Void)? = nil) {
        if show {
            self.containerView.transform = .identity
            self.gradientView.alpha = 1
            self.containerView.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(0)
            }
            self.bottomView.snp.remakeConstraints {
                $0.top.equalTo(containerView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(self.snp.bottom)
            }
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
            }, completion: {_ in
                
            })
        } else {
            self.gradientView.alpha = 0
            self.containerView.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(ItemSize.timePickerViewHeight)
            }
            self.bottomView.snp.remakeConstraints {
                $0.top.equalTo(containerView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(1)
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutIfNeeded()
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                if let completion = completion {
                    completion()
                }
            })
        }
    }

    func resetTime() {
        self.tPicker.date = Date()
        self.doneBt.disable()
    }
    
}
