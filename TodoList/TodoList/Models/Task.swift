//
//  Task.swift
//  TodoList
//
//  Created by NhanHoo23 on 07/03/2023.
//

import MTSDK
import RealmSwift

enum TagColor: String, CaseIterable {
    case pink, red, darkGreen, darkYellow, lightYellow, lightBlue, lightPurple, lightGray, darkGray, darkPurple, darkBlue, orange, brown, lightGreen, black, none
    
    var color: String {
        switch self {
        case .pink: return "#fe8ea1"
        case .red: return "#f33c2c"
        case .darkGreen: return "#29b679"
        case .darkYellow: return "#fecc3c"
        case .lightYellow: return "#cbdc37"
        case .lightBlue: return "#79e0e7"
        case .lightPurple: return "#8f83a5"
        case .lightGray: return "#8ea9bd"
        case .darkGray: return "#999999"
        case .darkPurple: return "#7467fc"
        case .darkBlue: return "#4c90ed"
        case .orange: return "#e68918"
        case .brown: return "#523636"
        case .lightGreen: return "#36d292"
        case .black: return "#474747"
        case .none: return "none"
        }
    }
}

enum SortType {
    case byCreation, byScheduled, byAlphabetical
    var title: String {
        switch self {
        case .byCreation: return "by Creation"
        case .byScheduled: return "by Scheduled"
        case .byAlphabetical: return "by Alphabetical"
        }
    }
}

enum TaskCheck {
    case finished, unfinished
    var check: Bool {
        switch self {
        case .finished: return true
        case .unfinished: return false
        }
    }
}

enum TaskPin {
    case pin, unpin
    var check: Bool {
        switch self {
        case .pin: return true
        case .unpin: return false
        }
    }
}

class RealmTaksModel: Object {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var tagColor: String = TagColor.none.color
    @Persisted var task: String = ""
    @Persisted var date: Date!
    @Persisted var pin: Bool = TaskPin.unpin.check
    @Persisted var time: Date?
    @Persisted var note: String = ""
    @Persisted var doneCheck: Bool = TaskCheck.unfinished.check
    @Persisted var timeCreation: Date!
    
    convenience init(id: String = UUID().uuidString, task: String, date: Date = Date(), note: String = "", time: Date? = nil, tagColor: String = TagColor.none.color, pin: Bool = TaskPin.unpin.check, doneCheck: Bool = TaskCheck.unfinished.check, timeCreation: Date = Date()) {
        self.init()
        self.id = id
        self.tagColor = tagColor
        self.task = task
        self.date = date
        self.pin = pin
        self.time = time
        self.doneCheck = doneCheck
        self.note = note
        self.timeCreation = timeCreation
    }
    
    convenience init(from: TaskModel) {
        self.init()
        self.id = from.id
        self.tagColor = from.tagColor
        self.task = from.task
        self.date = from.date
        self.pin = from.pin
        self.time = from.time
        self.doneCheck = from.doneCheck
        self.note = from.note
        self.timeCreation = from.timeCreation
    }
}

class TaskModel {
    var id: String = ""
    var tagColor: String = TagColor.none.color
    var task: String = ""
    var date: Date!
    var pin: Bool = TaskPin.unpin.check
    var time: Date?
    var doneCheck: Bool = TaskCheck.unfinished.check
    var note: String = ""
    var timeCreation: Date!
    
    init() {}
    
    init(id: String = UUID().uuidString, task: String, date: Date = Date(), note: String = "", time: Date? = nil, tagColor: String = TagColor.none.color, pin: Bool = TaskPin.unpin.check, doneCheck: Bool = TaskCheck.unfinished.check, timeCreation: Date = Date()) {
        self.id = id
        self.tagColor = tagColor
        self.task = task
        self.date = date
        self.pin = pin
        self.time = time
        self.doneCheck = doneCheck
        self.note = note
        self.timeCreation = timeCreation
    }
    
    init(from: RealmTaksModel) {
        self.id = from.id
        self.tagColor = from.tagColor
        self.task = from.task
        self.date = from.date
        self.pin = from.pin
        self.time = from.time
        self.doneCheck = from.doneCheck
        self.note = from.note
        self.timeCreation = from.timeCreation
    }
    
}
