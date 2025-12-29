import Foundation

enum EmojiColorCollectionSection: Int, CaseIterable {
    
    case emoji
    case color
    
    var title: String {
        switch self {
        case .emoji: "Emoji"
        case .color: "Цвет"
        }
    }
    
    var numberOfItems: Int {
        switch self {
        case .emoji:  Constants.emojis.count
        case .color:  Constants.colors.count
        }
    }
}
