//
//  User.swift
//  App
//
//  Created by Omid on 2016-08-09.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

class User: NSObject {
    
    var firstname: String?
    var lastname: String?
    var email: String?
    var role: String?
    var accessLevel: String?
    
    var name: String {
        
        return (self.firstname ?? "") + " " + (self.lastname ?? "")
    }

    enum AccessLevel: String {
        
        case None = "0"
        case Editor = "1"
        case Moderator = "2"
        case Administrator = "3"
        
        static var count: Int { return 4 }
    }
    
    init(data: NSDictionary) {
        
        super.init()
        
        self.firstname = (data["firstname"] as? String) ?? ""
        self.lastname = (data["lastname"] as? String) ?? ""
        self.role = (data["role"] as? String) ?? ""
        self.email = (data["email"] as? String) ?? ""
        self.accessLevel = (data["accessLevel"] as? String) ?? ""
    }

    func create(completion: ((error: NSError?) -> Void)?) -> NSURLSessionTask {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        
        let path = "userCreate"
        var params: [String: String] = [:]
        
        if let firstname = self.firstname {
            params["firstname"] = firstname
        }
        if let lastname = self.lastname {
            params["lastname"] = lastname
        }
        if let role = self.role {
            params["role"] = role
        }
        if let accessLevel = self.accessLevel {
            params["accessLevel"] = accessLevel
        }
        
        return APIManager.sharedManager.post(path, params: params, completion: { (data, error) in
            
            if let completion = completion {
                completion(error: error)
            }
        })
    }

    class func user(email: String, completion: ((user: User?, error: NSError?) -> Void)?) -> NSURLSessionTask {
        
        let path = "userFind"
        let params = ["email": email]
        
        return APIManager.sharedManager.get(path, params: params, completion: { (data, error) in
            
            if let completion = completion {
                if let error = error {
                    completion(user: nil, error: error)
                } else if let data = data, let user = data["data"] as? NSDictionary {
                    completion(user: User(data: user), error: nil)
                } else {
                    completion(user: nil, error: NSError(domain: "com.ibm.error", code: 0, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("User not found.", comment: "")]))
                }
            }
        })
    }
}
