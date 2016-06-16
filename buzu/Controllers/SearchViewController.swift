//
//  SearchViewController.swift
//  buzu
//
//  Created by Ricardo Hurla on 06/05/2016.
//  Copyright © 2016 Ricardo Hurla. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftLoader

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, BusLaneTableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var shouldShowPlaceholder:Bool = true
    var searchResults:JSON = []
    lazy var searchBar = UISearchBar(frame: CGRectZero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "Ex.: Paulista ou 917M"
        searchBar.delegate = self
        searchBar.tintColor = UIColor.init(colorLiteralRed: 82/255.0, green: 50/255.0, blue: 84/255.0, alpha: 1.0)
        navigationItem.titleView = searchBar
        
        self.tableView.registerNib(UINib.init(nibName:"BusLaneTableViewCell", bundle: nil), forCellReuseIdentifier: "BusLaneCell")
        self.tableView.registerNib(UINib.init(nibName:"PlaceholderTableViewCell", bundle: nil), forCellReuseIdentifier: "PlaceholderCell")
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func searchForBusLane(searchTerm:String) {
        
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
                    
                    ServiceManager.sharedInstance.searchForBus(searchTerm, callback: { (result, err) in
                        
                        if (err != nil) {
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                
                                AppManager.sharedInstance.showAlertView("Erro", message: err!)
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                SwiftLoader.hide()
                                
                            }
                            
                        }else {
                            
                            if result.array?.count >= 1 {
                
                                self.searchResults = result
                                self.shouldShowPlaceholder = false
                                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.tableView.reloadData()
                                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                    SwiftLoader.hide()
                                }
                                
                            }else {

                                dispatch_async(dispatch_get_main_queue()) {
                                    AppManager.sharedInstance.showAlertView("BuZu", message: "Não foi possível encontrar nenhuma linha para sua pesquisa")
                                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                    SwiftLoader.hide()

                                }
                                
                            }
                            
                           
                            
                        }
                    })
 
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
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        self.searchForBusLane(searchBar.text!)
        self.becomeFirstResponder()
    }
    
    //MARK: TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shouldShowPlaceholder ? 1 : self.searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if shouldShowPlaceholder == true {
            let cell :PlaceholderTableViewCell = tableView.dequeueReusableCellWithIdentifier("PlaceholderCell") as! PlaceholderTableViewCell
            cell.userInteractionEnabled = false
            cell.placeholderTitle.text = "Digite o nome ou o número da sua linha acima"
            return cell
        }
        
        let cell :BusLaneTableViewCell = tableView.dequeueReusableCellWithIdentifier("BusLaneCell") as! BusLaneTableViewCell
        
        cell.delegate = self
        cell.setUpBusLaneCell(self.searchResults[indexPath.row])
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! BusLaneTableViewCell

        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        vc.selectedBusLane = cell.busLane
        self.presentViewController(vc, animated: true, completion: nil)
        
        
    }
    
    //MARK: CellDelegate
    func didTouchFavoriteForCell(cell: BusLaneTableViewCell) {
        
        if cell.isFavorite {
            AppManager.sharedInstance.removeFavoriteBusLane(cell.busLane)
        } else {
            AppManager.sharedInstance.addFavoriteBusLane(cell.busLane)
        }
        
        let index:NSIndexPath = self.tableView.indexPathForCell(cell)!
        self.tableView.reloadRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
}