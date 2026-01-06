//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Андрей Пермяков on 06.01.2026.
//

import XCTest
import SnapshotTesting
@testable import Tracker

class TrackerTests: XCTestCase {

    func testViewController() {
        let trackerVC = TrackerViewController()
        assertSnapshots(of: trackerVC, as: [.image])
    }

}
