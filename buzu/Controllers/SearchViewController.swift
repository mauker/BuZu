//
//  SearchViewController.swift
//  buzu
//
//  Created by Ricardo Hurla on 06/05/2016.
//  Copyright © 2016 Ricardo Hurla. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, BusLaneTableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    
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
    
    func searchForBusLane(searchTerm:String) -> NSArray {
        
        ServiceManager.sharedInstance.authenticateOnAPI { (result, err) in
        
            if err != nil {
                
                AppManager.sharedInstance.showAlertView("Erro", message: err!)
                
            }else{
                
                if result == "true" {
                    
                    ServiceManager.sharedInstance.searchForBus(searchTerm, callback: { (result, err) in
                        
                        if (err != nil) {
                            AppManager.sharedInstance.showAlertView("Erro", message: err!)
                        }else {
                            print(result)
                        }
                    })
 
                } else {
                   AppManager.sharedInstance.showAlertView("Erro", message:"SPTrans está offline no momento, tente novamente mais tarde.")
                }
                
            }
            
            
        
        }
        
        return []
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
//        if searchBar.text.length > 2 {
//            
//        }
        
        self.searchForBusLane(searchBar.text!)
        searchBar.text = ""
        self.becomeFirstResponder()
    }
    
    //MARK: TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell :BusLaneTableViewCell = tableView.dequeueReusableCellWithIdentifier("BusLaneCell") as! BusLaneTableViewCell
        
        cell.delegate = self
        
        cell.setUpBusLaneCell("123232", lineName: "Metro Vila Mariana", lineDirection: 1, isFavorite: false)
        
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