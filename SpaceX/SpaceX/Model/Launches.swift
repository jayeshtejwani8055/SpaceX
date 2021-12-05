//
//  Launches.swift
//  SpaceX
//
//  Created by Jayesh Tejwani on 04/12/21.
//

import Foundation

enum LaunchYear: Int {
    case currentYear = 0
    case nextYear = 1
    
    var dateIndex: Int {
        switch self {
        case .currentYear:
            return Date().getYearIndex()
        case .nextYear:
            return Date().getNextYear().getYearIndex()
        }
    }
}

struct Launches {
    
    let id: String
    let rocket: String
    let launchNo: String
    let name: String
    let details: String
    let upcomming: Bool
    let success: Bool
    var date: Date?
    var attachments: Attachments?
    
    var launchDate: String {
        return Date.localDateString(from: date, format: "MMM d, yyyy")
    }
    
    var iconPath: String? {
        return attachments?.iconSmall
    }
    
    var successfullLaunch: Bool {
        return  success
    }
    
    func launchToShow(for year: LaunchYear) -> Bool {
        guard let launchDate = date else {return false}
        let launchYear = launchDate.getYearIndex()
        let yearToLook = year.dateIndex
        let yearToMatched = launchYear == yearToLook
        return successfullLaunch && yearToMatched
    }
    
    init(dict: NSDictionary) {
        id = dict.getStringValue(key: "id")
        rocket = dict.getStringValue(key: "rocket")
        launchNo = dict.getStringValue(key: "launchpad")
        name = dict.getStringValue(key: "name")
        details = dict.getStringValue(key: "details")
        upcomming = dict.getBooleanValue(key: "upcoming")
        success = dict.getBooleanValue(key: "success")
        date = Date.dateFromServerFormat(from: dict.getStringValue(key: "date_utc"))
        if let launchAttachments = dict["links"] as? NSDictionary {
            attachments = Attachments(dict: launchAttachments)
        }
    }
}
