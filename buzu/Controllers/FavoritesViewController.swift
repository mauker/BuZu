//
//  RecentViewController.swift
//  buzu
//
//  Created by Ricardo Hurla on 06/06/2016.
//  Copyright © 2016 Ricardo Hurla. All rights reserved.
//

import UIKit
import SwiftyJSON

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BusLaneTableViewCellDelegate {
    var shouldShowPlaceholder:Bool = true
    
    @IBOutlet weak var tableView: UITableView!
    var dataArray:JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favoritos"
        self.tableView.registerNib(UINib.init(nibName:"PlaceholderTableViewCell", bundle: nil), forCellReuseIdentifier: "PlaceholderCell")
        self.tableView.registerNib(UINib.init(nibName:"BusLaneTableViewCell", bundle: nil), forCellReuseIdentifier: "BusLaneCell")
        self.tableView.estimatedRowHeight = 80;
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchData() {
        
        self.dataArray = AppManager.sharedInstance.getFavorites()
        
        if self.dataArray.count > 0 {
            shouldShowPlaceholder = false
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        } else {
            shouldShowPlaceholder = true
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        }
        
        self.tableView.reloadData()
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shouldShowPlaceholder ? 1 : self.dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if shouldShowPlaceholder == true {
            let cell :PlaceholderTableViewCell = tableView.dequeueReusableCellWithIdentifier("PlaceholderCell") as! PlaceholderTableViewCell
            cell.userInteractionEnabled = false
            cell.placeholderTitle.text = "Você não possui linhas favoritas. Para adicionar uma linha como favorita, basta tocar na estrela"
            return cell
        }
        
        let cell :BusLaneTableViewCell = tableView.dequeueReusableCellWithIdentifier("BusLaneCell") as! BusLaneTableViewCell
        
        cell.delegate = self
        print(self.dataArray[indexPath.row])
        cell.setUpBusLaneCell(self.dataArray[indexPath.row])
        
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
    
    func didTouchFavoriteForCell(cell: BusLaneTableViewCell) {
        
        if cell.isFavorite {
            
            let index:NSIndexPath = self.tableView.indexPathForCell(cell)!
            AppManager.sharedInstance.removeFavoriteBusLane(cell.busLane)
            
            self.tableView.beginUpdates()
            
            self.dataArray = AppManager.sharedInstance.getFavorites()
            self.tableView.deleteRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.Left)
            
            self.tableView.endUpdates()
            self.fetchData()
            
        }

    }

    
}
