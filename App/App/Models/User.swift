//
//  User.swift
//  App
//
//  Created by Omid on 2016-08-09.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

class User: NSObject {
    
    var name: String = ""
    var email: String = ""
    var role: String = ""
    var fullaccess: Bool = false
    
    init(data: NSDictionary) {
        
        super.init()
        
        self.name = (data["name"] as? String) ?? ""
        self.email = (data["email"] as? String) ?? ""
        self.role = (data["role"] as? String) ?? ""
        self.fullaccess = (data["fullaccess"] as? Bool) ?? false
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
                    completion(user: nil, error: nil)
                }
            }
        })
    }
}
