//
//  ContainerViewController.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 23.05.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds
//contain 2 view controllers

class ContainerViewController: UIViewController {
    
    //core data context
    //get from  AppDelegate
    var contextDataBase: NSManagedObjectContext!
    
    // premium account
    var purchaseController: PurchaseController?
    
    //rate app
    let needTimesPourWaterToCallRateMenu: Int16 = 15

    //    product url
    let productURLString =
        "https://apps.apple.com/us/app/water-balance-amazing-bottle/id1557104587"
           
    //max 5 users
    let maxUsers = 5
    var isMaximumUsers = false

    var users: [User] = [] {
        didSet {
            if menuViewController != nil {
            menuViewController.isSinglUser = users.count == 1
            }
            
            isMaximumUsers = users.count > maxUsers
            if settingsViewController != nil {
            settingsViewController.isPlusButtonAvailableToMaxUsers = users.count <= maxUsers
            }
        }
    }
    
    
    var currentUser: User! {
        didSet {
            guard menuViewController != nil else {
                return
            }
            menuViewController.currentUser = currentUser
        }
    }
    //access controller
    var accessController: AccessController? {
        
        didSet {
            if menuViewController != nil {
                if menuViewController.accessController == nil {
                    menuViewController.accessController = accessController
                }
            }
            
            if settingsViewController != nil {
                if settingsViewController.accessController == nil {
                    settingsViewController.accessController = accessController
                }
            }
        }
    }
   
    //layouts controll
    var viewHeight: CGFloat = 0.0
    var viewWidth: CGFloat = 0.0
    
    //child controllers
    var menuViewController: MenuViewController!
    var gameViewController: UIViewController!
    var settingsViewController: SettingsViewController!
    
    //alert controller custom
    var alertControllerCustom: AlertControllerCustom?
    
    //some alert propirties use in ads and IDFA consetn to save
    var saveText = ""
    var callSaveFunctionFromGetOneMoreBottle = false
    var needToSaveConsentInDataBase = false
    
    
    
    //ads - banner
    var bannerView: GADBannerView!
    // test - "ca-app-pub-3940256099942544/2934735716"
    //real ID
    let bannerViewId = "ca-app-pub-4369651523388674/6897336216"
    var blurViewBehindBanner: UIView?
    var viewBehindAlertAnderBanner: UIView?
    
    //ads consent
    var isGoogleAdsStarted = false
    
    let publisherIdentifiers = ["pub-4369651523388674"]
    let privacyUrl = "https://sites.google.com/view/waterbalance-amazingbottle/privacypolicy"
    //ump consent
    var canRepeatRequestUMPConsent = true
    
    //ads consent
    var isAdsConsent = false {
        didSet {
            DispatchQueue.main.async {
                //we get consent in the beginning
                if self.menuViewController == nil {
                    
                    self.viewDidLoadContinueLoading()
                } else {
                    //we get consent when user try to get one more bottle, so we create banner and change constraints
                    self.createBanner()
                    if self.menuViewController != nil {
                        self.setConstraintsForChildViewWhenBunnerIsOnOff(view: self.menuViewController.view)
                    }
                    if self.gameViewController != nil {
                        self.setConstraintsForChildViewWhenBunnerIsOnOff(view: self.gameViewController.view)
                    }
                    if self.settingsViewController != nil {
                        self.setConstraintsForChildViewWhenBunnerIsOnOff(view: self.settingsViewController.view)
                    }
                    
                    if self.isNeedToShowGetOneMoreBottleAlertController && self.menuViewController != nil {
                        self.isNeedToShowGetOneMoreBottleAlertController = false
                        self.menuViewController.getOneMoreBottleAdCustomAlertController()
                    }
                    
                }
            }
        }
    }
    //if we get ads consent from get one bottle from bottom menu menu view controller
    var isNeedToShowGetOneMoreBottleAlertController = false
    
    //activity indicator
    var activityIndicatorInContainerViewController: UIActivityIndicatorView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewWidth = view.frame.width
        viewHeight = view.frame.height
        print(viewHeight, viewWidth)
        
        // get access controller
        getAccesControllerFromLocalDataBase()
        
        //get users from local database, if there is not any user in database we open settings view controller and add new user in data base without name and other attributes
        
        
        
