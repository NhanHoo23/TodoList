//
//  AppContraints.swift
//  TodoList
//
//  Created by NhanHoo23 on 07/03/2023.
//

import MiTu

struct Color {
    static let mainBackground: UIColor = .from("F4E2C6")
    static let popupColor: UIColor = .from("F2F6F5")
    static let textColor: UIColor = .black
}

struct FNames {
    static let regular = "Roboto-Regular"
    static let italic = "Roboto-Italic"
    static let thin = "Roboto-Thin"
    static let light = "Roboto-Light"
    static let bold = "Roboto-Bold"
    static let medium = "Roboto-Medium"
    static let black = "Roboto-Black"
    static let boldItalic = "Roboto-BoldItalic"
}

struct ItemSize {
    static let addTaskViewHeight: CGFloat = 135
    static let colorViewHeight: CGFloat = 24 * 5 + 30 * 4
    static let datePickerViewHeight: CGFloat = botSafeHeight + 398
    static let timePickerViewHeight: CGFloat = botSafeHeight + 438
    static let buttonSize: CGFloat = 41
}

struct PaddingScreen {
    static let topLeft: CGFloat = 16
    static let bottomRight: CGFloat = -16
}

