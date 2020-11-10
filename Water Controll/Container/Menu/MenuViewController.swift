//
//  MenuViewController.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 23.05.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit
import GoogleMobileAds

class MenuViewController: UIViewController {
    
    
    
    let constraintConstant: CGFloat = 5
    var gameSceneController: GameViewController?
    var alertControllerCustom: AlertControllerCustom?
    
    var currentUser: User! {
        didSet {
            //set text in label
            setupTextInPouredWaterLabel()
            gameSceneController?.currentUser = currentUser
            
            // auto fill system - if current user have auto fill, other user we will check when we change them in func change user
            fillBottleAutoFillUserType()
        }
    }
    
    var isSinglUser = false {
        didSet {
            rightButton.isHidden = isSinglUser
            leftButton.isHidden = isSinglUser
        }
    }
   // acceess controller
    var accessController: AccessController?
    
    
    
    //The rewarded video ad.
    var rewardedAd: GADRewardedAd?
    var needsTimesToLoadRewardedAd: Int = 0
    let rewardedAdId = "ca-app-pub-3940256099942544/1712485313"
    var adLoadCount = 1
    
    
    //bottom menu
    var bottomMenuCollectionView = BottomMenuCollectionView()
    var countLabelAvailableBottlesInCell: UILabel?
    
    //graph view
    var graphView: UIView?
    var gotWatersDataLinkToDelete: NSMutableOrderedSet?
    var graphCollectionView: GraphCollectionView?
    var cancelGraphViewButton: UIButton?
    var deleteGraphDataButton: UIButton?
    var countDaysHistory: Int?
    var countDaysHistoryToDelete: Int?
    var deleletLabel: UILabel?
    var countDeletDaysHistirySlider: UISlider?
    
    
    
    
    //pourWaterMenu
    var pourWaterMenu: UIView!
    var pourWaterButton: UIButton!
    var cancelButtonInPourWaterMenu: UIButton!
    var unitPicker: UIPickerView!
    var tenthPicker: UIPickerView!
    var hundredPicker: UIPickerView!
    var thousandPicker: UIPickerView!
    var isOzType: Bool!
    var volumeTypeForPourWaterMenu: String!
    var volumeTypeLabelForPourWaterMenu: UILabel!
    var pickerSpinTimes = 0
    var willPourWaterVolume: Int16!
    var pickers: [UIPickerView]!
    
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
    
