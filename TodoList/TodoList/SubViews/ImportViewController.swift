//
//  ImportViewController.swift
//  TodoList
//
//  Created by NhanHoo23 on 07/03/2023.
//

import MTSDK

//MARK: Init and Variables
class ImportViewController: UIViewController {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    init() {
        super.init(nibName: nil, bundle: nil)
        self.setupView()
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
    }
    
    
    //Variables
    var sourceView: UIView? = nil {
        didSet {
            self.updateUI()
        }
    }
    
    var sourceRect: CGRect = .zero {
        didSet {
            self.updateUI()
        }
    }
    var heightOfCell: CGFloat = 49 {
        didSet {
            self.updateUI()
        }
    }
    
    var widthOfCell: CGFloat = min(maxWidth * 0.7, 239) {
        didSet {
            self.updateUI()
        }
    }
    
    var padding: CGFloat = 8.0 {
        didSet {
            self.updateUI()
        }
    }
    
    var actions: [ImportAction] = []
    private let containerView = UIView()
    private let gradientView = UIView()
}

//MARK: Lifecycle
extension ImportViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.showPopup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {.lightContent}
}

//MARK: Functions
extension ImportViewController {
    func addAction(_ action: ImportAction) {
        let y = heightOfCell * actions.count.cgFloat
        action >>> containerView >>> {
            $0.snp.makeConstraints {
                $0.top.equalToSuperview().offset(y)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(heightOfCell)
            }
            $0.tapHandle {
                self.hidePopup {
                    self.dismiss(animated: true, completion: {
                        if let handle = action.actionHandle {
                            handle(action)
                        }
                    })
                }
            }
        }
        actions.append(action)
        
        self.updateUI()
    }
    
    private func updateUI() {
        
        var rect: CGRect = CGRect(x: 16, y: topSafeHeight + 16, width: 32, height: 32)
        if let sourceView = self.sourceView {
            if let superView = sourceView.superview, superView.bounds.width == maxWidth, superView.bounds.height == maxHeight {
                //main bounds
                rect = sourceView.frame
            } else {
                // conver
                var v: UIView = sourceView
                while let superView = v.superview {
                    v = superView
                }
                
                rect = sourceView.convert(sourceView.bounds, to: v)
            }
        }
        
        let height = heightOfCell * actions.count.cgFloat
        
        let isTop = (rect.origin.y + height) < (maxHeight - (topSafeHeight + botSafeHeight + padding))
        let isLeft = (rect.origin.x + widthOfCell) < (maxWidth - padding)
        
        if isTop && isLeft {
            let leftOffset: CGFloat = rect.origin.x
            let topOffset: CGFloat = rect.origin.y + rect.height + padding
            
            containerView.snp.remakeConstraints {
                $0.top.equalToSuperview().offset(topOffset)
                $0.leading.equalToSuperview().offset(leftOffset)
                $0.height.equalTo(25)
                $0.width.equalTo(25)
            }
            
        } else if isTop && !isLeft {
            let isCenter = rect.origin.x - widthOfCell < padding
            if isCenter {
                let topOffset: CGFloat = rect.origin.y + rect.height + padding
                
                containerView.snp.remakeConstraints {
                    $0.top.equalToSuperview().offset(topOffset)
                    $0.centerX.equalToSuperview()
                    $0.height.equalTo(25)
                    $0.width.equalTo(25)
                }
            } else {
                let rightOffset: CGFloat = maxWidth - (rect.origin.x + rect.width)
                let topOffset: CGFloat = rect.origin.y + rect.height + padding
                containerView.snp.remakeConstraints {
                    $0.top.equalToSuperview().offset(topOffset)
                    $0.trailing.equalToSuperview().offset(-rightOffset)
                    $0.height.equalTo(25)
                    $0.width.equalTo(25)
                }
            }
            
        } else if !isTop && isLeft {
            let leftOffset: CGFloat = rect.origin.x
            let botOffset: CGFloat = maxHeight - (rect.origin.y - padding)
            
            containerView.snp.remakeConstraints {
                $0.bottom.equalToSuperview().offset(-botOffset)
                $0.leading.equalToSuperview().offset(leftOffset)
                $0.height.equalTo(25)
                $0.width.equalTo(25)
            }
        } else {
            let isCenter = rect.origin.x - widthOfCell < padding
            if isCenter {
                
                let botOffset: CGFloat = maxHeight - (rect.origin.y - padding)
                
                containerView.snp.remakeConstraints {
                    $0.bottom.equalToSuperview().offset(-botOffset)
                    $0.centerX.equalToSuperview()
                    $0.height.equalTo(25)
                    $0.width.equalTo(25)
                }
            } else {
                let rightOffset: CGFloat = maxWidth - (rect.origin.x + rect.width)
                let botOffset: CGFloat = maxHeight - (rect.origin.y - padding)
                
                containerView.snp.remakeConstraints {
                    $0.bottom.equalToSuperview().offset(-botOffset)
                    $0.trailing.equalToSuperview().offset(-rightOffset)
                    $0.height.equalTo(25)
                    $0.width.equalTo(25)
                }
            }
            
        }
    }
    
