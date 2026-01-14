import Foundation
import AppMetricaCore

final class AnalyticsService {
    
    // MARK: - Singleton
    
    static let shared = AnalyticsService()
    private init() {}
    
    // MARK: - Activation
    
    func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: AppMetricaKey.key) else { return }
        
        AppMetrica.activate(with: configuration)
    }
    
    // MARK: - Private base method
    
    private func report(event: Event, params: [String: Any]) {
        AppMetrica.reportEvent(
            name: event.rawValue,
            parameters: params,
            onFailure: { error in
                print("📉 ANALYTICS ERROR:", error.localizedDescription)
            }
        )
        
        // Логи для тестов
        print("📊 EVENT:", event.rawValue," PARAMS:", params)
    }
    
    // MARK: - Public API (Convenience)
    
    func reportScreenOpen(_ screen: Screen) {
        report(
            event: .open,
            params: ["event": Event.open.rawValue,
                     "screen": screen.rawValue
                    ]
        )
    }
    
    func reportScreenClose(_ screen: Screen) {
        report(
            event: .close,
            params: ["event": Event.close.rawValue,
                     "screen": screen.rawValue
                    ]
        )
    }
    
    func reportClick(screen: Screen, item: Item) {
        report(
            event: .click,
            params: ["event": Event.click.rawValue,
                     "screen": screen.rawValue,
                     "item": item.rawValue
                    ]
        )
    }
}

// MARK: - Analytics Types

extension AnalyticsService {
    
    enum Event: String {
        case open
        case close
        case click
    }
    
    enum Screen: String {
        case main = "Main"
    }
    
    enum Item: String {
        case addTrack = "add_track"
        case track
        case filter
        case edit
        case delete
    }
}

// MARK: - API Key

enum AppMetricaKey {
    static let key = "27647f33-6c49-436c-94ad-8800d8122f83"
}
