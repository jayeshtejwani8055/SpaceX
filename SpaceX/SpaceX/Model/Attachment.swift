//
//  Attachment.swift
//  SpaceX
//
//  Created by Jayesh Tejwani on 04/12/21.
//

import Foundation

struct Attachments {

    var iconSmall: String?
    var iconLarge: String?
    
    var smallIconUrl: URL? {
        if let path = iconSmall {
            return URL(string: path)
        }
        return nil
    }
    
    var largeIconUrl: URL? {
        if let path = iconLarge {
            return URL(string: path)
        }
        return nil
    }
    
    init(path: String?) {
        iconSmall = path
    }
    
    init(dict: NSDictionary) {
        if let patches = dict["patch"] as? NSDictionary {
            iconSmall = patches.getStringValue(key: "small")
            iconLarge = patches.getStringValue(key: "large")
        }
    }
}
