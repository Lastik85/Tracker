enum Week: String, CaseIterable, Codable {
    
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
    
    var shortName: String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }
    var calendarDay: Int {
        switch self{
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thursday: return 5
        case .friday: return 6
        case .saturday: return 7
        case .sunday: return 1
        }
    }
}
extension Week: Comparable {
    static func < (lhs: Week, rhs: Week) -> Bool {
        guard let lhsIndex = Week.allCases.firstIndex(of: lhs),
              let rhsIndex = Week.allCases.firstIndex(of: rhs) else {
            return false
        }
        return lhsIndex < rhsIndex
    }
    
    static func decode(from encoded: Int64) -> Set<Week> {
        var result = Set<Week>()
        for (index, day) in Week.allCases.enumerated() {
            if (encoded & (1 << index)) != 0 {
                result.insert(day)
            }
        }
        return result
    }
    
    static func encode(_ set: Set<Week>) -> Int64 {
        var result: Int64 = 0
        for (index, day) in Week.allCases.enumerated() {
            if set.contains(day) {
                result |= (1 << index)
            }
        }
        return result
    }
    
    
}

