//
//  NotificationSubsettingsMenuCell.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 13.06.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

class NotificationSubsettingsMenuCell: UITableViewCell {
    
    static let cellID = "notificationSettingsTableViewCell"
    let constraintConstant: CGFloat = 5
    
    var textField: UITextField!
    var youNameLabel: UILabel!
    
    var isGeneralCell = false
    
    var volumeLabel: UILabel!
    var bottleImageView: UIImageView!
    
    var repeatImageView: UIImageView!
    var timesADayLabel: UILabel!
    var startLabel: UILabel!
    var stopLabel: UILabel!
    
    var segmentedControllAvailabilityNotification: UISegmentedControl!
    var segmentedControllCommonSettings: UISegmentedControl!
    var lessTimesButton: UIButton!
    var timesRepeatCountLabel: UILabel!
    var moreTimesButton: UIButton!
    var extentionSetupNotificationTimesADayButton: UIButton!
    var startTimeLabel: UILabel!
    //var startTimeSegmentedControl: UISegmentedControl!
    var startAmPmLabel: UILabel!
    var startSlider: UISlider!
    var stopTimeLabel: UILabel!
    // var stopTimeSegmentedControl: UISegmentedControl!
    var stopAmPmLabel: UILabel!
    var stopTimeSlider: UISlider!
    
    //setup cells depending of type (SettingsViewControllerTableViewCellType) of cell
    //item width depend on view width)
   // func setupCell(withFirstTypeMondy typeMonday: NotificationSettingsTableViewCellTypeMondayFirst, withFirstTypeSunday typeSunday: NotificationSettingsTableViewCellTypeSundayFirst, currentTypeMonday: Bool, itemWidth: CGFloat)
    func setupCell(withTag tag: Int, isGeneral: Bool, itemWidth: CGFloat) {
        
        
        self.selectionStyle = .none
        backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        segmentedControllAvailabilityNotification = UISegmentedControl()
        segmentedControllAvailabilityNotification.insertSegment(withTitle: " off ", at: 0, animated: true)
        segmentedControllAvailabilityNotification.insertSegment(withTitle: "on ", at: 1, animated: true)
        
        //segmentedControllAvailabilityNotification.tag = currentTypeMonday ? typeMonday.rawValue : typeSunday.rawValue
        segmentedControllAvailabilityNotification.tag = tag
        segmentedControllAvailabilityNotification.accessibilityIdentifier = "segmentedControllAvailabilityNotification"
        self.contentView.addSubview(segmentedControllAvailabilityNotification)
       // addSubview(segmentedControllAvailabilityNotification)
        segmentedControllAvailabilityNotification.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControllAvailabilityNotification.heightAnchor.constraint(equalToConstant: itemWidth * 0.7).isActive = true
        segmentedControllAvailabilityNotification.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constraintConstant).isActive = true
        segmentedControllAvailabilityNotification.topAnchor.constraint(equalTo: topAnchor, constant: constraintConstant).isActive = true
        
        segmentedControllCommonSettings = UISegmentedControl()
      // if typeMonday == .generalSettings || typeSunday == .generalSettings  {segmentedControllCommonSettings.isHidden = true}
    