    // create poured Water label
    let pouredWaterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // convenience init
    convenience init(access: AccessController?, needsTimesToLoadRewardedId: Int) {
        self.init()
        self.accessController = access
        self.needsTimesToLoadRewardedAd = needsTimesToLoadRewardedId
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        //add subviews
        addSubviews()
        
        //create and load RewardedAd if needed
        createAndLoadRewardAdIfNeeded()
        
        //present and present  BottomMenuCollectionView
        setupBottomMenuCollectionView()
        
        //add PouredWaterLabel and set constraints
        setupPouredWaterLabel()
        
        //add right button and set constraints
        setupRightButton()
        
        //add left button  and set constraints
        setupLeftButton()
        
        //add name label  and set constraints
        setupNameLabel()
        
        
        //add actions
        rightButton.addTarget(self, action: #selector(changeUserNext), for: .touchUpInside)
        
        leftButton.addTarget(self, action: #selector(changeUserPrevious), for: .touchUpInside)
        
        rightButton.isHidden = isSinglUser
        leftButton.isHidden = isSinglUser
        
        //
        
        
    }
    
    
    func addSubviews() {
        view.addSubview(bottomMenuCollectionView)
        view.addSubview(nameLabel)
        view.addSubview(rightButton)
        view.addSubview(leftButton)
        view.addSubview(pouredWaterLabel)
        
    }
    
    
    func setupBottomMenuCollectionView() {
        // add bottomMenuCollectionView to MenuViewController
        
        // constraints for bottomMenuCollectionView
        bottomMenuCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomMenuCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomMenuCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomMenuCollectionView.heightAnchor.constraint(equalToConstant: view.bounds.width / 4).isActive = true
        //set content to bottom menu collection view
        var isPremium = false
        if accessController != nil {
            isPremium = accessController!.premiumAccount
        }
        bottomMenuCollectionView.getMenuModel(menuModel: BottomMenuModel.fetchContent(isPremiumAccount: isPremium))
    }

    
    
    
    //setupTextInPouredWaterLabel
    
    func setupTextInPouredWaterLabel() {
        
        guard  currentUser != nil else {
            return
        }
        
        nameLabel.text = currentUser.name
        let mlText = "ml"
        
        let waterWasDrunk = currentUser.volumeType == "oz" ? String(Int(currentUser.currentVolume)) : currentUser.currentVolume >= 1.0 ? String(currentUser.currentVolume) : String(format: "%.0f", (currentUser.currentVolume) * 1000) + " " + mlText
        
        let fullBottleVolume = currentUser.volumeType == "oz" ? String(format: "%.0f", currentUser.fullVolume) : currentUser.fullVolume >= 1.0 ? String(Float(round(currentUser.fullVolume * 100) / 100)) : String(format: "%.0f", currentUser.fullVolume * 1000)
        
        let type = currentUser.volumeType == "oz" ? currentUser.volumeType ?? "oz" : currentUser.fullVolume >= 1.0 ? currentUser.volumeType ?? "liter" : "ml"
        
        let waterWasDrunkPercentsFloat = currentUser.currentVolume * 100 / currentUser.fullVolume
        
        let waterWasDrunkPercentsFloatRounded = roundf(waterWasDrunkPercentsFloat)
        
        let waterWasDrunkPercents = String(format: "%.0f", waterWasDrunkPercentsFloatRounded)
        
        let waterWasDrunkText = String("Progress")
        
        let textLabel = waterWasDrunkText + ": " + waterWasDrunk + " out of " + fullBottleVolume + " " + type + " ("  + waterWasDrunkPercents + " %)"
        pouredWaterLabel.text = textLabel
    }
    
    
    //add PouredWaterLabel setup constraints for PouredWaterLabel
    func setupPouredWaterLabel()  {
        
        pouredWaterLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constraintConstant * 2).isActive = true
        pouredWaterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  constraintConstant * 2).isActive = true
        pouredWaterLabel.topAnchor.constraint(equalTo: view.topAnchor, constant:  30).isActive = true
        pouredWaterLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12).isActive = true
        
        //set text settings
        pouredWaterLabel.textAlignment = .center
        pouredWaterLabel.font = UIFont(name: "AmericanTypewriter", size:  view.bounds.width * 12 / 100 )
        pouredWaterLabel.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        pouredWaterLabel.adjustsFontSizeToFitWidth = true
        pouredWaterLabel.minimumScaleFactor = 0.2
        
    }
    
    //setup constraints for nameLabel
    func setupNameLabel() {
        
        //set constraints
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: pouredWaterLabel.bottomAnchor, constant: 10).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor, constant: constraintConstant).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor, constant: -constraintConstant).isActive = true
        
        nameLabel.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.12).isActive = true
        //set text settings
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: "AmericanTypewriter", size:  view.bounds.width * 12 / 100 )
        nameLabel.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.5
        
        
    }
    
    
    
    //add right button into blurView and set constraints
    func setupRightButton() {
        
        //set constraints
        rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constraintConstant).isActive = true
        rightButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 10).isActive = true
        rightButton.topAnchor.constraint(equalTo: pouredWaterLabel.bottomAnchor, constant: 10).isActive = true
        rightButton.heightAnchor.constraint(equalTo: nameLabel.heightAnchor, multiplier: 0.7).isActive = true
        
    }
    
    //add left button into blurView and set constraints
    func setupLeftButton() {
        
        //set constraints
        leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constraintConstant).isActive = true
        leftButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 10).isActive = true
        leftButton.topAnchor.constraint(equalTo: pouredWaterLabel.bottomAnchor, constant: 10).isActive = true
        leftButton.heightAnchor.constraint(equalTo: nameLabel.heightAnchor, multiplier: 0.7).isActive = true
    }
    
    
    
    
}

