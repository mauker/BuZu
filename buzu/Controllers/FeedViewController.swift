//
//  FeedViewController.swift
//  buzu
//
//  Created by Ricardo Hurla on 06/06/2016.
//  Copyright © 2016 Ricardo Hurla. All rights reserved.
//

import UIKit
import TwitterKit

class FeedViewController: TWTRTimelineViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let client = TWTRAPIClient()
        self.dataSource = TWTRUserTimelineDataSource(screenName:"@sptrans_", APIClient:client)
    }
}