//
//  TextOptionsView.swift
//  TodoList
//
//  Created by NhanHoo23 on 13/03/2023.
//

import MiTu

enum TextFont {
    case regular
    case medium
    case bold
    
    var font: UIFont {
        switch self {
        case .regular:
            return UIFont(name: FNames.regular, size: 16)!
        case .bold:
            return UIFont(name: FNames.bold, size: 22)!
        case .medium:
            return UIFont(name: FNames.medium, size: 16)!
        }
    }
}

enum LineMarkType {
    case none
    case bullet
    case number
}

class TextOptionsView: UIView {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    //Variables
    let containerView = UIView()
    let stackView = UIStackView()
    
    let fontBt = UIButton()
    
    let textStyleView = UIView()
    let stackView1 = UIStackView()
    let boldBt = UIButton()
    let italicBt = UIButton()
    let underlineBt = UIButton()
    
    let listStyleView = UIView()
    let stackView2 = UIStackView()
    let numberListStyleBt = UIButton()
    let dotListStyleBt = UIButton()
    let linkBt = UIButton()
    
    let viewWidth: CGFloat = (maxWidth - 60 - 16 * 4) / 2
    let buttonBackgroundColor: UIColor = .lightGray.withAlphaComponent(0.3)
    let buttonBackgroundColorSeleted: UIColor = .from("8FBDC7").withAlphaComponent(0.3)
    
    var isSelectedBold: Bool = false {
        didSet {
            self.updateBoldButton(isSelected: self.isSelectedBold)
        }
    }
    var isSelectedItalic: Bool = false {
        didSet {
            self.updateItalicButton(isSelected: self.isSelectedItalic)
        }
    }
    var isSelectedUnderline: Bool = false {
        didSet {
            self.updateUnderlineButton(isSelected: self.isSelectedUnderline)
        }
    }
    var isSeletedNumberList: Bool = false {
        didSet {
            self.updateNumberListButton(isSelected: self.isSeletedNumberList)
        }
    }
    var isSelectedDotList: Bool = false {
        didSet {
            self.updateDotListButton(isSelected: self.isSelectedDotList)
        }
    }
    
    var textFont: TextFont = .regular
    var count: Int = 1 {
        didSet {
            self.updateFontButton(count: self.count)
        }
    }
}


//MARK: SetupView
extension TextOptionsView {
    private func setupView() {
        containerView >>> self >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        stackView >>> containerView >>> {
            $0.snp.makeConstraints {
                $0.top.equalToSuperview().offset(8)
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
                $0.bottom.equalToSuperview().offset(-8)
            }
            $0.distribution = .fill
            $0.spacing = 16
        }
        
        fontBt.layer.cornerRadius = 5
        fontBt.backgroundColor = self.buttonBackgroundColor
        fontBt.setTitle("Regular", for: .normal)
        fontBt.titleLabel?.font = UIFont(name: FNames.regular, size: 12)
        fontBt.setTitleColor(.black, for: .normal)
        fontBt.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        textStyleView.layer.cornerRadius = 5
        textStyleView.layer.masksToBounds = true
        textStyleView.widthAnchor.constraint(equalToConstant: self.viewWidth).isActive = true
        
        boldBt.backgroundColor = self.buttonBackgroundColor
        boldBt.setImage(UIImage(systemName: "bold"), for: .normal)
        boldBt.tintColor = .black
        italicBt.backgroundColor = self.buttonBackgroundColor
        italicBt.setImage(UIImage(systemName: "italic"), for: .normal)
        italicBt.tintColor = .black
        underlineBt.backgroundColor = self.buttonBackgroundColor
        underlineBt.setImage(UIImage(systemName: "underline"), for: .normal)
        underlineBt.tintColor = .black
        
        stackView1 >>> textStyleView >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.distribution = .fillEqually
            $0.spacing = 2
            $0.addArrangedSubview(boldBt)
            $0.addArrangedSubview(italicBt)
            $0.addArrangedSubview(underlineBt)
        }

        listStyleView.layer.cornerRadius = 5
        listStyleView.layer.masksToBounds = true
        listStyleView.widthAnchor.constraint(equalToConstant: self.viewWidth).isActive = true
        
