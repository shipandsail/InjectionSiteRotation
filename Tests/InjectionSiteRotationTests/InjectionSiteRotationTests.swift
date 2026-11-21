import XCTest
@testable import InjectionSiteRotation
final class InjectionSiteRotationTests: XCTestCase {
    let d = { (day: Int) in Date(timeIntervalSince1970: TimeInterval(day * 86_400)) }
    func testFirstSuggestion() { XCTAssertEqual(SiteRotation().nextSite(history: []), InjectionSite(.abdomen, .left)) }
    func testAvoidsRecent() {
        let h = [InjectionLog(site: .init(.abdomen, .left), date: d(0))]
        let next = SiteRotation().nextSite(history: h)!
        XCTAssertNotEqual(next.area, .abdomen)   // unused sites first, different area preferred
        XCTAssertNotEqual(next.side, .left)
    }
    func testLeastRecentlyUsed() {
        let r = SiteRotation(enabledSites: [.init(.abdomen, .left), .init(.abdomen, .right)])
        let h = [InjectionLog(site: .init(.abdomen, .left), date: d(0)), InjectionLog(site: .init(.abdomen, .right), date: d(7))]
        XCTAssertEqual(r.nextSite(history: h), InjectionSite(.abdomen, .left))
    }
    func testEmptyEnabled() { XCTAssertNil(SiteRotation(enabledSites: []).nextSite(history: [])) }
    func testDaysSince() {
        let h = [InjectionLog(site: .init(.thigh, .right), date: d(0))]
        let days = SiteRotation().daysSinceUse(history: h, now: d(7))
        XCTAssertEqual(days[InjectionSite(.thigh, .right)]!, 7)
        XCTAssertNil(days[InjectionSite(.abdomen, .left)]!)
    }
}
