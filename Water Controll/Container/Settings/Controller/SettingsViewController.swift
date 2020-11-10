//
//  SettingsViewController.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 24.05.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController {
    
    var currentUser: User!
    var settingsMode: SettingsModes = .waitAction
    var isSinglUser = true // to now if the user is single in all application
    
    //custom Alert
    var alertControllerCustom: AlertControllerCustom?
    
    
    //action complition for buttons
    //clouse settings view controller - resolve in container view controller
    var settingsViewControllerComplitionActions: ((ContainerViewComplitionActions) -> Void)!
    
    
    
    
    // create UIVisualEffectView for blur effect
    let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // create back button - go back
    let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "backArrow"), for: .normal)
        return button
    }()
    
    // create plus button - add new user
    let plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "plus"), for: .normal)
        return button
    }()
    
    // create name label - user`s name
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // create right button - next user
    let rightButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "rightArrowBlue"), for: .normal)
        return button
    }()
    
    // create left button - next user
    let leftButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "leftArrowBlue"), for: .normal)
        return button
    }()
    
    //tableView`s properties
    var tableViewMainSettings: UITableView!
    var nameTextField: UITextField!
    //label instead placeholder text in text field - we set it in ExtentionSettingsViewControllerActions.swift (when changed text field) and in ExtentionSettingsViewControllerTableview.swift when we get label in cellForRowAt indexPath: IndexPath method
    var youNameLabelInCell: UILabel!
    var volumeLabel: UILabel!
    var volumeBottleImageView: UIImageView!
    var isAutoFillBottleTypeImageView: UIImageView!
    //flag -  is key board hidden
    var isKeyboardHidden = true
    
    
    
    //create OK button - save settings
    let okButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "okButton"), for: .normal)
        return button
    }()
    
    //create cancel button - cancel with out save settings
    let cancelButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "cancelButton"), for: .normal)
        return button
    }()
    
    //ok and cancel buttons bottom constraint (for change them when keyboard shown or hidden
    var bottomOkButtonConstraint: NSLayoutConstraint!
    var bottomCancelButtonConstraint: NSLayoutConstraint!
 
    
    //create delete button - delete user
    let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "delete"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    
    
    // volume subsettings menu`s properties
    var volumeSubsettingsMenu: UIView!
    //pickers for subsettings menu
    var literIntegerPicker: UIPickerView!
    var literTenthPicker: UIPickerView!
    var dotBetweenliterIntegerPickerAndLiterTenthPicker: UIImageView!
    var ozPicker: UIPickerView!
    var fullBottleVolume: Float = 0.0
    //helper to get moment when the picker spining was stopped
    var pickerSpinTimes = 0
    //max integer liters: 0 - 9
    let numberOfMaxIntegerLites = 10
    //max integer oz: 0 - 299
    let numberOfMaxOz = 300
    // to disable complition possible of text fied
    var isSubMinimumVolume = false
    //save volume until user pressed ok button
    var temperaryVolumeType: String? = nil ?? ""
    //buttons for subsettings menu
    var literButton: UIButton!
    var ozButton: UIButton!
    let constraintConstant: CGFloat = 5
    
    
    //notification subsettings menu`s properties
    var notificationSubsettingsMenu: UITableView!
    var notifications: NSMutableOrderedSet!
    var notificationsStracture: [NotificationsStructure]!
    var isAmStartTime: [Bool]!
    var isAmStopTime: [Bool]!
    var notificationCenter: Notifications!
    var isBlinkings: [Bool]!
    //NotificationsTimeSubsettingsMenu
    var notificationsTimeSubsettingsMenu: UITableView!
    var notificationForSetupNotificationsTime: [Int16]!
    var currentNotificationsTimeDaySender: Int!
    var isNextDay: [Bool]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        //add views into blur view
        addViews()
        

        // addAndConfigureTableView - from file ExtentionSettingsViewControllerTableview
        addAndConfigureTableView()
        
        //add blurView into view and set constraints from file ExtentionSettingsViewControllerSetupButtonsAndLabels.swift
        setupBlurView()
        
        //add back button into blurView and set constraints from file ExtentionSettingsViewControllerSetupButtonsAndLabels.swift
        setupBackButton()
        
        //add plus button into blurView and set constraints from file ExtentionSettingsViewControllerSetupButtonsAndLabels.swift
        setupPlusButton()
        
        
        //add right button into blurView and set constraints from file ExtentionSettingsViewControllerSetupButtonsAndLabels.swift
        setupRightButton()
        
        //add left button into blurView and set constraints from file ExtentionSettingsViewControllerSetupButtonsAndLabels.swift
        setupLeftButton()
        
        //add name label  into blurView and set constraints from file ExtentionSettingsViewControllerSetupButtonsAndLabels.swift
        setupNameLabel()
        
        
        //add CancelButton  into blurView and set constraints from file ExtentionSettingsViewControllerSetupButtonsAndLabels.swift
        setupCancelButton()
        
        //add OkButton  into blurView and set constraints from file ExtentionSettingsViewControllerSetupButtonsAndLabels.swift
        setupOkButton()
        
        //add DeleteButton  into blurView and set constraints from file ExtentionSettingsViewControllerSetupButtonsAndLabels.swift
        setupDeleteButton()
        
        setupConstraintsForTableViewMainSettings()
        
        //add button actions - from ExtentionSettingsViewControllerActions
        addActions()
        
        //setup user`s name in label
        nameLabel.text = currentUser.name
        
        //add keyboard observer
        addKeyboardObserver()
        
        //hide left , right butoons if the sinfl user
        hiddenButtons(buttons: [leftButton, rightButton], isHidden: isSinglUser)
        
        //setup buttons and open Volume Subsettings Menu depend on settings mode
        switch settingsMode {
        case .firstUser:
            hiddenButtons(buttons: [plusButton, backButton, deleteButton, leftButton, rightButton], isHidden: true)
        case .newUser:
            hiddenButtons(buttons: [plusButton, backButton, deleteButton, leftButton, rightButton], isHidden: true)
        case .needToSetupVolumeSettings:
            hiddenButtons(buttons: [plusButton, backButton, deleteButton, leftButton, rightButton], isHidden: true)
            showVolumeSubsettingsMenu()
        default:
            print(settingsMode)
        }
    }
    
    
    
    override func viewWillLayoutSubviews() {
        
    }
    
    deinit {
        print("SettingsViewController delited")
    }
    

    }

