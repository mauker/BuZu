//
//  MapViewController.swift
//  buzu
//
//  Created by Ricardo Hurla on 13/06/2016.
//  Copyright © 2016 Ricardo Hurla. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import QuartzCore
import SwiftyJSON
import SwiftLoader

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var accessibilityButton: UIButton!
    @IBOutlet weak var laneNumberLabel: UILabel!
    
    var selectedBusLane:JSON = []
    var isAccessibilityEnabled:Bool = false
    var timer:NSTimer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.authorizeLane), name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        UIApplication.sharedApplication().statusBarStyle = .Default
        
        self.backButton.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        self.laneNumberLabel.layer.cornerRadius = 4
        self.laneNumberLabel.layer.masksToBounds = true
        let fullLineNumber = "   " + self.selectedBusLane["Letreiro"].string! + "-" + String(self.selectedBusLane["Tipo"].number!) + "   "
        self.laneNumberLabel.text = fullLineNumber
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        self.authorizeLane()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.timer.invalidate()
    }
    
    func authorizeLane() -> Void {
        
        
        SwiftLoader.show(animated: true)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        ServiceManager.sharedInstance.authenticateOnAPI { (result, err) in
            
            if err != nil {
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    AppManager.sharedInstance.showAlertView("Erro", message: err!)
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    SwiftLoader.hide()
                    
                }
                
            }else{
                
                if result == "true" {
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        SwiftLoader.hide()
                    }
                    
                    self.fetchLane(false)
                    
                } else {
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        AppManager.sharedInstance.showAlertView("Erro", message:"SPTrans está offline no momento, tente novamente mais tarde.")
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        SwiftLoader.hide()
                        
                    }
                    
                }
                
            }
        }
        
    }
    
    func fetchLane(isUpdating:Bool) -> Void {

        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.timer.invalidate()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(25.0, target:self, selector: #selector(self.fetchLane(_:)), userInfo:nil, repeats:true)
        
        let laneCode = self.selectedBusLane["CodigoLinha"].int
        ServiceManager.sharedInstance.uptadePosition(laneCode!, callback: { (result, err) in
            
            if err != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    
                    AppManager.sharedInstance.showAlertView("Erro", message: err!)
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                }
                
            }else {

                for (index,subJson):(String, JSON) in result {
                    
                    if index == "vs" {

                        let annotations:NSMutableArray = []
                        
                        for (index,busJson):(String, JSON) in subJson {
                            print(index)
                            
                            let bus = BusAnnotation()
                            bus.coordinate = CLLocationCoordinate2DMake(busJson["py"].double!, busJson["px"].double!)
                            
                            if (busJson["a"].boolValue == true) {
                                bus.imageName = "bus_pin_access"
                            }else {
                                bus.imageName = "bus_pin_normal"
                            }
                            
                            
                            if self.isAccessibilityEnabled == true {
                                
                                if busJson["a"].boolValue == true {
                                    
                                    annotations.addObject(bus)
                                }
                                
                            }else {
                                
                                annotations.addObject(bus)
                            }

                        }
                        
                        let annotationsToRemove = self.mapView.annotations.filter { $0 !== self.mapView.userLocation }
                        dispatch_async(dispatch_get_main_queue()) {
                            self.mapView.removeAnnotations(annotationsToRemove)
                        }
                        
                        self.mapView.addAnnotations(annotations as NSArray as! [MKAnnotation])
                        
                        if isUpdating == false {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.mapView.showAnnotations(annotations as NSArray as! [MKAnnotation], animated:true)
                            }
                        }
                        
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        
                    }
                    
                }
                
            }
            
        })
        
    }
    
    //MARK: BUTTON ACTIONS
    @IBAction func didTouchBackButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func didTouchLocationButton(sender: UIButton) {
        self.mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
    }
    
    @IBAction func didTouchUpdateButton(sender: UIButton) {
        self.fetchLane(true)
    }
    
    @IBAction func didTouchAccessibilityButton(sender: UIButton) {
        
        if isAccessibilityEnabled == true {
            isAccessibilityEnabled = false
        } else {
            isAccessibilityEnabled = true
        }
        
        self.fetchLane(false)
    }
    
    //MARK: MAP ACTIONS
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is BusAnnotation) {
            return nil
        }
        
        let reuseId = "busAnnotation"
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        
        if anView == nil {
            anView = MKAnnotationView(annotation:annotation, reuseIdentifier:reuseId)
            anView!.canShowCallout = true
        } else {
            anView!.annotation = annotation
        }
        
        let cpa = annotation as! BusAnnotation
        anView!.image = UIImage(named:cpa.imageName)
        
        return anView
        
    }
}
