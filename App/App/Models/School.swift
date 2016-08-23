//
//  School.swift
//  App
//
//  Created by Omid on 2016-08-17.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

class School: NSObject {
    
    var id: String?
    var name: String?
    var location: String?
    
    init(data: NSDictionary) {
        
        super.init()
        
        self.id = data["id"] as? String
        self.name = data["name"] as? String
        self.location = data["location"] as? String
    }
    
    class func schools(offset: Int, limit: Int, completion: ((schools: [School], hasNext: Bool, error: NSError?) -> Void)?) -> NSURLSessionTask {
        
        let path = "schoolsList"
        var params: [String: String] = [:]
        
        params["offset"] = String(offset) ?? ""
        params["limit"] = String(limit) ?? ""
        
        return APIManager.sharedManager.get(path, params: params, completion: { (data, error) in
            
            if let completion = completion {
                if let error = error {
                    completion(schools: [], hasNext: false, error: error)
                } else if let data = data, let schoolsData = data["data"] as? NSArray {
                    
                    var schools: [School] = []
                    
                    for schoolData in schoolsData {
                        if let schoolData = schoolData as? NSDictionary {
                            schools.append(School(data: schoolData))
                        }
                    }
                    
                    completion(schools: schools, hasNext: false, error: nil)
                } else {
                    completion(schools: [], hasNext: false, error: nil)
                }
            }
        })
    }
}
