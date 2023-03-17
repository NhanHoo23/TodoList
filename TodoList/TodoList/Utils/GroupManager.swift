//
//  GroupManager.swift
//  TodoList
//
//  Created by NhanHoo23 on 17/03/2023.
//

import MTSDK

class GroupManager {    
    var groups: [GroupModel] = [GroupModel(name: "All"),
                                           GroupModel(name: "Today"),
                                           GroupModel(name: "Default"),
                                           GroupModel(name: "+")]
    var selectedGroupIndexPath: IndexPath = IndexPath(item: 0, section: 0)
}

extension GroupManager {
    func addGroup(_ group: GroupModel, _ colletionView: UICollectionView) {
        DispatchQueue.main.async {
            self.groups.insert(group, at: self.groups.count - 1)
            
            colletionView.reloadData()
            self.selectedGroupIndexPath = IndexPath(item: self.groups.count - 2, section: 0)
            colletionView.scrollToItem(at: self.selectedGroupIndexPath, at: .centeredHorizontally, animated: true)
            
            let realmModel = RealmGroupModel(from: group)
            RealmDB.shared.update(realmModel)
        }
    }
    
    func deleteGroup(_ group: GroupModel) {
        DispatchQueue.main.async {
            self.groups.removeAll(where: {$0.id == group.id})
            
            let realmModel = RealmGroupModel(from: group)
            RealmDB.shared.update(realmModel)
            RealmDB.shared.delete(object: realmModel)
        }
    }
    
    func loadData() {
        let groupObject = RealmDB.shared.getObjects(type: RealmGroupModel.self)
        let groupArr = groupObject.compactMap({GroupModel(from: $0)})
        self.groups.insert(contentsOf: groupArr, at: self.groups.count - 1)
    }
}
