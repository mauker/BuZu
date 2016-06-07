//
//  BusLaneTableViewCell.swift
//  buzu
//
//  Created by Ricardo Hurla on 11/05/2016.
//  Copyright © 2016 Ricardo Hurla. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol BusLaneTableViewCellDelegate{
    func didTouchFavoriteForCell(cell:BusLaneTableViewCell)
}

class BusLaneTableViewCell: UITableViewCell {
    
    var delegate:BusLaneTableViewCellDelegate! = nil
    
    @IBOutlet weak var lineNumberLabel: UILabel!
    @IBOutlet weak var lineNameLabel: UILabel!
    @IBOutlet weak var lineDirectionImage: UIImageView!
    @IBOutlet weak var lineFavoriteButton: UIButton!
    
    func setUpBusLaneCell(busLane:JSON) {
        
        print(busLane)
        
        let fullLineNumber = busLane["Letreiro"].string! + "-" + String(busLane["Tipo"].number!)
        self.lineNumberLabel.text = fullLineNumber;
        
        if (busLane["Sentido"].number == 1) {//FORWARD
            self.lineNameLabel.text = busLane["DenominacaoTPTS"].string;
            self.lineDirectionImage.image = UIImage(named:"forward_arrow")
        }else {//BACKWARD
            self.lineNameLabel.text = busLane["DenominacaoTSTP"].string;
            self.lineDirectionImage.image = UIImage(named:"back_arrow")
        }
        
        
//        let favImage = isFavorite == false ? UIImage(named:"star_empty"):UIImage(named:"star_full")
//        
//        self.lineFavoriteButton.setImage(favImage, forState: UIControlState.Normal)
    }
    
    @IBAction func didTouchFavoriteButton(sender: UIButton) {
        self.delegate .didTouchFavoriteForCell(self)
    }
}