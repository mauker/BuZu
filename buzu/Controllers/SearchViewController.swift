//
//  SearchViewController.swift
//  buzu
//
//  Created by Ricardo Hurla on 06/05/2016.
//  Copyright © 2016 Ricardo Hurla. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, BusLaneTableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var searchResults:JSON = []
    lazy var searchBar = UISearchBar(frame: CGRectZero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "Procurar"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        self.tableView.registerNib(UINib.init(nibName:"BusLaneTableViewCell", bundle: nil), forCellReuseIdentifier: "BusLaneCell")
        self.tableView.estimatedRowHeight = 80;
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func searchForBusLane(searchTerm:String) {
        
        ServiceManager.sharedInstance.authenticateOnAPI { (result, err) in
        
            if err != nil {
                
                AppManager.sharedInstance.showAlertView("Erro", message: err!)
                
            }else{
                
                if result == "true" {
                    
                    ServiceManager.sharedInstance.searchForBus(searchTerm, callback: { (result, err) in
                        
                        if (err != nil) {
                            AppManager.sharedInstance.showAlertView("Erro", message: err!)
                        }else {
                            self.searchResults = result
                            dispatch_async(dispatch_get_main_queue()) {
                                self.tableView.reloadData()
                            }
                            
                        }
                    })
 
                } else {
                   AppManager.sharedInstance.showAlertView("Erro", message:"SPTrans está offline no momento, tente novamente mais tarde.")
                }
                
            }
        
        }
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
//        if searchBar.text?.characters.count <= 1 {
//            AppManager.sharedInstance.showAlertView("Erro", message:"A pesquisa está vazia.")
//            return
//        }
        
        self.searchForBusLane(searchBar.text!)
        self.becomeFirstResponder()
    }
    
    //MARK: TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell :BusLaneTableViewCell = tableView.dequeueReusableCellWithIdentifier("BusLaneCell") as! BusLaneTableViewCell
        
        cell.delegate = self
        cell.setUpBusLaneCell(self.searchResults[indexPath.row])
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //MARK: CellDelegate
    func didTouchFavoriteForCell(cell: BusLaneTableViewCell) {
        print("FAVORITE")
    }
    
}