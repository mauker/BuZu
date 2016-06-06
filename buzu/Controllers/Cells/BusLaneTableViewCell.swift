//
//  BusLaneTableViewCell.swift
//  buzu
//
//  Created by Ricardo Hurla on 11/05/2016.
//  Copyright © 2016 Ricardo Hurla. All rights reserved.
//

import UIKit

protocol BusLaneTableViewCellDelegate{
    func didTouchFavoriteForCell(cell:BusLaneTableViewCell)
}

class BusLaneTableViewCell: UITableViewCell {
    
    var delegate:BusLaneTableViewCellDelegate! = nil
    
    @IBOutlet weak var lineNumberLabel: UILabel!
    @IBOutlet weak var lineNameLabel: UILabel!
    @IBOutlet weak var lineDirectionImage: UIImageView!
    @IBOutlet weak var lineFavoriteButton: UIButton!
    
    func setUpBusLaneCell(lineNumber:String, lineName:String, lineDirection:NSNumber, isFavorite:Bool) {
        
        self.lineNumberLabel.text = lineNumber;
        self.lineNameLabel.text = lineName;
        
        let directionImage = lineDirection == 1 ? UIImage(named:"back_arrow"):UIImage(named:"forward_arrow")
        
        self.lineDirectionImage.image = directionImage
        
        let favImage = isFavorite == false ? UIImage(named:"star_empty"):UIImage(named:"star_full")
        
        self.lineFavoriteButton.setImage(favImage, forState: UIControlState.Normal)
    }
    
    @IBAction func didTouchFavoriteButton(sender: UIButton) {
        self.delegate .didTouchFavoriteForCell(self)
    }
}