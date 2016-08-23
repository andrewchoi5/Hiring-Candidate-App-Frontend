//
//  EventType.swift
//  App
//
//  Created by Omid on 2016-08-22.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

class EventType: NSObject {
    
    var id: String?
    var name: String?
    
    init(data: NSDictionary) {
        
        super.init()
        
        self.id = data["id"] as? String
        self.name = data["name"] as? String
    }
    
    class func eventTypes(completion: ((eventTypes: [EventType], hasNext: Bool, error: NSError?) -> Void)?) -> NSURLSessionTask {
        
        let path = "eventTypesList"
        let params: [String: String] = [:]
        
        return APIManager.sharedManager.get(path, params: params, completion: { (data, error) in
            
            if let completion = completion {
                if let error = error {
                    completion(eventTypes: [], hasNext: false, error: error)
                } else if let data = data, let eventTypesData = data["data"] as? NSArray {
                    
                    var eventTypes: [EventType] = []
                    
                    for eventTypeData in eventTypesData {
                        if let eventTypeData = eventTypeData as? NSDictionary {
                            eventTypes.append(EventType(data: eventTypeData))
                        }
                    }
                    
                    completion(eventTypes: eventTypes, hasNext: false, error: nil)
                } else {
                    completion(eventTypes: [], hasNext: false, error: nil)
                }
            }
        })
    }
}
