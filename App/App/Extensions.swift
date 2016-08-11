//
//  Extensions.swift
//  Mobilize
//
//  Created by Omid on 2015-05-12.
//  Copyright (c) 2015 IBM Corporation. All rights reserved.
//

import UIKit

extension String {
    
    func startsWith(str: String) -> Bool {
        
        if let range = self.rangeOfString(str) {
            return range.startIndex == self.startIndex
        }
        return false
    }
    
    func endsWith(str: String) -> Bool {
        
        if let range = self.rangeOfString(str) {
            return range.endIndex == self.endIndex
        }
        return false
    }
}

extension UInt {
    
    init?(_ string: String, radix: UInt) {
        
        let digits = "0123456789abcdefghijklmnopqrstuvwxyz"
        var result = UInt(0)
        for digit in string.lowercaseString.characters {
            if let range = digits.rangeOfString(String(digit)) {
                let val = UInt(digits.startIndex.distanceTo(range.startIndex))
                if val >= radix {
                    return nil
                }
                result = result * radix + val
            } else {
                return nil
            }
        }
        self = result
    }
}

extension UIColor {
    
    convenience init(hex: UInt) {
        
        let red = CGFloat((hex & 0xff000000) >> 24) / 255.0
        let green = CGFloat((hex & 0x00ff0000) >> 16) / 255.0
        let blue = CGFloat((hex & 0x0000ff00) >> 8) / 255.0
        let alpha = CGFloat((hex & 0x000000ff)) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    class func primaryButtonColor() -> UIColor {
        
        return UIColor(hex: 0x4670E1ff)
    }

    class func primaryDisabledButtonColor() -> UIColor {
        
        return UIColor(hex: 0x4670E148)
    }

    class func secondryButtonColor() -> UIColor {
        
        return UIColor(white: 0, alpha: 0.25)
    }
}

extension UIStoryboard {
    
    class func viewController(identifier: String, storyboard: String = "Main") -> UIViewController {
        
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(identifier) 
    }
}

extension UIView {
    
    func firstResponder() -> UIView? {
        
        if self.isFirstResponder() == true {
            return self
        }
        
        for view in self.subviews {
            if let firstResponder = view.firstResponder() {
                return firstResponder
            }
        }
        
        return nil
    }
}

extension UIImageView {
    
    class var imageCache: NSCache {
        
        struct Singleton {
            static let imageCache = NSCache()
        }
        
        return Singleton.imageCache
    }
    
    private struct AssociatedKey {
        
        static var sessionTask = "sessionTask"
    }
    
    private var sessionTask: NSURLSessionTask? {
        
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.sessionTask) as? NSURLSessionTask
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKey.sessionTask, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func image(url url: NSURL, completion: (() -> Void)?) {
        
        self.sessionTask?.cancel()
        self.image = nil
        
        if let image = UIImageView.imageCache.objectForKey(url.absoluteString) as? UIImage {
            
            self.image = image
            
            if let completion = completion {
                completion()
            }
        } else {
            self.sessionTask = NSURLSession.sharedSession().downloadTaskWithURL(url, completionHandler: { (location, response, error) -> Void in
                
                if let location = location, let response = response {
                    if response.URL == url && error == nil {
                        if let data = NSData(contentsOfURL: location),
                            let image = UIImage(data: data, scale: UIScreen.mainScreen().scale) {
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                UIView.transitionWithView(self, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                                    self.image = image
                                    }, completion: nil)
                                
                                UIImageView.imageCache.setObject(image, forKey: url.absoluteString)
                                
                                if let completion = completion {
                                    completion()
                                }
                            })
                        }
                    }
                }
            })
            self.sessionTask?.resume()
        }
    }
}
