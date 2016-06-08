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
    
    func updateRecentsWithBusLane(busLane:NSDictionary) -> Void {
        
        let recentLanes:NSMutableDictionary = defaults.objectForKey("recentLanes") as! NSMutableDictionary
        let laneCode:String = busLane.objectForKey("CodigoLinha") as! String
        
        if recentLanes.allKeys.count >= 20 {
            
            let keysArray:NSArray = recentLanes.allKeys
            let lastKey:String = keysArray.lastObject as! String
            
            recentLanes.removeObjectForKey(lastKey)
            
        }
        
        if (recentLanes.objectForKey(laneCode) != nil) {
            recentLanes.setObject(busLane, forKey: laneCode)
            defaults.synchronize()
        }
        
    }
    
    func addFavoriteBusLane(busLane:JSON) -> Void {
        
        let key:String = String(busLane["CodigoLinha"].number!)
        
        let busDict = busLane.rawString()
        let busToAdd:NSDictionary = [key:busDict!]
        
        if defaults.objectForKey("favLanes") == nil {
            
            let lanesArray:NSArray = [busToAdd]
            defaults.setObject(lanesArray, forKey:"favLanes")
            
        }else {
            
            let lanesArray:NSMutableArray = NSMutableArray.init(array: defaults.objectForKey("favLanes") as! NSArray)
            lanesArray.addObject(busToAdd)
            defaults.setObject(lanesArray, forKey:"favLanes")
            
        }
        
        defaults.synchronize()
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
    
    
//    func addFavoriteBusLane(busLane:NSDictionary) -> Void {
//        
//        let favLanes:NSMutableDictionary = defaults.objectForKey("favLanes") as! NSMutableDictionary
//        let laneCode:String = busLane.objectForKey("CodigoLinha") as! String
//        
//        if (favLanes.objectForKey(laneCode) != nil) {
//            favLanes.setObject(busLane, forKey: laneCode)
//            defaults.synchronize()
//            showAlertView("Favoritos", message: "Linha adicionada aos favoritos!")
//        }
// 
//    }
//    
//    func removeFavoriteBusLane(laneCode:String) -> Void {
//
//        let favLanes:NSMutableDictionary = defaults.objectForKey("favLanes") as! NSMutableDictionary
//        
//        if (favLanes.objectForKey(laneCode) != nil) {
//            favLanes.removeObjectForKey(laneCode)
//            defaults.synchronize()
//            showAlertView("Favoritos", message: "Linha removida dos favoritos!")
//        }
//    }
    
    func showAlertView(title:String, message:String) -> Void {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        let viewController =  UIApplication.sharedApplication().keyWindow?.rootViewController
        viewController?.presentViewController(alert, animated: true, completion: nil)
        
    }
}