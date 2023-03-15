//
//  RealmDB.swift
//  TodoList
//
//  Created by NhanHoo23 on 07/03/2023.
//

import RealmSwift
import UIKit

class RealmDB: NSObject {
    static let shared: RealmDB = RealmDB()
    
    let realm: Realm!
    
    override init() {
        self.realm = try! Realm()
    }
    
    func update<T>(_ object: T) where T: Object {
        try! realm.write {
            realm.add(object, update: .all)
            print("added new object: \(object)")
        }
    }
    
    func delete<T>(object: T) where T: Object {
        try! realm.write {
            print("deleting: \(object)")
            realm.delete(object)
            print("deleted!")
        }
    }
    
        
    func getObjects<T>(type: T.Type) -> [T] where T: Object {
        let objects = realm.objects(type)
        return Array(objects)
    }
    
    func getObjects<T>(type: T.Type, predicate: NSPredicate) -> [T] where T: Object {
        let objects = realm.objects(type).filter(predicate)
        return Array(objects)
    }
}