        // prepare to get Ad Consent
        prepareToGetAdConsent(callFromGetOneMoreBottle: false)
    }
    
    override func viewDidLayoutSubviews() {
        if view.frame.width != viewWidth || view.frame.height != viewHeight {
            viewWidth = view.frame.width
            viewHeight = view.frame.height
            if menuViewController != nil {
                menuViewController.isVertical = viewWidth >= viewHeight
                if menuViewController.alertControllerCustom != nil {
                    menuViewController.alertControllerCustom?.clouseAlert()
                }
                if menuViewController.graphView != nil {
                    menuViewController.deleteGraphView()
                }
                if menuViewController.pourWaterMenu != nil {
                    menuViewController.deletePourWaterMenu()
                }
            }
            setConstraintsWhenChangeHappens()
        }
    }
    
    // get Ad Consent
    func prepareToGetAdConsent(callFromGetOneMoreBottle: Bool) {
        
        if accessController != nil {
            if !accessController!.premiumAccount {
                getAdConsent(callFromGetOneMoreBottle: callFromGetOneMoreBottle)
            } else {
                viewDidLoadContinueLoading()
            }
        } else {
            viewDidLoadContinueLoading()
        }
    }
    
    func viewDidLoadContinueLoading() {
        
        //add banner
        if isAdsConsent {
            createBanner()
        }
        
        getCurrentUsersFromLocalDataBase()
        
        //new Day Begining Set Empty Bottles Control
        newDayBeginingSetEmptyBottlesControl()
        // fill all misses got water dates
        gotWaterFill()
        
       
        //create, add and present GameViewController
        presentGameViewController()
        (gameViewController as? GameViewController)?.currentUser = currentUser
        //create, add and present MenuViewController
        presentMenuViewController()
        menuViewController.gameSceneController = gameViewController as? GameViewController
        //present SettingsViewController in closure from BottomMenuCollectionView (when user tappet on settings in bottom menu
        presentBottomMenuActionsMenuViewControllerViaClosure()
        
        
    }
    
    
    
    //MARK: create and add child controllers
    
    //create, add and present GameViewController
    fileprivate func presentGameViewController() {
        gameViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! GameViewController
        addChild(gameViewController)
        view.insertSubview(gameViewController.view, at: 0)
        //  view.addSubview(gameViewController.view)
        gameViewController.didMove(toParent: self)
        if bannerView != nil {
            
            setConstraintsForChildViewWhenBunnerIsOnOff(view: gameViewController.view)
        }
    }
    
    
    //create and add MenuViewController
    fileprivate func presentMenuViewController() {
        //calculate how many bottles we need to full soon
        var needsTimesToRewardsAd = 0
        if accessController != nil {
            if !accessController!.premiumAccount {
                for userItem in users {
                    let volumeInBottle = userItem.volumeType == "oz" ? userItem.currentVolumeInBottle : userItem.currentVolumeInBottle * 1000
                    if  volumeInBottle - Float(userItem.middlePourWaterVolume) <= 0 {
                        needsTimesToRewardsAd += 1
                    }
                }
            }
        }
        
        menuViewController = MenuViewController(access: accessController, needsTimesToLoadRewardedId: needsTimesToRewardsAd)
        menuViewController.productURLString = productURLString
        addChild(menuViewController)
        view.insertSubview(menuViewController.view, at: 1)
        // view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
        menuViewController.currentUser = currentUser
        menuViewController.isSinglUser = users.count == 1
        if bannerView != nil {
            setConstraintsForChildViewWhenBunnerIsOnOff(view: menuViewController.view)
        }
    }
    
    
    //SETTINGS VIEW CONTROLLER
    //create and present SettingsViewController and send current user
    func presentSettingsViewController(with mode: SettingsModes = .waitAction) {
        if settingsViewController != nil {
            clouseSettingsViewController()
        }
        
        DispatchQueue.main.async {
            self.settingsViewController = SettingsViewController()
            self.settingsViewController.productURLString = self.productURLString
            self.settingsViewController.isPlusButtonAvailableToMaxUsers = !self.isMaximumUsers
            self.settingsViewController.accessController = self.accessController
            
            self.settingsViewController.currentUser = self.currentUser
            self.settingsViewController.settingsMode = mode
            self.settingsViewController.nameLabel.text = self.currentUser.name
            self.settingsViewController.isSinglUser = self.users.count < 2
            
            //add  actions from settings view controller
            self.settingsViewController.settingsViewControllerComplitionActions = {
                containerViewComplitionActions in
                switch containerViewComplitionActions {
                //clouse and delete settings view controller - clousure from ExtentionSettingsViewControllerActions when user tapped the back button
                case .closeSettingsViewContainer:
                    //close settingc view controller
                    self.clouseSettingsViewController()
                case .saveContextInLocalDataBase:
                    //save data in local data base
                    self.saveContextInLocalDataBase()
                case .updateMenuViewController:
                    self.menuViewController.currentUser = self.currentUser
                    
                case .addNewUser:
                    //create new user and change curren user
                    self.createNewUser()
                //delete user and change curren user
                case .deleteUser:
                    self.deleteUser()
                case .changeUserNext:
                    self.changeUser(direction: .next)
                case .changeUserPrevious:
                    self.changeUser(direction: .previous)
                case .setupNotificationsTime(let notification, let notificatonStracture, let isLast):
                    self.setupNotificationsTime(in: notification, from: notificatonStracture, isLast: isLast) {
                        //if we have last notification we save context and call func to create Schedule Notifications in all days
                        
                        self.saveContextInLocalDataBase()
                        //after Schedule Notifications will create we`ll clouse settings menu
                        self.settingsViewController.okActionNotificationSubsettingsMenu()
                        self.updateNotifications()
                        //self.settingsViewController.createScheduleNotifications()
                        
                    }
                    //show Denied notification alert
                case .showDeniedNotificationCustomAlert(let inMenuViewController):
                    DispatchQueue.main.async {
                        if inMenuViewController && self.menuViewController != nil {
                            self.menuViewController.notificationDeniedCustomAlertInMenuViewController()
                        } else if self.settingsViewController != nil {
                            self.settingsViewController.notificationDeniedCustomAlertInSettingsViewController()
                        }
                    }
                    
                case .purchase:
                    self.sratrPurchasing()
                
                case .restorPurchases:
                    self.sratrPurchasing(needToRestoreOnly: true)
                    
                }
            }
           
            
            self.addChild(self.settingsViewController)
            self.view.addSubview(self.settingsViewController.view)
            self.settingsViewController.didMove(toParent: self)
           
            if self.bannerView != nil {
                
                self.setConstraintsForChildViewWhenBunnerIsOnOff(view: self.settingsViewController.view)
            }
            self.settingsViewController.isVertical = self.view.frame.width >= self.view.frame.height
            self.settingsViewController.activation()

        }
    }
    
    //present SettingsViewController  in closure from BottomMenuCollectionView (when user tappet on settings in bottom menu
    func presentBottomMenuActionsMenuViewControllerViaClosure() {
        
        //closure complitionPresentSettingsViewControllet from bottomMenuCollectionView
        self.menuViewController?.bottomMenuCollectionView?.complitionBottomMenuActions = { mode in
            //guard let self = self else { return }
            
            
            
            //settings
            if mode == .settings {
                self.presentSettingsViewController()
                
                //notifications
            } else if mode == .notification {
                
                self.presentSettingsViewController(with: .needToSetupNotificationSettingsOnly)
                //call following method is settings VC : self.settingsViewController?.showNotificationSubsettingsMenu()
                
                //pour water into glass
            } else if mode == .pourWaterIntoGlass {
                self.menuViewController?.showPourWaterMenu()
                
                //pour water into bottle
            } else if mode == .pourWaterIntoBottle {
                //bottle ia empty
                if self.currentUser.isEmptyBottle {
                    self.menuViewController?.pourWaterIntoBottle(with: self.accessController)
                } else {
                    //bottle is not empty
                    self.menuViewController.pourWaterIntoBottleIsNotEmptyBottle()
                }
            } else if mode == .graph {
                self.menuViewController?.createGraphView()
            } else if mode == .getOneMoreBottleInBottomMenu {
                self.getOneMoreBottleInBottomMenu()
            } else if  mode == .closeCustomAlerts {
                // close alerts
                self.menuViewController?.alertControllerCustom?.clouseAlert()
            } else if mode == .adsSettings {
                self.getAdConsent(callFromGetOneMoreBottle: false, changeAdConsent: true)
            }
        }
        
        
        
        //closure complitionPourWaterIntoBottle
        self.menuViewController.bottomMenuCollectionView?.complitionPourWaterIntoBottleAccess = { (label) in
            guard self.accessController != nil else {
                label.text = ""
                return
            }
            guard !self.accessController!.premiumAccount else {
                label.text = ""
                return
            }
            DispatchQueue.main.async {
                label.isHidden = false
                label.text = String(self.accessController!.bottelsAvailable)
                self.menuViewController?.countLabelAvailableBottlesInCell = label
            }
        }
 
    }
    
    //get one more bottle menu from menu view controller bottom menu
    func getOneMoreBottleInBottomMenu() {
        if self.isAdsConsent {
            //call custom arert method
            DispatchQueue.main.async {
                self.menuViewController?.getOneMoreBottleAdCustomAlertController()
            }
            
        } else {
            //  so we ask ads consent again
            DispatchQueue.main.async {
                self.getAdConsent(callFromGetOneMoreBottle: true)
                //  self.getAdsConsentForNotEuropeanZoneAlertController(callFromGetOneMoreBottle: true)
            }
        }
    }
    
    //close and delete settings view controller
    func clouseSettingsViewController(isBecamePremiumAccaunt: Bool = false) {
        DispatchQueue.main.async {
            self.settingsViewController?.willMove(toParent: nil)
            self.settingsViewController?.view.removeFromSuperview()
            self.settingsViewController?.removeFromParent()
            self.settingsViewController = nil
            //scroll bottom menu
            guard self.menuViewController != nil else { return }
            if !isBecamePremiumAccaunt {
                self.menuViewController.bottomMenuCollectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
            }
        }
    }
    
    
    func setConstraintsForChildViewWhenBunnerIsOnOff(view: UIView) {
        DispatchQueue.main.async {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.topAnchor.constraint(equalTo: self.bannerView == nil ? self.view.topAnchor : self.bannerView.bottomAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            
        }
    }
}
