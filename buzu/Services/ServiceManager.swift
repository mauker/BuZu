//
//  ServiceManager.swift
//  buzu
//
//  Created by Ricardo Hurla on 06/05/2016.
//  Copyright © 2016 Ricardo Hurla. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias ServiceResponse = (JSON, NSError?) -> Void

class ServiceManager {
    
    static let sharedInstance = ServiceManager()
    let session = NSURLSession.sharedSession()
    
    
    func authenticateOnAPI(callback: (String, String?) -> Void){
        
        let URLString = kBaseURL + kAuthenticationURL + kApplicationToken
        makeHttpPostRequest(URLString, Params: nil) { (result, err) in
            callback(result,err)
        }
        
    }
    
    func makeHttpGetRequest(URLString: String!, callback: (String, String?) -> Void){
        
        let request = NSMutableURLRequest(URL: NSURL(string: URLString)!)
        
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if error != nil {
                callback("", error!.localizedDescription)
            } else {
                let result = NSString(data: data!, encoding:
                    NSASCIIStringEncoding)!
                callback(result as String, nil)
            }
        }
        task.resume()
        
    }
    
    func makeHttpPostRequest(URLString: String!, Params: NSDictionary!, callback: (String, String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: URLString)!)
        
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        if (Params != nil) {
            var paramString: String?
            var i = 0;
            
            for key in Params.allKeys {
                let keyStr = key as! String
                let test = Params.objectForKey(keyStr) as! String
                
                if i == 0 {
                    paramString = keyStr+"="+test
                }else {
                    paramString = paramString! + "&"+keyStr+"="+test
                }
                
                i += 1
                
            }
            
            request.HTTPBody = paramString?.dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        
        
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if error != nil {
                callback("", error!.localizedDescription)
            } else {
                let result = NSString(data: data!, encoding:
                    NSASCIIStringEncoding)!
                callback(result as String, nil)
            }
        }
        task.resume()
        
    }


    
}