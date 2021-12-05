//
//  Date.swift
//  SpaceX
//
//  Created by Jayesh Tejwani on 04/12/21.
//

import UIKit

let _serverFormatter: DateFormatter = {
    let df = DateFormatter()
    df.timeZone = TimeZone(abbreviation: "UTC")
    df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    df.locale = Locale(identifier: "en_US_POSIX")
    return df
}()

let _deviceFormatter: DateFormatter = {
    let df = DateFormatter()
    df.timeZone = TimeZone.current
    df.dateFormat = "yyyy-MM-dd"
    return df
}()

extension Date {
    
    static func dateFromServerFormat(from string: String, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> Date? {
        _serverFormatter.dateFormat = format
        return _serverFormatter.date(from: string)
    }
    
    static func localDateString(from date: Date?, format: String = "yyyy-MM-dd") -> String{
        _deviceFormatter.dateFormat = format
        if let _ = date{
            return _deviceFormatter.string(from: date!)
        }else{
            return ""
        }
    }
    
    func getYearIndex() -> Int {
        var cal = Calendar.current
        cal.locale = Locale.current
        let comp = cal.dateComponents([.year], from: self)
        let year = comp.year == nil ? 0 : comp.year!
        return year
    }
    
    func getCurrentYear() -> Date {
        let year = getYearIndex()
        return Calendar.current.date(from: DateComponents(year: year, month: 1, day: 1))!
    }
    
    func getNextYear() -> Date {
        let year = getYearIndex() + 1
        return Calendar.current.date(from: DateComponents(year: year, month: 1, day: 1))!
    }
}
