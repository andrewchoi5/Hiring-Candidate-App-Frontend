//
//  Profile.swift
//  App
//
//  Created by Omid on 2016-08-04.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

class Profile: NSObject {
    
    var id: String?
    var firstname: String?
    var lastname: String?
    var email: String?
    var city: String?
    var school: String?
    var event: Event?
    
    init(data: NSDictionary) {
        
        super.init()
        
        self.firstname = (data["firstname"] as? String) ?? ""
        self.lastname = (data["lastname"] as? String) ?? ""
        self.email = (data["email"] as? String) ?? ""
        self.city = (data["city"] as? String) ?? ""
        self.school = (data["school"] as? String) ?? ""
    }

    func create(completion: ((error: NSError?) -> Void)?) -> NSURLSessionTask {
        
        let path = ""
        var params: [String: String] = [:]
        
        params["firstname"] = self.firstname
        params["lastname"] = self.lastname
        params["email"] = self.email
        params["city"] = self.city
        params["school"] = self.school
        params["eventId"] = self.event?.id ?? ""
        
        return APIManager.sharedManager.post(path, params: params, completion: { (data, error) in
            
            if let completion = completion {
                completion(error: error)
            }
        })
    }

    class func profiles(offset: Int, limit: Int, completion: ((profiles: [Profile], hasNext: Bool, error: NSError?) -> Void)?) -> NSURLSessionTask {

        let path = "profilesList"
        var params: [String: String] = [:]
        
        params["offset"] = String(offset) ?? ""
        params["limit"] = String(limit) ?? ""

        return APIManager.sharedManager.get(path, params: params, completion: { (data, error) in
            
            if let completion = completion {
                if let error = error {
                    completion(profiles: [], hasNext: false, error: error)
                } else if let data = data, let profilesData = data["data"] as? NSArray {
                    
                    var profiles: [Profile] = []
                    
                    for profileData in profilesData {
                        if let profileData = profileData as? NSDictionary {
                            profiles.append(Profile(data: profileData))
                        }
                    }
                    
                    completion(profiles: profiles, hasNext: false, error: nil)
                } else {
                    completion(profiles: [], hasNext: false, error: nil)
                }
            }
        })
    }
    
    class func profiles(query: String, offset: Int, limit: Int, completion: ((profiles: [Profile], hasNext: Bool, error: NSError?) -> Void)?) -> NSURLSessionTask {
        
        let path = "profilesSearch"
        var params: [String: String] = [:]
        
        params["offset"] = String(offset) ?? ""
        params["limit"] = String(limit) ?? ""
        params["query"] = query
        
        
        return APIManager.sharedManager.get(path, params: params, completion: { (data, error) in
            
            if let completion = completion {
                if let error = error {
                    completion(profiles: [], hasNext: false, error: error)
                } else if let data = data, let profilesData = data["data"] as? NSArray {
                    
                    var profiles: [Profile] = []
                    
                    for profileData in profilesData {
                        if let profileData = profileData as? NSDictionary {
                            profiles.append(Profile(data: profileData))
                        }
                    }
                    
                    completion(profiles: profiles, hasNext: false, error: nil)
                } else {
                    completion(profiles: [], hasNext: false, error: nil)
                }
            }
        })
    }
}
