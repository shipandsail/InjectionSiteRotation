// InjectionSiteRotation — track subcutaneous injection sites and suggest the next one.
// Logging and rotation only: this library never recommends or calculates doses.
// More: https://bluedoseapp.com/features/injection-site-rotation-app/
import Foundation

public enum BodyArea: String, CaseIterable, Codable, Sendable { case abdomen, thigh, upperArm }
public enum Side: String, CaseIterable, Codable, Sendable { case left, right }

public struct InjectionSite: Hashable, Codable, Sendable, CustomStringConvertible {
    public let area: BodyArea
    public let side: Side
    public init(_ area: BodyArea, _ side: Side) { self.area = area; self.side = side }
    public static let all: [InjectionSite] = BodyArea.allCases.flatMap { a in Side.allCases.map { InjectionSite(a, $0) } }
    public var description: String {
        let a = ["abdomen": "Abdomen", "thigh": "Thigh", "upperArm": "Upper arm"][area.rawValue]!
        return "\(a), \(side.rawValue)"
    }
}

public struct InjectionLog: Codable, Sendable {
    public let site: InjectionSite
    public let date: Date
    public init(site: InjectionSite, date: Date) { self.site = site; self.date = date }
}

public struct SiteRotation: Sendable {
    /// Sites the user allows (e.g. some people never use the upper arm).
    public var enabledSites: [InjectionSite]
    public init(enabledSites: [InjectionSite] = InjectionSite.all) { self.enabledSites = enabledSites }

    /// Suggests the enabled site used least recently (never-used sites first, in a stable order).
    /// Ties are broken by preferring a different body area and side than the last injection.
    public func nextSite(history: [InjectionLog]) -> InjectionSite? {
        guard !enabledSites.isEmpty else { return nil }
        let sorted = history.sorted { $0.date < $1.date }
        var lastUse: [InjectionSite: Date] = [:]
        for log in sorted { lastUse[log.site] = log.date }
        let last = sorted.last?.site
        return enabledSites.enumerated().min { a, b in
            let da = lastUse[a.element] ?? .distantPast, db = lastUse[b.element] ?? .distantPast
            if da != db { return da < db }
            let pa = penalty(a.element, last), pb = penalty(b.element, last)
            if pa != pb { return pa < pb }
            return a.offset < b.offset
        }?.element
    }

    /// Days since each enabled site was last used (nil if never).
    public func daysSinceUse(history: [InjectionLog], now: Date = Date()) -> [InjectionSite: Int?] {
        var out: [InjectionSite: Int?] = [:]
        for s in enabledSites {
            let d = history.filter { $0.site == s }.map(\.date).max()
            out.updateValue(d.map { Calendar.current.dateComponents([.day], from: $0, to: now).day ?? 0 }, forKey: s)
        }
        return out
    }

    private func penalty(_ s: InjectionSite, _ last: InjectionSite?) -> Int {
        guard let l = last else { return 0 }
        return (s.area == l.area ? 2 : 0) + (s.side == l.side ? 1 : 0)
    }
}
