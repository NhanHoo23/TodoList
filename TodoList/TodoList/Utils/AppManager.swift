//
//  AppManager.swift
//  TodoList
//
//  Created by NhanHoo23 on 07/03/2023.
//

import MiTu

class AppManager {
    static let shared = AppManager()
    
    var firstEnterTheApp: Bool = false
    var sortType: String {
        get {
            if let currentSortType = UserDefaults.standard.string(forKey: "sortType") {
                return currentSortType
            }
            return SortType.byCreation.title
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "sortType")
            UserDefaults.standard.synchronize()
        }
    }
    
    var keyboardHeight: CGFloat = 0
}