        segmentedControllCommonSettings.isHidden = isGeneral
        segmentedControllCommonSettings.insertSegment(withTitle: AppTexts.commonAppTexts, at: 0, animated: true)
        segmentedControllCommonSettings.insertSegment(withTitle: AppTexts.specialAppTexts, at: 1, animated: true)
        //segmentedControllCommonSettings.tag = currentTypeMonday ? typeMonday.rawValue : typeSunday.rawValue
        segmentedControllCommonSettings.tag = tag
        self.contentView.addSubview(segmentedControllCommonSettings)
       // addSubview(segmentedControllCommonSettings)
        segmentedControllCommonSettings.translatesAutoresizingMaskIntoConstraints = false
        segmentedControllCommonSettings.heightAnchor.constraint(equalToConstant: itemWidth * 0.7).isActive = true
        segmentedControllCommonSettings.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constraintConstant).isActive = true
        segmentedControllCommonSettings.topAnchor.constraint(equalTo: topAnchor, constant: constraintConstant).isActive = true
        
        
        repeatImageView = UIImageView()
        repeatImageView.backgroundColor = .clear
        repeatImageView.image = UIImage(named: "notification")
        self.contentView.addSubview(repeatImageView)
        //addSubview(repeatImageView)
        
        timesADayLabel = UILabel()
        timesADayLabel.font = UIFont(name: "AmericanTypewriter", size:  itemWidth * 0.4)
        timesADayLabel.numberOfLines = 2
        timesADayLabel.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        timesADayLabel.adjustsFontSizeToFitWidth = true
        timesADayLabel.minimumScaleFactor = 0.2
        timesADayLabel.textAlignment = .left
        timesADayLabel.text = AppTexts.timesADayAppTexts
        self.contentView.addSubview(timesADayLabel)
        //addSubview(timesADayLabel)
        timesADayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        lessTimesButton = UIButton()
        lessTimesButton.backgroundColor = .clear
        lessTimesButton.setImage(UIImage(named: "minusTimesButton"), for: .normal)
        //lessTimesButton.tag = currentTypeMonday ? typeMonday.rawValue : typeSunday.rawValue
        lessTimesButton.tag = tag
        self.contentView.addSubview(lessTimesButton)
        //addSubview(lessTimesButton)
        
        timesRepeatCountLabel = UILabel()
        timesRepeatCountLabel.font = UIFont(name: "AmericanTypewriter", size:  itemWidth)
        timesRepeatCountLabel.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        timesRepeatCountLabel.adjustsFontSizeToFitWidth = true
        timesRepeatCountLabel.minimumScaleFactor = 0.2
        timesRepeatCountLabel.textAlignment = .center
        timesRepeatCountLabel.text = "2"
        self.contentView.addSubview(timesRepeatCountLabel)
        //addSubview(timesRepeatCountLabel)
        
        moreTimesButton = UIButton()
        moreTimesButton.backgroundColor = .clear
        moreTimesButton.setImage(UIImage(named: "plusTimesButton"), for: .normal)
        //moreTimesButton.tag = currentTypeMonday ? typeMonday.rawValue : typeSunday.rawValue
        moreTimesButton.tag = tag
        self.contentView.addSubview(moreTimesButton)
        //addSubview(moreTimesButton)
        
        extentionSetupNotificationTimesADayButton = UIButton()
        extentionSetupNotificationTimesADayButton.backgroundColor = .clear
        extentionSetupNotificationTimesADayButton.setImage(UIImage(named: "rightArrowBlue"), for: .normal)
        //extentionSetupNotificationTimesADayButton.tag = currentTypeMonday ? typeMonday.rawValue : typeSunday.rawValue
        extentionSetupNotificationTimesADayButton.tag = tag
        self.contentView.addSubview(extentionSetupNotificationTimesADayButton)
        //addSubview(extentionSetupNotificationTimesADayButton)
        
        startLabel = UILabel()
        startLabel.font = UIFont(name: "AmericanTypewriter", size:  itemWidth * 0.6)
        startLabel.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        startLabel.adjustsFontSizeToFitWidth = true
        startLabel.minimumScaleFactor = 0.2
        startLabel.textAlignment = .left
        startLabel.text = "Start:"
        self.contentView.addSubview(startLabel)
        //addSubview(startLabel)
        
        startTimeLabel = UILabel()
        startTimeLabel.font = UIFont(name: "AmericanTypewriter", size:  itemWidth * 0.6)
        startTimeLabel.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        startTimeLabel.adjustsFontSizeToFitWidth = true
        startTimeLabel.minimumScaleFactor = 0.2
        startTimeLabel.textAlignment = .center
        startTimeLabel.backgroundColor = .clear
        self.contentView.addSubview(startTimeLabel)
       // addSubview(startTimeLabel)
        
        startAmPmLabel = UILabel()
        startAmPmLabel.font = UIFont(name: "AmericanTypewriter", size:  itemWidth * 0.5)
        startAmPmLabel.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        startAmPmLabel.adjustsFontSizeToFitWidth = true
        startAmPmLabel.minimumScaleFactor = 0.2
        startAmPmLabel.textAlignment = .center
        self.contentView.addSubview(startAmPmLabel)
      //  addSubview(startAmPmLabel)
        
        startSlider = UISlider()
        startSlider.maximumTrackTintColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        startSlider.thumbTintColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        startSlider.thumbTintColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
    
        startSlider.minimumTrackTintColor = .white
        //startSlider.tag = currentTypeMonday ? typeMonday.rawValue : typeSunday.rawValue
        startSlider.tag = tag
        self.contentView.addSubview(startSlider)
      //  addSubview(startSlider)
        
        stopLabel = UILabel()
        stopLabel.font = UIFont(name: "AmericanTypewriter", size:  itemWidth * 0.6)
        stopLabel.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        stopLabel.adjustsFontSizeToFitWidth = true
        stopLabel.minimumScaleFactor = 0.2
        stopLabel.textAlignment = .left
        stopLabel.text = "Stop:"
        self.contentView.addSubview(stopLabel)
        //addSubview(stopLabel)
        
        stopTimeLabel = UILabel()
        stopTimeLabel.font = UIFont(name: "AmericanTypewriter", size:  itemWidth * 0.6)
        stopTimeLabel.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        stopTimeLabel.backgroundColor = .clear
        stopTimeLabel.adjustsFontSizeToFitWidth = true
        stopTimeLabel.minimumScaleFactor = 0.2
        stopTimeLabel.textAlignment = .center
        self.contentView.addSubview(stopTimeLabel)
        //addSubview(stopTimeLabel)
        
        stopAmPmLabel = UILabel()
        stopAmPmLabel.font = UIFont(name: "AmericanTypewriter", size:  itemWidth * 0.5)
        stopAmPmLabel.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        stopAmPmLabel.adjustsFontSizeToFitWidth = true
        stopAmPmLabel.minimumScaleFactor = 0.2
        stopAmPmLabel.textAlignment = .center
        self.contentView.addSubview(stopAmPmLabel)
        //addSubview(stopAmPmLabel)
        
        stopTimeSlider = UISlider()
        //stopTimeSlider.tag = currentTypeMonday ? typeMonday.rawValue : typeSunday.rawValue
        stopTimeSlider.tag = tag
        stopTimeSlider.minimumTrackTintColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        stopTimeSlider.thumbTintColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        stopTimeSlider.maximumTrackTintColor  = .white
        self.contentView.addSubview(stopTimeSlider)
        //addSubview(stopTimeSlider)
        
        
        // CONSTRAINTS
        //repeatImageView
        repeatImageView.translatesAutoresizingMaskIntoConstraints = false
        repeatImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constraintConstant).isActive = true
        repeatImageView.topAnchor.constraint(equalTo: segmentedControllAvailabilityNotification.bottomAnchor, constant: constraintConstant).isActive = true
        repeatImageView.heightAnchor.constraint(equalToConstant: itemWidth).isActive = true
        repeatImageView.widthAnchor.constraint(equalTo: repeatImageView.heightAnchor).isActive = true
        
        //timesADayLabel
        timesADayLabel.leadingAnchor.constraint(equalTo: repeatImageView.trailingAnchor, constant: constraintConstant).isActive = true
        timesADayLabel.centerYAnchor.constraint(equalTo: repeatImageView.centerYAnchor).isActive = true
        timesADayLabel.heightAnchor.constraint(equalTo: repeatImageView.heightAnchor).isActive = true
        timesADayLabel.widthAnchor.constraint(equalTo: timesADayLabel.heightAnchor, multiplier:  1.5).isActive = true
        
        
        //lessTimesButton
        lessTimesButton.translatesAutoresizingMaskIntoConstraints = false
        lessTimesButton.leadingAnchor.constraint(equalTo: timesADayLabel.trailingAnchor, constant: constraintConstant).isActive = true
        lessTimesButton.centerYAnchor.constraint(equalTo: repeatImageView.centerYAnchor).isActive = true
        lessTimesButton.heightAnchor.constraint(equalTo: repeatImageView.heightAnchor, multiplier: 0.8).isActive = true
        lessTimesButton.widthAnchor.constraint(equalTo: lessTimesButton.heightAnchor).isActive = true
        
        //timesRepeatCountLabel
        timesRepeatCountLabel.translatesAutoresizingMaskIntoConstraints = false
        timesRepeatCountLabel.leadingAnchor.constraint(equalTo: lessTimesButton.trailingAnchor, constant: constraintConstant).isActive = true
        timesRepeatCountLabel.centerYAnchor.constraint(equalTo: repeatImageView.centerYAnchor).isActive = true
        timesRepeatCountLabel.heightAnchor.constraint(equalTo: repeatImageView.heightAnchor).isActive = true
        timesRepeatCountLabel.widthAnchor.constraint(equalTo: timesRepeatCountLabel.heightAnchor).isActive = true
        
        //moreTimesButton
        moreTimesButton.translatesAutoresizingMaskIntoConstraints = false
        moreTimesButton.leadingAnchor.constraint(equalTo: timesRepeatCountLabel.trailingAnchor, constant: constraintConstant).isActive = true
        moreTimesButton.centerYAnchor.constraint(equalTo: repeatImageView.centerYAnchor).isActive = true
        moreTimesButton.heightAnchor.constraint(equalTo: repeatImageView.heightAnchor, multiplier: 0.8).isActive = true
        moreTimesButton.widthAnchor.constraint(equalTo: moreTimesButton.heightAnchor).isActive = true
        
        //extentionSetupNotificationTimesADayButton
        extentionSetupNotificationTimesADayButton.translatesAutoresizingMaskIntoConstraints = false
        extentionSetupNotificationTimesADayButton.leadingAnchor.constraint(equalTo: moreTimesButton.trailingAnchor, constant: constraintConstant * 3).isActive = true
        extentionSetupNotificationTimesADayButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constraintConstant).isActive = true
        extentionSetupNotificationTimesADayButton.centerYAnchor.constraint(equalTo: repeatImageView.centerYAnchor).isActive = true
        extentionSetupNotificationTimesADayButton.heightAnchor.constraint(equalTo: moreTimesButton.heightAnchor).isActive = true
        
        //startLabel
        startLabel.translatesAutoresizingMaskIntoConstraints = false
        startLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constraintConstant).isActive = true
        startLabel.topAnchor.constraint(equalTo: repeatImageView.bottomAnchor, constant: constraintConstant).isActive = true
        startLabel.heightAnchor.constraint(equalToConstant: itemWidth * 0.6).isActive = true
        startLabel.widthAnchor.constraint(equalTo: startLabel.heightAnchor, multiplier: 3).isActive = true
        
        //startTimeLabel
        startTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        startTimeLabel.leadingAnchor.constraint(equalTo: startLabel.trailingAnchor, constant: constraintConstant).isActive = true
        startTimeLabel.topAnchor.constraint(equalTo: repeatImageView.bottomAnchor, constant: constraintConstant).isActive = true
        startTimeLabel.heightAnchor.constraint(equalToConstant: itemWidth * 0.6).isActive = true
        startTimeLabel.widthAnchor.constraint(equalTo: startTimeLabel.heightAnchor, multiplier: 3).isActive = true
        
        //startAmPmLabel
        startAmPmLabel.translatesAutoresizingMaskIntoConstraints = false
        startAmPmLabel.heightAnchor.constraint(equalToConstant: itemWidth * 0.7).isActive = true
        startAmPmLabel.leadingAnchor.constraint(equalTo: startTimeLabel.trailingAnchor, constant: constraintConstant).isActive = true
        startAmPmLabel.centerYAnchor.constraint(equalTo: startLabel.centerYAnchor).isActive = true
        /*
         startTimeSegmentedControl = UISegmentedControl()
         startTimeSegmentedControl.tag = currentTypeMonday ? typeMonday.rawValue : typeSunday.rawValue
         startTimeSegmentedControl.insertSegment(withTitle: "am", at: 0, animated: true)
         startTimeSegmentedControl.insertSegment(withTitle: "pm", at: 1, animated: true)
         startTimeSegmentedControl.tintColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
         addSubview(startTimeSegmentedControl)
         startTimeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
         startTimeSegmentedControl.heightAnchor.constraint(equalToConstant: itemWidth * 0.7).isActive = true
         startTimeSegmentedControl.leadingAnchor.constraint(equalTo: startTimeLabel.trailingAnchor, constant: constraintConstant).isActive = true
         startTimeSegmentedControl.centerYAnchor.constraint(equalTo: startLabel.centerYAnchor).isActive = true
         // startTimeSegmentedControl.topAnchor.constraint(equalTo: repeatImageView.bottomAnchor, constant: constraintConstant).isActive = true
         */
        
        //startSlider
        startSlider.translatesAutoresizingMaskIntoConstraints = false
        startSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constraintConstant).isActive = true
        startSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constraintConstant).isActive = true
        startSlider.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: constraintConstant).isActive = true
        
        //stopLabel
        stopLabel.translatesAutoresizingMaskIntoConstraints = false
        stopLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constraintConstant).isActive = true
        stopLabel.topAnchor.constraint(equalTo: startSlider.bottomAnchor, constant: constraintConstant).isActive = true
        stopLabel.heightAnchor.constraint(equalToConstant: itemWidth * 0.6).isActive = true
        stopLabel.widthAnchor.constraint(equalTo: startLabel.heightAnchor, multiplier: 3).isActive = true
        
        //stopTimeLabel
        stopTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        stopTimeLabel.leadingAnchor.constraint(equalTo: stopLabel.trailingAnchor, constant: constraintConstant).isActive = true
        stopTimeLabel.topAnchor.constraint(equalTo: startSlider.bottomAnchor, constant: constraintConstant).isActive = true
        stopTimeLabel.heightAnchor.constraint(equalToConstant: itemWidth * 0.6).isActive = true
        stopTimeLabel.widthAnchor.constraint(equalTo: stopTimeLabel.heightAnchor, multiplier: 3).isActive = true
        
        
        //stopAmPmLabel
        stopAmPmLabel.translatesAutoresizingMaskIntoConstraints = false
        stopAmPmLabel.heightAnchor.constraint(equalToConstant: itemWidth * 0.7).isActive = true
        stopAmPmLabel.leadingAnchor.constraint(equalTo: stopTimeLabel.trailingAnchor, constant: constraintConstant).isActive = true
        stopAmPmLabel.centerYAnchor.constraint(equalTo: stopLabel.centerYAnchor).isActive = true
        
        /*
         stopTimeSegmentedControl = UISegmentedControl()
         stopTimeSegmentedControl.tag = currentTypeMonday ? typeMonday.rawValue : typeSunday.rawValue
         stopTimeSegmentedControl.insertSegment(withTitle: "am", at: 0, animated: true)
         stopTimeSegmentedControl.insertSegment(withTitle: "pm", at: 1, animated: true)
         stopTimeSegmentedControl.tintColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
         addSubview(stopTimeSegmentedControl)
         stopTimeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
         stopTimeSegmentedControl.heightAnchor.constraint(equalToConstant: itemWidth * 0.7).isActive = true
         stopTimeSegmentedControl.leadingAnchor.constraint(equalTo: stopTimeLabel.trailingAnchor, constant: constraintConstant).isActive = true
         stopTimeSegmentedControl.centerYAnchor.constraint(equalTo: stopLabel.centerYAnchor).isActive = true
         // stopTimeSegmentedControl.topAnchor.constraint(equalTo: startSlider.bottomAnchor, constant: constraintConstant).isActive = true
         */
        
        //stopTimeSlider
        stopTimeSlider.translatesAutoresizingMaskIntoConstraints = false
        stopTimeSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constraintConstant).isActive = true
        stopTimeSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constraintConstant).isActive = true
        stopTimeSlider.topAnchor.constraint(equalTo: stopLabel.bottomAnchor, constant: constraintConstant).isActive = true
        
    }
}

