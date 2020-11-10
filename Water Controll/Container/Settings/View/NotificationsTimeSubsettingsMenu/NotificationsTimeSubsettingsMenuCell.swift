//
//  NotificationsTimeSubsettingsMenuCellTableViewCell.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 03.07.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

class NotificationsTimeSubsettingsMenuCell: UITableViewCell {
    
    static let cellID = "notificationsTimeSubsettingsMenuCellTableViewCell"
    let constraintConstant: CGFloat = 5
    
    var notificationNumberLabel: UILabel!
    var timeLabel: UILabel!
    var timeSlider: UISlider!
    var amPmLabel: UILabel!
    var nextDayLabel: UILabel!
    //setup cells depending of type (SettingsViewControllerTableViewCellType) of cell
    //item width depend on view width)
    func setupCell(itemWidth: CGFloat, rowNumber: Int) {
        
        self.selectionStyle = .none
        backgroundColor = .clear
        
        
        notificationNumberLabel = UILabel()
        notificationNumberLabel.font = UIFont(name: "AmericanTypewriter", size:  itemWidth * 0.5)
        notificationNumberLabel.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        notificationNumberLabel.adjustsFontSizeToFitWidth = true
        notificationNumberLabel.minimumScaleFactor = 0.2
        notificationNumberLabel.textAlignment = .left
        addSubview(notificationNumberLabel)
        notificationNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        timeLabel = UILabel()
        timeLabel.font = UIFont(name: "AmericanTypewriter", size:  itemWidth * 0.8)
        timeLabel.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.minimumScaleFactor = 0.2
        timeLabel.textAlignment = .left
        addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        timeSlider = UISlider()
        timeSlider.maximumTrackTintColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        timeSlider.minimumTrackTintColor = .black
        timeSlider.tag = rowNumber
        addSubview(timeSlider)
        timeSlider.translatesAutoresizingMaskIntoConstraints = false
        
        amPmLabel = UILabel()
        amPmLabel.font = UIFont(name: "AmericanTypewriter", size:  itemWidth * 0.5)
        amPmLabel.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        amPmLabel.adjustsFontSizeToFitWidth = true
        amPmLabel.minimumScaleFactor = 0.2
        amPmLabel.textAlignment = .center
        addSubview(amPmLabel)
        amPmLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nextDayLabel = UILabel()
        nextDayLabel.font = UIFont(name: "AmericanTypewriter", size:  itemWidth * 0.5)
        nextDayLabel.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        nextDayLabel.text = ""
        nextDayLabel.adjustsFontSizeToFitWidth = true
        nextDayLabel.minimumScaleFactor = 0.2
        nextDayLabel.textAlignment = .center
        
        addSubview(nextDayLabel)
        nextDayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        //setup constraints
        
        
        notificationNumberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constraintConstant).isActive = true
        notificationNumberLabel.topAnchor.constraint(equalTo: topAnchor, constant: constraintConstant).isActive = true
        notificationNumberLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4).isActive = true
        notificationNumberLabel.widthAnchor.constraint(equalTo: notificationNumberLabel.heightAnchor).isActive = true
        
        
        timeLabel.leadingAnchor.constraint(equalTo: notificationNumberLabel.trailingAnchor, constant: constraintConstant * 2).isActive = true
        timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: constraintConstant).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: notificationNumberLabel.heightAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalTo: timeLabel.heightAnchor, multiplier: 3).isActive = true
        
        nextDayLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: constraintConstant).isActive = true
               nextDayLabel.trailingAnchor.constraint(equalTo: amPmLabel.leadingAnchor, constant: -constraintConstant).isActive = true
               nextDayLabel.topAnchor.constraint(equalTo: topAnchor, constant: constraintConstant).isActive = true
        
        timeSlider.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: constraintConstant).isActive = true
        timeSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constraintConstant).isActive = true
        timeSlider.trailingAnchor.constraint(equalTo: amPmLabel.leadingAnchor, constant: -constraintConstant).isActive = true
        
        
        amPmLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constraintConstant).isActive = true
        amPmLabel.heightAnchor.constraint(equalToConstant: itemWidth * 0.5).isActive = true
        amPmLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: constraintConstant).isActive = true
        amPmLabel.widthAnchor.constraint(equalTo: amPmLabel.heightAnchor, multiplier: 1.3).isActive = true
        
       
        
    }
}
