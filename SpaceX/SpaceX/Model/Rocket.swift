//
//  Rocket.swift
//  SpaceX
//
//  Created by Jayesh Tejwani on 04/12/21.
//

import Foundation

struct Rocket {
    
    let id: String
    let name: String
    let desc: String
    let wiki: String
    var attachment: [Attachments]?
    
    init(dict: NSDictionary) {
        id = dict.getStringValue(key: "id")
        name = dict.getStringValue(key: "name")
        desc = dict.getStringValue(key: "description")
        wiki = dict.getStringValue(key: "wikipedia")
        if let launchAttachments = dict["flickr_images"] as? [String], !launchAttachments.isEmpty {
            attachment = []
            launchAttachments.forEach { path in
                attachment?.append(Attachments(path: path))
            }
        }
    }
    
    func getAttachments() -> Observable<[Attachments]> {
        return Observable.create { observer -> Disposable in
            if let attachment = self.attachment {
                observer.onNext(attachment)
            }
            return Disposables.create {}
        }
    }
}
