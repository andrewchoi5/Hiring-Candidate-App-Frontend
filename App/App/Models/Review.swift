//
//  Review.swift
//  App
//
//  Created by Omid on 2016-08-22.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

class Review: NSObject {
    
    var id: String?
    var note: String?
    var date: NSDate?
    var user: User?

    init(data: NSDictionary) {
        
        super.init()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        self.id = data["id"] as? String
        self.note = data["note"] as? String
        
        if let date = data["date"] as? String {
            self.date = dateFormatter.dateFromString(date)
        }
        
        if let userData = data["user"] as? NSDictionary {
            self.user = User(data: userData)
        }
    }
}
