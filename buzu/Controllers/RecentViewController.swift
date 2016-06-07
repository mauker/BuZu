//
//  RecentViewController.swift
//  buzu
//
//  Created by Ricardo Hurla on 06/06/2016.
//  Copyright © 2016 Ricardo Hurla. All rights reserved.
//

import UIKit

class RecentViewController: UIViewController {
    
    var isShowingRecents:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
}
