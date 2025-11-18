//
//  Tracker.swift
//  Tracker
//
//  Created by Андрей Пермяков on 18.11.2025.
//
import UIKit
struct Tracker {
    var id: UUID
    var name: String
    var color: UIColor
    var emoji: String
    var schedule: [Week]
}

enum Week {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}
