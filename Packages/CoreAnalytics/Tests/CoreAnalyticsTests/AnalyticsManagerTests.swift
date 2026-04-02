import XCTest
@testable import CoreAnalytics

// MARK: - Spy Adapter

private actor SpyAdapter: AnalyticsAdapter {
    private(set) var trackedEvents: [any AnalyticsEvent] = []

    func track(_ event: any AnalyticsEvent) async {
        trackedEvents.append(event)
    }

    func eventCount() -> Int { trackedEvents.count }
    func firstName() -> String? { trackedEvents.first?.name }
}

// MARK: - Tests

final class AnalyticsManagerTests: XCTestCase {

    func testRegisteredAdapterReceivesEvent() async {
        let manager = AnalyticsManager()
        let spy = SpyAdapter()
        await manager.register(adapter: spy)

        await manager.track(AppLaunchEvent(coldStart: true))

        let count = await spy.eventCount()
        XCTAssertEqual(count, 1)
        let name = await spy.firstName()
        XCTAssertEqual(name, "app_launch")
    }

    func testMultipleAdaptersAllReceiveEvent() async {
        let manager = AnalyticsManager()
        let spy1 = SpyAdapter()
        let spy2 = SpyAdapter()
        await manager.register(adapter: spy1)
        await manager.register(adapter: spy2)

        await manager.track(AppBackgroundEvent())

        let count1 = await spy1.eventCount()
        let count2 = await spy2.eventCount()
        XCTAssertEqual(count1, 1)
        XCTAssertEqual(count2, 1)
    }

    func testNoAdaptersDoesNotCrash() async {
        let manager = AnalyticsManager()
        await manager.track(AppForegroundEvent())
        // Just verifying no crash
        XCTAssertTrue(true)
    }

    func testEventParametersAreForwarded() async {
        let manager = AnalyticsManager()
        let spy = SpyAdapter()
        await manager.register(adapter: spy)

        await manager.track(AppLaunchEvent(coldStart: false))

        let events = await spy.trackedEvents
        let launch = events.first as? AppLaunchEvent
        XCTAssertEqual(launch?.coldStart, false)
    }
}
