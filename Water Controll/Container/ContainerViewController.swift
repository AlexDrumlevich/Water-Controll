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
    
    var users: [User] = [] {
        didSet {
            guard menuViewController != nil || settingsViewController != nil else {
                return
            }
            menuViewController.isSinglUser = users.count == 1
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
    var accessController: AccessController?
    
    
    //child controllers
    var menuViewController: MenuViewController!
    var gameViewController: UIViewController!
    var settingsViewController: SettingsViewController!
    
    //ads - banner
    var bannerView: GADBannerView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //get users from local database, if there is not any user in database we open settings view controller and add new user in data base without name and other attributes
        //and get access controller
        getCurrentUsersAndAccessControllerFromLocalDataBase()
        
        //new Day Begining Set Empty Bottles Control
        newDayBeginingSetEmptyBottlesControl()
        // fill all misses got water dates 
        gotWaterFill()
        
        //add banner
        if accessController != nil {
            if !accessController!.premiumAccount {
                bannerView = GADBannerView(adSize: kGADAdSizeBanner)
                addBannerViewToView(bannerView)
                bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
                bannerView.rootViewController = self
                bannerView.load(GADRequest())
                bannerView.delegate = self
            }
        }
        
        //create, add and present GameViewController
        presentGameViewController()
        (gameViewController as? GameViewController)?.currentUser = currentUser
        //create, add and present MenuViewController
        presentMenuViewController()
        menuViewController.gameSceneController = gameViewController as? GameViewController
        //present SettingsViewController in closure from BottomMenuCollectionView (when user tappet on settings in bottom menu
        presentBottomMenuActionsMenuViewControllerViaClosure()
    }
    
    
    // add banner function
    private func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .top,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
        ])
        bannerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bannerView.widthAnchor.constraint(equalToConstant: 320).isActive = true
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
            setConstraintsForChildViewWhenBunnerIsOn(view: gameViewController.view)
        }
    }
    
    
    //create and add MenuViewController
    fileprivate func presentMenuViewController() {
        //calculate how many bottles we need to full soon
        var needsTimesToRewardsAd = 0
        if accessController != nil {
            if !accessController!.premiumAccount {
                for userItem in users {
                    let volumeInBottle = userItem.volumeType == "oz" ? Int16(userItem.currentVolume) : Int16(userItem.currentVolume) * 1000
                    if  volumeInBottle - userItem.middlePourWaterVolume <= 0 {
                        needsTimesToRewardsAd += 1
                    }
                }
            }
        }
        
        menuViewController = MenuViewController(access: accessController, needsTimesToLoadRewardedId: needsTimesToRewardsAd)
        addChild(menuViewController)
        view.insertSubview(menuViewController.view, at: 1)
        // view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
        menuViewController.currentUser = currentUser
        menuViewController.isSinglUser = users.count == 1
        if bannerView != nil {
            setConstraintsForChildViewWhenBunnerIsOn(view: menuViewController.view)
        }
    }
    
    
    //SETTINGS VIEW CONTROLLER
    //create and present SettingsViewController and send current user
    func presentSettingsViewController(with mode: SettingsModes = .waitAction) {
        settingsViewController = SettingsViewController()
        
        settingsViewController.currentUser = currentUser
        settingsViewController.settingsMode = mode
        settingsViewController.nameLabel.text = currentUser.name
        settingsViewController.isSinglUser = users.count < 2
        
        //add  actions from settings view controller
        settingsViewController.settingsViewControllerComplitionActions = {
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
            }
        }
        
        self.addChild(settingsViewController)
        self.view.addSubview(settingsViewController.view)
        settingsViewController.didMove(toParent: self)
        if bannerView != nil {
            setConstraintsForChildViewWhenBunnerIsOn(view: settingsViewController.view)
        }
    }
    
    //present SettingsViewController  in closure from BottomMenuCollectionView (when user tappet on settings in bottom menu
    private func presentBottomMenuActionsMenuViewControllerViaClosure() {
        
        //closure complitionPresentSettingsViewControllet from bottomMenuCollectionView
        self.menuViewController.bottomMenuCollectionView.complitionBottomMenuActions = { mode in
            //guard let self = self else { return }
            
            
            
            //settings
            if mode == .settings {
                self.presentSettingsViewController()
                
                //notifications
            } else if mode == .notification {
                self.presentSettingsViewController(with: .needToSetupNotificationSettingsOnly)
                self.settingsViewController.showNotificationSubsettingsMenu()
                
                //pour water into glass
            } else if mode == .pourWaterIntoGlass {
                self.menuViewController.showPourWaterMenu()
                
                //pour water into bottle
            } else if mode == .pourWaterIntoBottle {
                //bottle ia empty
                if self.currentUser.isEmptyBottle {
                    self.menuViewController.pourWaterIntoBottle(with: self.accessController)
                } else {
                    //bottle is not empty
                    self.menuViewController.pourWaterIntoBottleIsNotEmptyBottle()
                }
            } else if mode == .graph {
                self.menuViewController.createGraphView()
            } else if mode == .getOneMoreBottleInBottomMenu {
                //call custom arert method
                self.menuViewController.getOneMoreBottleAdCustomAlertController()
            } else if  mode == .closeCustomAlerts {
             // close alerts
                self.menuViewController.alertControllerCustom?.clouseAlert()
            }
        }
        
        //closure complitionPourWaterIntoBottle
        self.menuViewController.bottomMenuCollectionView.complitionPourWaterIntoBottleAccess = { (label) in
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
                self.menuViewController.countLabelAvailableBottlesInCell = label
            }
        }
    }
    
    //close and delete settings view controller
    private func clouseSettingsViewController() {
        DispatchQueue.main.async {
            self.settingsViewController?.willMove(toParent: nil)
            self.settingsViewController?.view.removeFromSuperview()
            self.settingsViewController?.removeFromParent()
            self.settingsViewController = nil
            
            self.menuViewController.bottomMenuCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
        }
        
    }
    
    
    private func setConstraintsForChildViewWhenBunnerIsOn(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: bannerView.bottomAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    }
    
}
