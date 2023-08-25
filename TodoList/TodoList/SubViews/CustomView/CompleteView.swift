//
//  CompleteViewView.swift
//  TodoList
//
//  Created by NhanHoo23 on 16/03/2023.
//

import MiTu

class CompleteView: UIView {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    //Variables
    let arrowImg = UIImageView()
    let label = UILabel()
    
    var isSelected: Bool = false {
        didSet {
            self.updateUI(isSelected: isSelected)
        }
    }
}


//MARK: SetupView
extension CompleteView {
    private func setupView() {
        self.backgroundColor  = .from("D7B279")
        self.layer.cornerRadius = 5
        self.tapHandle {
            self.isSelected.toggle()
        }
        
        arrowImg >>> self >>> {
            $0.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(8)
                $0.centerY.equalToSuperview()
                $0.width.height.equalTo(15)
            }
            $0.tintColor = .black
            $0.image = UIImage(systemName: "chevron.right")
            $0.contentMode = .scaleAspectFit
        }
        
        label >>> self >>> {
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(arrowImg.snp.trailing).offset(8)
            }
            $0.text = "Completed"
            $0.textColor = Color.textColor
            $0.font = UIFont(name: FNames.medium, size: 14)
        }
    }

}


//MARK: Functions
extension CompleteView {
    func updateUI(isSelected: Bool) {
        if isSelected {
            UIView.animate(withDuration: 0.3, animations: {
                self.arrowImg.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.arrowImg.transform = .identity
            })
        }
    }
}
