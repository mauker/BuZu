//
//  AppManager.swift
//  buzu
//
//  Created by Ricardo Hurla on 10/05/2016.
//  Copyright © 2016 Ricardo Hurla. All rights reserved.
//

import UIKit
import SwiftyJSON

class AppManager {
    
    static let sharedInstance = AppManager()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    //MARK: RECENTS
    func addRecentBusLane(busLane:JSON) -> Void {
        
        let key:String = String(busLane["CodigoLinha"].number!)
        let busDict = busLane.rawString(NSUTF8StringEncoding, options:NSJSONWritingOptions.PrettyPrinted)
        let busToAdd:NSDictionary = [key:busDict!]
        
        if defaults.objectForKey("recentLanes") == nil {
            
            let lanesArray:NSArray = [busToAdd]
            defaults.setObject(lanesArray, forKey:"recentLanes")
            
        }else {
            
            let lanesArray:NSMutableArray = NSMutableArray.init(array: defaults.objectForKey("recentLanes") as! NSArray)
            lanesArray.addObject(busToAdd)
            defaults.setObject(lanesArray, forKey:"recentLanes")
            
        }
        
        defaults.synchronize()
        
    }
    
    func removeRecentBusLane(busLane:JSON) -> Void {
        
        let lanesArray:NSMutableArray = NSMutableArray.init(array: defaults.objectForKey("recentLanes") as! NSArray)
        
        let key:String = String(busLane["CodigoLinha"].number!)
        
        for item in lanesArray {
            
            if (item.objectForKey(key) != nil) {
                lanesArray.removeObject(item)
            }
            
        }
        
        defaults.setObject(lanesArray, forKey:"recentLanes")
        defaults.synchronize()
         
    }

    //MARK: FAVORITES
    func addFavoriteBusLane(busLane:JSON) -> Void {
        
        let key:String = String(busLane["CodigoLinha"].number!)
        
        do {
            let busDict = try busLane.rawData()
            
            let busToAdd:NSDictionary = [key:busDict]
            
            if defaults.objectForKey("favLanes") == nil {
                
                let lanesArray:NSArray = [busToAdd]
                defaults.setObject(lanesArray, forKey:"favLanes")
                
            }else {
                
                let lanesArray:NSMutableArray = NSMutableArray.init(array: defaults.objectForKey("favLanes") as! NSArray)
                lanesArray.addObject(busToAdd)
                defaults.setObject(lanesArray, forKey:"favLanes")
                
            }
            
            defaults.synchronize()
            
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
        
        
        
    }
    
    func removeFavoriteBusLane(busLane:JSON) -> Void {
        
        let lanesArray:NSMutableArray = NSMutableArray.init(array: defaults.objectForKey("favLanes") as! NSArray)
        
        let key:String = String(busLane["CodigoLinha"].number!)
        
        for item in lanesArray {
            
            if (item.objectForKey(key) != nil) {
                lanesArray.removeObject(item)
            }
            
        }
        
        defaults.setObject(lanesArray, forKey:"favLanes")
        defaults.synchronize()
        
        
    }
    
    func busLaneIsFavorite(busLane:JSON) -> Bool {
        
        if defaults.objectForKey("favLanes") == nil {
            return false
        }
        
        let lanesArray:NSMutableArray = NSMutableArray.init(array: defaults.objectForKey("favLanes") as! NSArray)
        
        let key:String = String(busLane["CodigoLinha"].number!)
        
        for item in lanesArray {
            
            if (item.objectForKey(key) != nil) {
                return true
            }
            
        }
        
        return false
        
    }
    
    func getFavorites() -> JSON {
        
        if defaults.objectForKey("favLanes") == nil{
            return nil
        }
        
        let lanesArray:NSArray = NSArray.init(array: defaults.objectForKey("favLanes") as! NSArray)

        let lanesToReturn:NSMutableArray = []
        
        for item in lanesArray {
            
            let dict = item as! NSDictionary
            for key in dict.allKeys {
                let keyStr = key as! String
                let json:JSON = JSON(data: dict.objectForKey(keyStr)! as! NSData)
                lanesToReturn.addObject(json.object)
            }
            
        }
        
        return JSON(lanesToReturn)
    }

    //MARK: ALERT
    func showAlertView(title:String, message:String) -> Void {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        let viewController =  UIApplication.sharedApplication().keyWindow?.rootViewController
        viewController?.presentViewController(alert, animated: true, completion: nil)
        
    }
}