//
//  TaskViewModel.swift
//  TodoList
//
//  Created by NhanHoo23 on 11/03/2023.
//

import MiTu

class TaskViewModel {
    var date: Date = Date()
    var time: Date?
    var note: String = ""
    var pin: Bool = false
    var tagColor: String = "none"
    
    func reset() {
        date = Date()
        time = nil
        note = ""
        pin = false
        tagColor = "none"
    }
}
