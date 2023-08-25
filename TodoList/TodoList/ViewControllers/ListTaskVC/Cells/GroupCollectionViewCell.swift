//
//  HeaderCollectionViewCell.swift
//  TodoList
//
//  Created by NhanHoo23 on 07/03/2023.
//

import MiTu

class GroupCollectionViewCell: UICollectionViewCell {
    
    
    //Variables
    var containerView: UIView!
    let nameLb = UILabel()
    let lineView = UIView()
}


//MARK: Functions
extension GroupCollectionViewCell {
    func configsCell(group: GroupModel, isSelected: Bool) {
        if containerView == nil {
            self.setupView()
        }
        if group.name == "+" {
            nameLb.text = group.name
        } else {
            nameLb.text = "\(group.name) (\(group.taskCount))"
        }
        if isSelected {
            self.updateUI(isSelected: true)
        } else {
            self.updateUI(isSelected: false)
        }
    }
    
    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        containerView = UIView()
        containerView >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.backgroundColor = .clear
        }
        
        nameLb >>> containerView >>> {
            $0.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.leading.equalToSuperview().offset(8)
                $0.trailing.equalToSuperview().offset(-8)
            }
            $0.textColor = .gray
        }
        
        lineView >>> containerView >>> {
            $0.snp.makeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(3)
            }
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 1.5
        }
    }
    
    func updateUI(isSelected: Bool) {
        if isSelected {
            self.nameLb.textColor = .black
            self.lineView.alpha = 1
        } else {
            self.nameLb.textColor = .gray
            self.lineView.alpha = 0
        }
    }

}
