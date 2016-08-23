//
//  Event.swift
//  App
//
//  Created by Omid on 2016-08-04.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

class Event: NSObject {
    
    var id: String?
    var name: String?
    var location: String?
    var date: NSDate?
    var eventType: EventType?

    init(data: NSDictionary) {
        
        super.init()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.id = data["id"] as? String
        self.name = data["name"] as? String
        self.location = data["location"] as? String
        
        if let date = data["date"] as? String {
            self.date = dateFormatter.dateFromString(date)
        }
        
        if let eventTypeData = data["eventType"] as? NSDictionary {
            self.eventType = EventType(data: eventTypeData)
        }
    }
    
    func create(completion: ((error: NSError?) -> Void)?) -> NSURLSessionTask {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        
        let path = "eventCreate"
        var params: [String: String] = [:]
        
        if let name = self.name {
            params["name"] = name
        }
        if let location = self.location {
            params["location"] = location
        }
        if let eventTypeId = self.eventType?.id {
            params["eventTypeId"] = eventTypeId
        }
        if let date = self.date {
            params["date"] = dateFormatter.stringFromDate(date) ?? ""
        }
        
        return APIManager.sharedManager.post(path, params: params, completion: { (data, error) in
            
            if let completion = completion {
                completion(error: error)
            }
        })
    }

    class func events(offset: Int, limit: Int, completion: ((events: [Event], hasNext: Bool, error: NSError?) -> Void)?) -> NSURLSessionTask {
        
        let path = "eventsList"
        var params: [String: String] = [:]
        
        params["offset"] = String(offset) ?? ""
        params["limit"] = String(limit) ?? ""
        
        return APIManager.sharedManager.get(path, params: params, completion: { (data, error) in
            
            if let completion = completion {
                if let error = error {
                    completion(events: [], hasNext: false, error: error)
                } else if let data = data, let eventsData = data["data"] as? NSArray {
                    
                    var events: [Event] = []
                    
                    for eventData in eventsData {
                        if let eventData = eventData as? NSDictionary {
                            events.append(Event(data: eventData))
                        }
                    }
                    
                    completion(events: events, hasNext: false, error: nil)
                } else {
                    completion(events: [], hasNext: false, error: nil)
                }
            }
        })
    }
}
