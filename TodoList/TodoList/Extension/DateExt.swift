//
//  DateExt.swift
//  TodoList
//
//  Created by NhanHoo23 on 08/03/2023.
//

import MiTu

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        
        return dateFormat.string(from: self)
    }
}
