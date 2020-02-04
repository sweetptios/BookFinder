//
//  Date+.swift
//  BookFinder
//
//  Created by GOOK HEE JUNG on 2020/02/03.
//  Copyright © 2020 sweetpt365. All rights reserved.
//

import Foundation

//MARK: - Date
#warning("TODO - 날짜 포맷 세련되게 안만들거면 안쓰는 코드 정리하기")
public enum DateComponentType {
    case second, minute, hour, day, weekday, weekdayOrdinal, week, month, year
}

extension Date {
    private static let minuteInSeconds: Double = 60
    private static let hourInSeconds: Double = 3600
    private static let dayInSeconds: Double = 86400
    private static let weekInSeconds: Double = 604800
    private static let yearInSeconds: Double = 31556926

    public enum DateComparisonType {
        // Days
        case isToday
        case isTomorrow
        case isYesterday
        case isSameDay(as:Date)
        // Weeks
        case isThisWeek
        case isNextWeek
        case isLastWeek
        case isSameWeek(as:Date)
        // Months
        case isThisMonth
        case isNextMonth
        case isLastMonth
        case isSameMonth(as:Date)
        // Years
        case isThisYear
        case isNextYear
        case isLastYear
        case isSameYear(as:Date)
        // Relative Time
        case isInTheFuture
        case isInThePast
        case isEarlier(than:Date)
        case isLater(than:Date)
        case isWeekday
        case isWeekend
    }

    public static func componentFlags() -> Set<Calendar.Component> {
        return [.year, .month, .day, .weekOfYear, .hour, .minute, .second, .weekday, .weekdayOrdinal, .weekOfYear]
    }

    // MARK: Init

    public func compare(_ comparison: DateComparisonType) -> Bool {
        switch comparison {
        case .isToday:
            return compare(.isSameDay(as: Date()))
        case .isTomorrow:
            let comparison = Date().adjust(.day, offset: 1)
            return compare(.isSameDay(as: comparison))
        case .isYesterday:
            let comparison = Date().adjust(.day, offset: -1)
            return compare(.isSameDay(as: comparison))
        case .isSameDay(let date):
            return component(.year) == date.component(.year)
                && component(.month) == date.component(.month)
                && component(.day) == date.component(.day)
        case .isThisWeek:
            return self.compare(.isSameWeek(as: Date()))
        case .isNextWeek:
            let comparison = Date().adjust(.week, offset: 1)
            return compare(.isSameWeek(as: comparison))
        case .isLastWeek:
            let comparison = Date().adjust(.week, offset: -1)
            return compare(.isSameWeek(as: comparison))
        case .isSameWeek(let date):
            if component(.week) != date.component(.week) {
                return false
            }
            // Ensure time interval is under 1 week
            return abs(self.timeIntervalSince(date)) < Date.weekInSeconds
        case .isThisMonth:
            return self.compare(.isSameMonth(as: Date()))
        case .isNextMonth:
            let comparison = Date().adjust(.month, offset: 1)
            return compare(.isSameMonth(as: comparison))
        case .isLastMonth:
            let comparison = Date().adjust(.month, offset: -1)
            return compare(.isSameMonth(as: comparison))
        case .isSameMonth(let date):
            return component(.year) == date.component(.year) && component(.month) == date.component(.month)
        case .isThisYear:
            return self.compare(.isSameYear(as: Date()))
        case .isNextYear:
            let comparison = Date().adjust(.year, offset: 1)
            return compare(.isSameYear(as: comparison))
        case .isLastYear:
            let comparison = Date().adjust(.year, offset: -1)
            return compare(.isSameYear(as: comparison))
        case .isSameYear(let date):
            return component(.year) == date.component(.year)
        case .isInTheFuture:
            return self.compare(.isLater(than: Date()))
        case .isInThePast:
            return self.compare(.isEarlier(than: Date()))
        case .isEarlier(let date):
            return (self as NSDate).earlierDate(date) == self
        case .isLater(let date):
            return (self as NSDate).laterDate(date) == self
        case .isWeekday:
            return !compare(.isWeekend)
        case .isWeekend:
            let range = Calendar.current.maximumRange(of: Calendar.Component.weekday)!
            return (component(.weekday) == range.lowerBound || component(.weekday) == range.upperBound - range.lowerBound)
        }
    }

    public func adjust(_ component: DateComponentType, offset: Int) -> Date {
        var dateComp = DateComponents()
        switch component {
        case .second:
            dateComp.second = offset
        case .minute:
            dateComp.minute = offset
        case .hour:
            dateComp.hour = offset
        case .day:
            dateComp.day = offset
        case .weekday:
            dateComp.weekday = offset
        case .weekdayOrdinal:
            dateComp.weekdayOrdinal = offset
        case .week:
            dateComp.weekOfYear = offset
        case .month:
            dateComp.month = offset
        case .year:
            dateComp.year = offset
        }
        return Calendar.current.date(byAdding: dateComp, to: self)!
    }

    public func component(_ component: DateComponentType) -> Int? {
        let components = Calendar.current.dateComponents(Date.componentFlags(), from: self)
        switch component {
        case .second:
            return components.second
        case .minute:
            return components.minute
        case .hour:
            return components.hour
        case .day:
            return components.day
        case .weekday:
            return components.weekday
        case .weekdayOrdinal:
            return components.weekdayOrdinal
        case .week:
            return components.weekOfYear
        case .month:
            return components.month
        case .year:
            return components.year
        }
    }

    public func interval(_ component: DateComponentType, componentFlags: Set<Calendar.Component> = Date.componentFlags(), to: Date = Date()) -> Int? {
        let components = Calendar.current.dateComponents(componentFlags, from: self, to: to)
        switch component {
        case .second:
            return components.second
        case .minute:
            return components.minute
        case .hour:
            return components.hour
        case .day:
            return components.day
        case .weekday:
            return components.weekday
        case .weekdayOrdinal:
            return components.weekdayOrdinal
        case .week:
            return components.weekOfYear
        case .month:
            return components.month
        case .year:
            return components.year
        }
    }

    // MARK: Init

    public init?(from value: String?, format: String?, timeZone: TimeZone? = TimeZone.current) {
        guard let value = value, let format = format else { return nil }
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = timeZone
        formatter.dateFormat = format

        if let date = formatter.date(from: value) {
            self.init(timeIntervalSince1970: date.timeIntervalSince1970)
        } else {
            return nil
        }
    }

    // MARK: String format

    public func string(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style, timeZone: TimeZone? = TimeZone.current) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = timeZone
        formatter.dateStyle = dateStyle
        formatter.dateStyle = timeStyle
        return formatter.string(from: self)
    }

    public func string(format: String, timeZone: TimeZone? = TimeZone.current) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = timeZone
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

// MARK: - age

extension Date {
    /// 만나이
    var fullAge: Int { max(0, self.interval(.year) ?? 0) }
}

