//
//  RecentViewController.swift
//  buzu
//
//  Created by Ricardo Hurla on 06/06/2016.
//  Copyright © 2016 Ricardo Hurla. All rights reserved.
//

import UIKit
import SwiftyJSON

class RecentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BusLaneTableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var isShowingRecents:Bool = true
    var dataArray:JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataArray = AppManager.sharedInstance.getFavorites()
        
        
        self.title = "Recentes"
        let image = UIImage(named:"star_nav")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action:#selector(RecentViewController.toggleRecentFavorites))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func toggleRecentFavorites() {
        
        var image:UIImage
        
        if isShowingRecents == true {
            self.title = "Favoritos"
            image = UIImage(named:"recent")!
            isShowingRecents = false
            //TODO: Change Array to show Favorites and reload the tableview
        }else {
            self.title = "Recentes"
            image = UIImage(named:"star_nav")!
            isShowingRecents = true
            //TODO: Change Array to show Recents and reload the tableview
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action:#selector(RecentViewController.toggleRecentFavorites))
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell :BusLaneTableViewCell = tableView.dequeueReusableCellWithIdentifier("BusLaneCell") as! BusLaneTableViewCell
        
        cell.delegate = self
        //cell.setUpBusLaneCell(self.searchResults[indexPath.row])
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func didTouchFavoriteForCell(cell: BusLaneTableViewCell) {
        
    }

    
}
