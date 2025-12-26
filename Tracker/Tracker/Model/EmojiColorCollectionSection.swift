//
//  EmojiColorCollectionSection.swift
//  Tracker
//
//  Created by Андрей Пермяков on 21.12.2025.
//
import Foundation

enum EmojiColorCollectionSection: Int, CaseIterable {

    case emoji
    case color

    var title: String {
        switch self {
        case .emoji:
            return "Emoji"
        case .color:
            return "Цвет"
        }
    }

    var numberOfItems: Int {
        switch self {
        case .emoji:
            return Constants.emojis.count
        case .color:
            return Constants.colors.count
        }
    }
}