    private func setupView() {
        view.backgroundColor = .clear
        
        gradientView >>> view >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.backgroundColor = .black.withAlphaComponent(0.3)
            $0.isUserInteractionEnabled = true
            $0.tapHandle {
                self.hidePopup {
                    self.dismiss(animated: true)
                }
            }
        }
        
        containerView  >>> view >>> {
            $0.snp.makeConstraints {
                $0.width.equalTo(widthOfCell)
                $0.height.equalTo(heightOfCell)
                $0.trailing.equalToSuperview()
                $0.top.equalToSuperview()
            }
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.layer.masksToBounds = true
        }
    }
    
    private func showPopup() {
        
        DispatchQueue.main.async {
            self.containerView.alpha = 0
            self.view.layoutIfNeeded()
            self.containerView.snp.updateConstraints {
                self.containerView.alpha = 1
                $0.width.equalTo(self.widthOfCell)
                $0.height.equalTo(self.heightOfCell * self.actions.count.cgFloat)
            }
            
            for item in self.actions {
                item.updateUI()
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    private func hidePopup(_ completion: @escaping() -> Void) {
        self.view.layoutIfNeeded()
        containerView.snp.updateConstraints {
            $0.width.equalTo(79)
            $0.height.equalTo(79)
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.containerView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            completion()
        })
    }

}


// MARK: - ImportAction
class ImportAction: UIView {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    init(title: String, image: String? = nil, style: UIAlertAction.Style = .default, handler: ((ImportAction) -> Void)? = nil) {
        super.init(frame: .zero)
        self.setupView()
        self.titleLabel.text = title
        if let image = image {
            self.image = image
            self.imageView.image = UIImage(named: image)
        } else{
            self.image = nil
        }
        self.actionHandle = handler
        
        switch style {
        case .default:
            self.titleLabel.font = UIFont.systemFont(ofSize: 17)
            self.titleLabel.textColor = .black
            break
        case .cancel:
            self.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
            self.titleLabel.textColor = .black
            break
        case .destructive:
            self.titleLabel.font = UIFont.systemFont(ofSize: 17)
            self.titleLabel.textColor = .red
            if let image = self.imageView.image {
                let customImage = image.withRenderingMode(.alwaysTemplate)
                imageView.image = customImage
                imageView.tintColor = .red
            }
            break
        @unknown default:
            break
        }
    }
    
    //Variables
    var actionHandle: ((ImportAction) -> Void)?
    let imageView = UIImageView()
    let titleLabel = UILabel()
    var image: String?
}

//MARK: Functions
extension ImportAction {
    func updateUI() {
        if self.image == nil {
            titleLabel.snp.remakeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
            }
        } else {
            imageView.snp.remakeConstraints {
                $0.trailing.equalToSuperview().offset(-16)
            }
            titleLabel.snp.remakeConstraints {
               $0.leading.equalToSuperview().offset(16)
               $0.trailing.equalTo(imageView.snp.leading).offset(-16)
            }
        }
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        imageView >>> self >>> {
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview()
                $0.height.equalToSuperview().multipliedBy(0.5)
                $0.width.equalTo(imageView.snp.height).multipliedBy(1)
            }
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel >>> self >>> {
            $0.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.leading.equalToSuperview()
                $0.trailing.equalTo(imageView.snp.leading)
            }
            $0.font = UIFont(name: FNames.regular, size: 16)
            $0.textColor = .black
        }
        
        UIView() >>> self >>> {
            $0.snp.makeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(0.5)
            }
            $0.backgroundColor = .gray
        }
    }

}
