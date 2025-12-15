import Foundation
@objc
final class WeekDaysTransformer: ValueTransformer {
    
    static func register() {
        ValueTransformer.setValueTransformer(
            WeekDaysTransformer(),
            forName: NSValueTransformerName(String(describing: WeekDaysTransformer.self))
        )
    }
    
    override class func transformedValueClass() -> AnyClass { NSData.self }
    
    override class func allowsReverseTransformation() -> Bool { true }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? Set<Week> else { return nil }
        do {
            return try JSONEncoder().encode(days)
        } catch {
            print("Encoding error: \(error)")
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        do {
            return try JSONDecoder().decode(Set<Week>.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            return nil
        }
    }
}
