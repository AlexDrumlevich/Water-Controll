//
//  BottomMenuCollectionViewCell.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 23.05.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

class BottomMenuCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifire = "bottomMenuCollectionViewCell"
    
    //create image view in cell
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //label count bottles available
    let countLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      
          //add image view in cell and setup constraints
        addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backgroundColor = .clear
        
        addSubview(countLabel)
        countLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3).isActive = true
        countLabel.widthAnchor.constraint(equalTo: countLabel.heightAnchor).isActive = true
        countLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        countLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        countLabel.textAlignment = .center
        let fontSize = frame.height * 1/3
        countLabel.adjustsFontSizeToFitWidth = true
        countLabel.font = UIFont(name: "AmericanTypewriter", size:  fontSize)
        countLabel.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        countLabel.minimumScaleFactor = 0.1
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
