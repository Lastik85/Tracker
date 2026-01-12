import Foundation
import AppMetricaCore

final class AnalyticsService {
    
    static let shared = AnalyticsService()
    
    private init() {}
    
    func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: AppMetricaKey.key) else {
            return
        }
        AppMetrica.activate(with: configuration)
    }
    
    func report(event: String, params : [AnyHashable : Any]) {
            AppMetrica.reportEvent(name: event, parameters: params, onFailure: { error in
                print("REPORT ERROR: %@", error.localizedDescription)
                print("Analytics Event: \(event), Parameters: \(params)")
            })
        }
    
}

enum AppMetricaKey {
    static let key = "27647f33-6c49-436c-94ad-8800d8122f83"
}