        numberListStyleBt.backgroundColor = self.buttonBackgroundColor
        numberListStyleBt.setImage(UIImage(systemName: "list.number"), for: .normal)
        numberListStyleBt.tintColor = .black
        dotListStyleBt.backgroundColor = self.buttonBackgroundColor
        dotListStyleBt.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        dotListStyleBt.tintColor = .black
        linkBt.backgroundColor = self.buttonBackgroundColor
        linkBt.setImage(UIImage(systemName: "link"), for: .normal)
        linkBt.tintColor = .black
        
        stackView2 >>> listStyleView >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.spacing = 2
            $0.distribution = .fillEqually
            $0.addArrangedSubview(numberListStyleBt)
            $0.addArrangedSubview(dotListStyleBt)
            $0.addArrangedSubview(linkBt)
        }
        
        stackView.addArrangedSubview(fontBt)
        stackView.addArrangedSubview(textStyleView)
        stackView.addArrangedSubview(listStyleView)
        
        boldBt.handle {
            self.isSelectedBold.toggle()
        }
        
        italicBt.handle {
            self.isSelectedItalic.toggle()
        }
        
        underlineBt.handle {
            self.isSelectedUnderline.toggle()
        }
        
        numberListStyleBt.handle {
            self.isSeletedNumberList.toggle()
        }
        
        dotListStyleBt.handle {
            self.isSelectedDotList.toggle()
        }
        
        fontBt.handle {
            self.count += 1
            
            if self.count >= 2 {
                self.isSelectedBold = true
                if self.count == 4 {
                    self.count = 1
                    self.isSelectedBold = false
                }
            }
            
        }
    }

}


//MARK: Functions
extension TextOptionsView {
    func updateBoldButton(isSelected: Bool) {
        if isSelected {
            self.boldBt.tintColor = .blue
            self.boldBt.backgroundColor = self.buttonBackgroundColorSeleted
        } else {
            self.boldBt.tintColor = .black
            self.boldBt.backgroundColor = self.buttonBackgroundColor
            self.count = 1
        }
    }
    
    func updateItalicButton(isSelected: Bool) {
        if isSelected {
            self.italicBt.tintColor = .blue
            self.italicBt.backgroundColor = self.buttonBackgroundColorSeleted
        } else {
            self.italicBt.tintColor = .black
            self.italicBt.backgroundColor = self.buttonBackgroundColor
        }
    }
    
    func updateUnderlineButton(isSelected: Bool) {
        if isSelected {
            self.underlineBt.tintColor = .blue
            self.underlineBt.backgroundColor = self.buttonBackgroundColorSeleted
        } else {
            self.underlineBt.tintColor = .black
            self.underlineBt.backgroundColor = self.buttonBackgroundColor

        }
    }
    
    func updateNumberListButton(isSelected: Bool) {
        if isSelected {
            self.isSelectedDotList = false
            self.numberListStyleBt.tintColor = .blue
            self.numberListStyleBt.backgroundColor = self.buttonBackgroundColorSeleted
        } else {
            self.numberListStyleBt.tintColor = .black
            self.numberListStyleBt.backgroundColor = self.buttonBackgroundColor

        }
    }
    
    func updateDotListButton(isSelected: Bool) {
        if isSelected {
            self.isSeletedNumberList = false
            self.dotListStyleBt.tintColor = .blue
            self.dotListStyleBt.backgroundColor = self.buttonBackgroundColorSeleted
        } else {
            self.dotListStyleBt.tintColor = .black
            self.dotListStyleBt.backgroundColor = self.buttonBackgroundColor

        }
    }
    
    func updateFontButton(count: Int) {
        switch count {
        case 1:
            self.textFont = .regular
            self.fontBt.setTitle("Regular", for: .normal)
            self.fontBt.titleLabel?.font = UIFont(name: FNames.regular, size: 12)
            break
        case 2:
            self.textFont = .medium
            self.fontBt.setTitle("Medium", for: .normal)
            self.fontBt.titleLabel?.font = UIFont(name: FNames.medium, size: 12)
            break
        case 3:
            self.textFont = .bold
            self.fontBt.setTitle("Bold", for: .normal)
            self.fontBt.titleLabel?.font = UIFont(name: FNames.bold, size: 14)
            break
        default:
            break
        }
    }
}
