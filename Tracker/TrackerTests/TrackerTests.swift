import XCTest
import SnapshotTesting
@testable import Tracker

class TrackerTests: XCTestCase {

    func testViewControllerLightTheme() {
        let trackerVC = TrackerViewController()
        assertSnapshot(
            of: trackerVC,
            as: .image(on: .iPhone13, traits: UITraitCollection(userInterfaceStyle: .light)),
            named: "light"
        )
    }
    
    func testViewControllerDarkTheme() {
        let trackerVC = TrackerViewController()
        assertSnapshot(
            of: trackerVC,
            as: .image(on: .iPhone13, traits: UITraitCollection(userInterfaceStyle: .dark)),
            named: "dark"
        )
    }

}
