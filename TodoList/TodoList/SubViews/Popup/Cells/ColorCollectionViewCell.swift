//
//  ColorCollectionViewCell.swift
//  TodoList
//
//  Created by NhanHoo23 on 08/03/2023.
//

import MTSDK

class ColorCollectionViewCell: UICollectionViewCell {
    
    
    //Variables
    var containerView: UIView!
    let noneLb = UILabel()
    let checkImg = UIImageView()
}


//MARK: Functions
extension ColorCollectionViewCell {
    func configsCell(color: TagColor, isSelected:Bool) {
        if containerView == nil {
            self.setupView()
        }
        containerView.backgroundColor = color.color == "none" ? .clear : .from(color.color)
        noneLb.isHidden = !(color.color == "none")
        if isSelected {
            if color.color == "none" {
                containerView.layer.borderColor = UIColor.clear.cgColor
            } else {
                containerView.layer.borderColor = UIColor.black.cgColor
            }
        } else {
            containerView.layer.borderColor = UIColor.clear.cgColor
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
            $0.layer.cornerRadius = 15
            $0.layer.borderWidth = 3
        }
        
        noneLb >>> containerView >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.text = "none"
            $0.textColor = .black
            $0.adjustsFontSizeToFitWidth = true
        }
        
        
    }

}
