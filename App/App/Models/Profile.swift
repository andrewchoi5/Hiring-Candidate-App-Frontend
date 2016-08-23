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
    var location: String?
    
    var school: School?
    var graduationDate: NSDate?
    var degree: String?

    var event: Event?
    
    var name: String {
        
        return (self.firstname ?? "") + " " + (self.lastname ?? "")
    }
    
    init(data: NSDictionary) {
        
        super.init()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"

        self.firstname = (data["firstname"] as? String) ?? ""
        self.lastname = (data["lastname"] as? String) ?? ""
        self.email = (data["email"] as? String) ?? ""
        self.location = (data["location"] as? String) ?? ""
        self.degree = (data["degree"] as? String) ?? ""
        
        if let schoolData = data["school"] as? NSDictionary {
            self.school = School(data: schoolData)
        }
        
        if let date = data["graduationDate"] as? String {
            self.graduationDate = dateFormatter.dateFromString(date)
        }
    }

    func create(completion: ((error: NSError?) -> Void)?) -> NSURLSessionTask {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"

        let path = "profileCreate"
        var params: [String: String] = [:]
        
        if let firstname = self.firstname {
            params["firstname"] = firstname
        }
        if let lastname = self.lastname {
            params["lastname"] = lastname
        }
        if let email = self.email {
            params["email"] = email
        }
        if let location = self.location {
            params["location"] = location
        }
        if let degree = self.degree {
            params["degree"] = degree
        }
        if let graduationDate = self.graduationDate {
            params["graduationDate"] = dateFormatter.stringFromDate(graduationDate) ?? ""
        }
        if let schoolId = self.school?.id {
            params["schoolId"] = schoolId
        }
        if let eventId = self.event?.id {
            params["eventId"] = eventId
        }
        
        return APIManager.sharedManager.post(path, params: params, completion: { (data, error) in
            
            if let completion = completion {
                completion(error: error)
            }
        })
    }

    func reviews(offset: Int, limit: Int, completion: ((reviews: [Review], hasNext: Bool, error: NSError?) -> Void)?) -> NSURLSessionTask {
        
        let path = "profileReviewsList"
        var params: [String: String] = [:]
        
        params["offset"] = String(offset) ?? ""
        params["limit"] = String(limit) ?? ""
        
        return APIManager.sharedManager.get(path, params: params, completion: { (data, error) in
            
            if let completion = completion {
                if let error = error {
                    completion(reviews: [], hasNext: false, error: error)
                } else if let data = data, let reviewsData = data["data"] as? NSArray {
                    
                    var reviews: [Review] = []
                    
                    for reviewData in reviewsData {
                        if let reviewData = reviewData as? NSDictionary {
                            reviews.append(Review(data: reviewData))
                        }
                    }
                    
                    completion(reviews: reviews, hasNext: false, error: nil)
                } else {
                    completion(reviews: [], hasNext: false, error: nil)
                }
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
