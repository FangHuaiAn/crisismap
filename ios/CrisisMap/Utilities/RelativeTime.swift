import Foundation

private nonisolated(unsafe) let isoFormatter: ISO8601DateFormatter = {
    let f = ISO8601DateFormatter()
    f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return f
}()

private nonisolated(unsafe) let isoFormatterNoFrac: ISO8601DateFormatter = {
    let f = ISO8601DateFormatter()
    f.formatOptions = [.withInternetDateTime]
    return f
}()

func parseISO(_ string: String) -> Date {
    isoFormatter.date(from: string)
        ?? isoFormatterNoFrac.date(from: string)
        ?? .distantPast
}

func relativeTime(from isoString: String) -> String {
    let date = parseISO(isoString)
    let seconds = Int(Date.now.timeIntervalSince(date))

    if seconds < 60 {
        return String(localized: "time.now")
    }
    if seconds < 3600 {
        let n = seconds / 60
        let fmt = String(localized: "time.mAgo")
        return String(format: fmt, n)
    }
    if seconds < 86400 {
        let n = seconds / 3600
        let fmt = String(localized: "time.hAgo")
        return String(format: fmt, n)
    }
    let n = seconds / 86400
    let fmt = String(localized: "time.dAgo")
    return String(format: fmt, n)
}
