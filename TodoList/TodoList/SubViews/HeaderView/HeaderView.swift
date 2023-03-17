//
//  Header2View.swift
//  TodoList
//
//  Created by NhanHoo23 on 17/03/2023.
//

import MTSDK

class HeaderView: UIView {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    //Variables
    let appImg = UIImageView()
    let optionsBt = UIButton()
    let searchBt = UIButton()
    let sortBt = UIView()
    let sortType = UILabel()
    
    var sortHandle: (() -> Void)?
}


//MARK: SetupView
extension HeaderView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.sortBt.layer.cornerRadius = self.frame.height / 2
    }
    
    private func setupView() {
        appImg >>> self >>> {
            $0.snp.makeConstraints {
                $0.top.leading.bottom.equalToSuperview()
                $0.width.equalTo(appImg.snp.height).multipliedBy(1)
            }
            $0.image = UIImage(named: "img_app")
        }
        
        optionsBt >>> self >>> {
            $0.snp.makeConstraints {
                $0.trailing.top.bottom.equalToSuperview()
                $0.width.equalTo(optionsBt.snp.height).multipliedBy(1)
            }
            $0.setImage(UIImage(systemName: "ellipsis.circle.fill"), for: .normal)
            $0.tintColor = .black
        }
        
        searchBt >>> self >>> {
            $0.snp.makeConstraints {
                $0.trailing.equalTo(optionsBt.snp.leading).offset(-4)
                $0.top.bottom.equalToSuperview()
                $0.width.equalTo(searchBt.snp.height).multipliedBy(1)
            }
            $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            $0.tintColor = .black
        }
        
        sortBt >>> self >>> {
            $0.snp.makeConstraints {
                $0.trailing.equalTo(searchBt.snp.leading).offset(-4)
                $0.top.bottom.equalToSuperview()
            }
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray.cgColor
            $0.isUserInteractionEnabled = true
            $0.tapHandle {
//                self.showPopupView(sourceView: self.sortBt)
            }
        }
        
        let imgView = UIImageView()
        imgView >>> sortBt >>> {
            $0.snp.makeConstraints {
                $0.top.equalToSuperview().offset(4)
                $0.leading.equalToSuperview().offset(8)
                $0.bottom.equalToSuperview().offset(-4)
                $0.width.equalTo(imgView.snp.height).multipliedBy(1)
            }
            $0.image = UIImage(systemName: "list.bullet")
            $0.tintColor = .black
            $0.contentMode = .scaleAspectFit
        }
        
        sortType >>> sortBt >>> {
            $0.snp.makeConstraints {
                $0.leading.equalTo(imgView.snp.trailing).offset(4)
                $0.bottom.equalToSuperview().offset(-4)
                $0.trailing.equalToSuperview().offset(-8)
                $0.top.equalToSuperview().offset(4)
            }
            $0.text = AppManager.shared.sortType
            $0.textColor = Color.textColor
        }
    }

}


//MARK: Functions
extension HeaderView {

}
