//
//  ServiceManager.swift
//  buzu
//
//  Created by Ricardo Hurla on 06/05/2016.
//  Copyright © 2016 Ricardo Hurla. All rights reserved.
//

import Foundation
import SwiftyJSON

class ServiceManager {
    
    static let sharedInstance = ServiceManager()
    let session = NSURLSession.sharedSession()
    
    
    func authenticateOnAPI(callback: (String, String?) -> Void){
        
        let URLString = kBaseURL + kAuthenticationURL + kApplicationToken
        print("AUTHENTICATION URL" + URLString)
        makeHttpPostRequest(URLString, Params: nil) { (result, err) in
            callback(result,err)
        }
        
    }
    
    func searchForBus(searchTerm:String, callback: (JSON, String?) -> Void){
        
        let URLString = kBaseURL + kSearchURL + searchTermRegex(searchTerm)
        print("SEARCH URL" + URLString)
        makeHttpGetRequest(URLString) { (result, err) in
            callback(result, err)
        }
        
    }
    
    func uptadePosition(laneCode:Int, callback: (JSON, String?) -> Void) {
        let URLString = kBaseURL + kPositionURL + String(laneCode)
        makeHttpGetRequest(URLString) { (result, err) in
            callback(result, err)
        }
    }
    
    func searchTermRegex(searchTerm:String) -> String {
        
        var tempString:String = searchTerm
    
        let replace:NSDictionary = ["Â":"A", "À":"A", "Á":"A", "Ä":"A", "Ã":"A",
                                    "â":"a", "ã":"a", "à":"a", "á":"a", "ä":"a",
                                    "Ê":"E", "È":"E", "É":"E", "Ë":"E",
                                    "ê":"e", "è":"e", "é":"e", "ë":"e",
                                    "Î":"I", "Í":"I", "Ì":"I", "Ï":"I",
                                    "î":"i", "í":"i", "ì":"i", "ï":"i",
                                    "Ô":"O", "Õ":"O", "Ò":"O", "Ó":"O", "Ö":"O",
                                    "ô":"o", "õ":"o", "ò":"o", "ó":"o", "ö":"o",
                                    "Û":"U", "Ù":"U", "Ú":"U", "Ü":"U",
                                    "û":"u", "ú":"u", "ù":"u", "ü":"u",
                                    "ç":"c", "Ç":"C", " ":"+"]
        
        for key in replace.allKeys {
            let keyStr = key as! String
            let keyToReplace = replace.objectForKey(keyStr) as! String
            tempString = tempString.stringByReplacingOccurrencesOfString(keyStr, withString: keyToReplace)
        }
        
        return tempString.lowercaseString
        
    }
    
    func makeHttpGetRequest(URLString: String!, callback: (JSON, String?) -> Void){
        
        let request = NSMutableURLRequest(URL: NSURL(string: URLString)!)
        
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if error != nil {
                callback("", error!.localizedDescription)
            } else {
                let json = JSON(data: data!)
                callback(json, nil)
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
                let param = Params.objectForKey(keyStr) as! String
                
                if i == 0 {
                    paramString = keyStr+"="+param
                }else {
                    paramString = paramString! + "&"+keyStr+"="+param
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