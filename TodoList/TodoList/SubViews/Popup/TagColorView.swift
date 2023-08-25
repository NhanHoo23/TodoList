//
//  TagColorView.swift
//  TodoList
//
//  Created by NhanHoo23 on 08/03/2023.
//

import MiTu

class TagColorView: UIView {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    //Variables
    var colorCollection: UICollectionView!
    let allColors: [TagColor] = TagColor.allCases
    var selectedIndexPath: IndexPath? = nil
    
    var doneHandle: ((TagColor) -> Void)? = nil
}


//MARK: Functions
extension TagColorView {
    private func setupView() {
        self.layer.cornerRadius = 15
        self.backgroundColor = .white
        self.addDropShadow(color: .black, shadowOpacity: 0.6, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 15)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        colorCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colorCollection >>> self >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.backgroundColor = .clear
            $0.delegate = self
            $0.dataSource = self
            $0.registerReusedCell(ColorCollectionViewCell.self)
        }
    }

}

//MARK: Collection
extension TagColorView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusable(cellClass: ColorCollectionViewCell.self, indexPath: indexPath)
        cell.configsCell(color: allColors[indexPath.item], isSelected: self.selectedIndexPath == indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        24
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        self.colorCollection.reloadData()
        
        if let doneHandle = self.doneHandle {
            doneHandle(self.allColors[indexPath.item])
        }
    }
}
