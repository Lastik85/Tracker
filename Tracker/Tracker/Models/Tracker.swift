import Foundation

struct Tracker{
    let id: UUID
    let name: String
    let color: String
    let emoji: String
    let schedule: [Week]
}

enum Week: String, Codable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}
