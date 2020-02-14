//
//  Date+.swift
//  BookFinder
//
//  Created by GOOK HEE JUNG on 2020/02/03.
//  Copyright © 2020 sweetpt365. All rights reserved.
//

import Foundation

//MARK: - Date

extension Date {

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

    public func string(format: String, timeZone: TimeZone? = TimeZone.current) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = timeZone
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
