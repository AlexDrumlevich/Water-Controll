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
    
    //orientation
    var isVertical = false
    
    //product url
    var productURLString = ""
    //URL to get information in app store
    // get app version 
    let appURLInAppStoreToGetVersion = "http://itunes.apple.com/jp/lookup/?id=1557104587"
    
    
    let constraintConstant: CGFloat = 5
    var gameSceneController: GameViewController?
    var alertControllerCustom: AlertControllerCustom?
    
    var currentUser: User! {
        didSet {
            //set text in label
            setupTextInPouredWaterLabel(isTheAimReached: false)
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
    
    //get one more bottle
    let maxAvailableBottles = 9
    
    //The rewarded video ad.
    var rewardedAd: GADRewardedAd?
    var needsTimesToLoadRewardedAd: Int = 0
    //test - "ca-app-pub-3940256099942544/1712485313"
    //real ID
    let rewardedAdId = "ca-app-pub-4369651523388674/1611002908"
    //flag to load new video after watching
    var adLoadCount = 1
    //waiting time to watch new reward video
    let minWaitingTimeSecondsBetweenShowingRewardVideo = 60
    //error text
    let adErrorText = AppTexts.adErrorTextAppTexts
    
    //ads
    var isGetConsentFormCallFromGetOneMoreBottle = false
    
    
    //activity indicator
    var activityIndicatorInMenuViewController: UIActivityIndicatorView?
    
    //bottom menu
    var bottomMenuCollectionView: BottomMenuCollectionView?
    var countLabelAvailableBottlesInCell: UILabel?
    var isNeedToAnimateBottomMenu = true
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
    var blurViewForGraphView: UIVisualEffectView?
    
    
    
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
    var blurViewForPourWaterMenuIntoGlass: UIVisualEffectView!
    
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
        // constraints for bottomMenuCollectionView
        isVertical = view.frame.height <= view.frame.width
        bottomMenuCollectionView = BottomMenuCollectionView(isVertical: isVertical)
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
        
        //check new app version
        checkNewAppVersionAndNotifyUserAboutNewVersion()
        //
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isNeedToAnimateBottomMenu {
            //animate bottom menu collection view
            let indexOfLastItemInBottomMenuCollectionView = bottomMenuCollectionView!.numberOfItems(inSection: 0) - 1
            
            bottomMenuCollectionView!.scrollToItem(at: IndexPath(item: indexOfLastItemInBottomMenuCollectionView, section: 0), at: .right, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.bottomMenuCollectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
                self.isNeedToAnimateBottomMenu = false
            }
        }
    }
    
    
    func addSubviews() {
        view.addSubview(bottomMenuCollectionView!)
        view.addSubview(nameLabel)
        view.addSubview(rightButton)
        view.addSubview(leftButton)
        view.addSubview(pouredWaterLabel)
        
    }
    
    
    func setupBottomMenuCollectionView() {
        // add bottomMenuCollectionView to MenuViewController
        
   
        
        bottomMenuCollectionView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        if !isVertical {
            bottomMenuCollectionView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        } else {
            bottomMenuCollectionView!.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        }
        
        bottomMenuCollectionView!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        if isVertical {
            bottomMenuCollectionView!.widthAnchor.constraint(equalTo: bottomMenuCollectionView!.heightAnchor, multiplier: 0.25).isActive = true
        } else {
            bottomMenuCollectionView!.heightAnchor.constraint(equalToConstant: view.bounds.width / 4).isActive = true
        }
        //set content to bottom menu collection view
        var isPremium = false
        if accessController != nil {
            isPremium = accessController!.premiumAccount
        }
        bottomMenuCollectionView!.getMenuModel(menuModel: BottomMenuModel.fetchContent(isPremiumAccount: isPremium))
    }
    
    
    
    
    //setupTextInPouredWaterLabel
    
    func setupTextInPouredWaterLabel(isTheAimReached: Bool) {
        
        
        guard  self.currentUser != nil else {
            return
        }
        
        
        
        self.nameLabel.text = self.currentUser.name
        
        
        if isTheAimReached {
            self.pouredWaterLabel.text = AppTexts.aimAchievedAppTexts
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
                self.calculateText()
            }
        } else {
            
            calculateText()
        }
    }
    
    private func calculateText() {
        
        
        let mlText = AppTexts.mlAppTexts
        let literText = AppTexts.literAppTexts
        let litersText = AppTexts.litersAppTexts
        
        let waterWasDrunk = self.currentUser.volumeType == "oz" ? String(Int(self.currentUser.currentVolume)) : self.currentUser.currentVolume >= 1.0 ? String(self.currentUser.currentVolume) : String(format: "%.0f", (self.currentUser.currentVolume) * 1000) + " " + mlText
        
        let fullBottleVolume = self.currentUser.volumeType == "oz" ? String(format: "%.0f", self.currentUser.fullVolume) : self.currentUser.fullVolume >= 1.0 ? String(Float(round(self.currentUser.fullVolume * 100) / 100)) : String(format: "%.0f", self.currentUser.fullVolume * 1000)
        
        let type = self.currentUser.volumeType == "oz" ? self.currentUser.volumeType ?? "oz" : self.currentUser.fullVolume >= 1.0 ? self.currentUser.fullVolume >= 2.0 ? litersText : literText : (" " + mlText)
        
        let waterWasDrunkPercentsFloat = self.currentUser.currentVolume * 100 / self.currentUser.fullVolume
        
        let waterWasDrunkPercentsFloatRounded = roundf(waterWasDrunkPercentsFloat)
        
        let waterWasDrunkPercents = String(format: "%.0f", waterWasDrunkPercentsFloatRounded)
        
        let waterWasDrunkText = AppTexts.progressAppTexts
        
        let textLabel = waterWasDrunkText + ": " + waterWasDrunk + " " + AppTexts.outOffAppTexts + " " + fullBottleVolume + " " + type + " ("  + waterWasDrunkPercents + " %)"
        self.pouredWaterLabel.text = textLabel
        
    }
    
    
    
    
    
    
    //add PouredWaterLabel setup constraints for PouredWaterLabel
    func setupPouredWaterLabel()  {
        
        pouredWaterLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constraintConstant * 2).isActive = true
        pouredWaterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  constraintConstant * 2).isActive = true
        pouredWaterLabel.topAnchor.constraint(equalTo: view.topAnchor, constant:  30).isActive = true
        pouredWaterLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12).isActive = true
        
        //set text settings
        pouredWaterLabel.textAlignment = .center
        pouredWaterLabel.font = UIFont(name: "AmericanTypewriter", size:  isVertical ? view.bounds.height * 11 / 100 : view.bounds.width * 11 / 100 )
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
        nameLabel.font = UIFont(name: "AmericanTypewriter", size:  isVertical ? view.bounds.height * 11 / 100 : view.bounds.width * 11 / 100)
        
        nameLabel.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.05
        
        
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

