//
//  GraphCollectionViewCell.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 23.09.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

class GraphCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifire = "graphCollectionViewCell"
    
    var date: String?
    var volume: Float?
    var targetVolume: Float?
    var volumeType: String!
    
    
    //create view in cell
    let volumeView: UIView = {
        let volumeView = UIView()
        volumeView.translatesAutoresizingMaskIntoConstraints = false
        return volumeView
    }()
    //create views to control volume max size view
    let volumeMaxSizeView: UIView = {
        let volumeView = UIView()
        volumeView.translatesAutoresizingMaskIntoConstraints = false
        return volumeView
    }()
    
    
    
    
    //label of drank water volume
    let volumeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //label of date
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //    override init(frame: CGRect) {
    //        super.init(frame: frame)
    //
    //
    //    }
    //
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    
    func setupCell() {
        
        //add image view in cell and setup constraints
        addSubview(volumeMaxSizeView)
        //we have 2 different constraints top and bottom but we can`t have both of then in one moment because they mutually exclusive so we need removed all the constraints(uses delite from super view) before the cell will reuse
        volumeView.removeFromSuperview()
        addSubview(volumeView)
        addSubview(dateLabel)
        addSubview(volumeLabel)
    
        
        let fontSize = frame.width * 1/3
        
        // date label
         
         dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
         dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
         dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
         dateLabel.heightAnchor.constraint(equalTo: widthAnchor, multiplier:  1/3).isActive = true
         
         dateLabel.text = date
         dateLabel.textAlignment = .center
         dateLabel.adjustsFontSizeToFitWidth = true
         dateLabel.font = UIFont(name: "AmericanTypewriter", size:  fontSize)
         dateLabel.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
         dateLabel.minimumScaleFactor = 0.1
        
        
        // volume view
        if volume == nil {
            volume = 0
        }
        if targetVolume == nil {
            targetVolume = 0.1
        }
        
        var volumeOfView = CGFloat(volume! / targetVolume!)
        if volumeOfView > 1 {
            volumeOfView = 1
        } else if volumeOfView == 0 {
            volumeOfView = 0.01
        }
        
        volumeMaxSizeView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        volumeMaxSizeView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        volumeMaxSizeView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        volumeMaxSizeView.bottomAnchor.constraint(equalTo: dateLabel.topAnchor).isActive = true
        
        volumeView.heightAnchor.constraint(equalTo: volumeMaxSizeView.heightAnchor, multiplier: volumeOfView).isActive = true
        volumeView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        volumeView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        volumeView.bottomAnchor.constraint(equalTo: dateLabel.topAnchor).isActive = true
        
        
        
        volumeView.backgroundColor = {
            if volumeOfView >= 0.8 {
                return .green
            } else if volumeOfView < 0.8 && volumeOfView >= 0.5 {
                return .yellow
            } else {
                return .red
            }
        }()
        volumeView.backgroundColor?.withAlphaComponent(0.1)
        volumeMaxSizeView.backgroundColor = .clear
        
        
        // volume label
    
        volumeLabel.backgroundColor = .green
        volumeLabel.heightAnchor.constraint(equalTo: widthAnchor, multiplier:  1/3).isActive = true
        //volumeLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        volumeLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        volumeLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        // if volume of view  > 0.5 the label is under top of volume view if less - upper
        if volumeOfView > 0.5 {
            volumeLabel.topAnchor.constraint(equalTo: volumeView.topAnchor).isActive = true
        } else {
            volumeLabel.bottomAnchor.constraint(equalTo: volumeView.topAnchor).isActive = true
        }
        let noDataOfVolume = "no data"
        let volumeData: String = {
            if volume != nil {
                let volumeString = volumeType == " oz" ? String(format: "%.0f", volume!) : String(volume!)
                return volumeString + volumeType
            } else {
                return noDataOfVolume
            }
        }()
        volumeLabel.text = String(volumeData)
        volumeLabel.textAlignment = .center
        volumeLabel.adjustsFontSizeToFitWidth = true
        volumeLabel.font = UIFont(name: "AmericanTypewriter", size:  fontSize)
        volumeLabel.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        volumeLabel.minimumScaleFactor = 0.1
        
        
        
    }
    
}
