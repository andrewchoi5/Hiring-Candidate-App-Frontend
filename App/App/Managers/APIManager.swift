//
//  DataManager.swift
//  App
//
//  Created by Omid on 2016-08-04.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

class APIManager: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate {
    
    static let sharedManager: APIManager = APIManager()
    
    private let baseURL: NSURL = NSURL(string: "http://odin-api.mybluemix.net/api/")!

    var email: String?
    var password: String?
    
    func get(path: String, params: [String: String]?, completion: ((data: NSDictionary?, error: NSError?) -> Void)?) -> NSURLSessionTask {
        
        return self.request("GET", path: path, params: params, completion: completion)
    }
    
    func post(path: String, params: [String: String]?, completion: ((data: NSDictionary?, error: NSError?) -> Void)?) -> NSURLSessionTask {
        
        return self.request("POST", path: path, params: params, completion: completion)
    }
    
    func request(method: String, path: String, params: [String: String]?, completion: ((data: NSDictionary?, error: NSError?) -> Void)?) -> NSURLSessionTask {
        
        var query = ""
        
        if let params = params {
            for (key, value) in Array(params).sort(<) {
                if query.characters.count > 0 {
                    query += "&"
                }
                query += (key + "=" + value)
            }
        }
        
        let url = self.baseURL.URLByAppendingPathComponent(path)
        let urlRequest = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 30)
        urlRequest.HTTPMethod = method.uppercaseString
        
        if urlRequest.HTTPMethod == "POST" {
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            urlRequest.HTTPBody = query.dataUsingEncoding(NSUTF8StringEncoding)
        } else if query.characters.count > 0 {
            urlRequest.URL = NSURL(string: urlRequest.URL!.absoluteString + "?" + query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
        }
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(urlRequest) { (data, response, error) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if let completion = completion {
                    
                    if let error = error {
                        if error.code != NSURLErrorCancelled {
                            completion(data: nil, error: error)
                        }
                    } else if let data = data {
                        do {
                            if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                                
                                if let error = json["error"] as? String {
                                    completion(data: nil, error: NSError(domain: "com.ibm.error", code: 0, userInfo: [NSLocalizedDescriptionKey: error]))
                                } else {
                                    completion(data: json, error: nil)
                                }
                            } else {
                                completion(data: nil, error: nil)
                            }
                        } catch let error as NSError {
                            completion(data: nil, error: error)
                        }
                    } else {
                        completion(data: nil, error: nil)
                    }
                }
            })
        }
        task.resume()
        
        return task
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        
        if challenge.previousFailureCount == 0 {
            let credential = NSURLCredential(user: self.email ?? "", password: self.password ?? "", persistence: NSURLCredentialPersistence.ForSession)
            completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, credential)
        } else {
            completionHandler(NSURLSessionAuthChallengeDisposition.PerformDefaultHandling, nil)
        }
    }
}