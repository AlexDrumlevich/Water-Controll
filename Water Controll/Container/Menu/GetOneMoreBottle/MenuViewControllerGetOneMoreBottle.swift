//
//  MenuViewControllerGetOneMoreBottle.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 08.11.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Foundation

enum IsOneMoreBottleAvailable {
    case available, notTimeAvailable, notMoreBottlesAvailable
}


// get one more bottle
extension MenuViewController: GADRewardedAdDelegate {
    
    
//availablility of get one more bottle
    func isGetOneMoreBottleAvailable() -> IsOneMoreBottleAvailable {
        

        if accessController != nil {
            if accessController!.bottelsAvailable >= maxAvailableBottles {
                return .notMoreBottlesAvailable
            }
        }
        
        
        guard let lastAdsDate = accessController?.lastWatchingRewardAdsTime else {
            return .available
        }
        // get current date
        let currentDate = Date()
        let calendar = Calendar.current
        
        
        
        //count diffetent between last and current date
        guard let differentDatesInDays = calendar.dateComponents([.day], from: lastAdsDate, to: currentDate).day else {
            return .available
        }
        if differentDatesInDays > 0 {
            return .available
        } else {
            guard let differentDatesInSeconds = calendar.dateComponents([.second], from: lastAdsDate, to: currentDate).second  else {
                return .available
            }
            if differentDatesInSeconds < minWaitingTimeSecondsBetweenShowingRewardVideo {
                return .notTimeAvailable
            } else {
                return .available
            }
        }
        
    }
    
    

    
    func getOneMoreBottleNotAvailable(_ notAvailableId: IsOneMoreBottleAvailable) {
        
        if alertControllerCustom != nil {
            alertControllerCustom?.clouseAlert()
        }
        
        alertControllerCustom = AlertControllerCustom()
        let alertId = alertControllerCustom?.alertID
        let name = currentUser.name
      
        let firstGreetingWord = AppTexts.firstGreetingWord
            
        
        let greetingText = firstGreetingWord + (name == nil ? "!" : ", " + name! + "!")
        
        var messageText = ""
        
        switch notAvailableId {
        case .notMoreBottlesAvailable:
            messageText = AppTexts.youHaveMaximumFullBottlesAppTexts
            let maxAvailableBottlesText = " \(maxAvailableBottles)!"
            messageText = messageText + maxAvailableBottlesText
            
        case .notTimeAvailable:
            messageText = AppTexts.adToGetOneMoreBottleWillBeAvailableInAppTexts
            
        default:
            messageText = AppTexts.adsToGetOneMoreBottleNotAvailableAppTexts
            guard alertControllerCustom != nil else { return }
        }
        
        guard alertControllerCustom != nil else { return }
        alertControllerCustom!.createAlert(observer: self, alertIdentifire: .getOneMoreBottleNotAvailable, view: view, text: greetingText + messageText, imageName: nil, firstButtonText: "cancelSmallBlue", secondButtonText: "unlimitedBottels", thirdButtonText: nil, imageInButtons: true)
        if notAvailableId == .notTimeAvailable {
            changeSecondsInAlertToAvailableOneMoreBottle(alertId: alertId!, text: greetingText + messageText)
        }
    
    }
    
    
    //count different in seconds
    //return seconds if it is more than 0, else return nil
    private func calculateSecondsToAdsAvailable() -> Int? {
        guard let lastAdsDate = accessController?.lastWatchingRewardAdsTime else {
            return nil
        }
        let currentDate = Date()
        let calendar = Calendar.current
        guard let differentDatesInSeconds = calendar.dateComponents([.second], from: lastAdsDate, to: currentDate).second else {
            return nil
        }
        if differentDatesInSeconds < minWaitingTimeSecondsBetweenShowingRewardVideo {
            return minWaitingTimeSecondsBetweenShowingRewardVideo - differentDatesInSeconds
        } else {
            return nil
        }
    }
    
    private func changeSecondsInAlertToAvailableOneMoreBottle(alertId: String, text: String) {
        
        guard alertControllerCustom != nil else {
            return
        }
        guard alertControllerCustom?.alertID == alertId else {
            return
        }
        guard let secondsToAdsAvalible = calculateSecondsToAdsAvailable() else {
            getOneMoreBottleAdCustomAlertController(needToCheckAvalible: false)
            return
        }
        alertControllerCustom?.label?.text = text + String(secondsToAdsAvalible)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.changeSecondsInAlertToAvailableOneMoreBottle(alertId: alertId, text: text)
        }

    }
    
    
    
    
    func getOneMoreBottleAdCustomAlertController(text: String? = nil, needToCheckAvalible: Bool = true) {
        
        if needToCheckAvalible {
            switch isGetOneMoreBottleAvailable() {
            
            case .available:
                break
            case .notTimeAvailable:
                defer {
                    getOneMoreBottleNotAvailable(.notTimeAvailable)
                }
                return
            case .notMoreBottlesAvailable:
                defer {
                    getOneMoreBottleNotAvailable(.notMoreBottlesAvailable)
                }
                return
            }
        }
        
        
        if rewardedAd == nil {
            createAndLoadRewardAd()
        } else {
            if !rewardedAd!.isReady {
                rewardedAd = nil
                createAndLoadRewardAd()
            }
        }
        
        
        if alertControllerCustom != nil {
            alertControllerCustom?.clouseAlert()
        }
        
        alertControllerCustom = AlertControllerCustom()
        var alertText = text
        if alertText == nil {
        let name = currentUser.name
        let greeting = AppTexts.firstGreetingWord + (name != nil ? ", " + name! + "!" : "!")
            let textGetOneMoreBottleOrGetPremium = AppTexts.textGetOneMoreBottleOrGetPremiumAppTexts
            
            alertText = greeting + textGetOneMoreBottleOrGetPremium
        }
        guard alertControllerCustom != nil else { return }
        alertControllerCustom!.createAlert(observer: self, alertIdentifire: .getOneMoreBottle, view: view, text: alertText ?? "", imageName: nil, firstButtonText: "cancelSmallBlue", secondButtonText: "watchAd", thirdButtonText: "unlimitedBottels", imageInButtons: true)
    
    }
    
    
    //push wath ad button action to present
    func watchAdButtonAction(alertCustom: AlertControllerCustom?) {
        guard alertCustom != nil else {
            return
        }
        alertCustom?.startAnimating(secondButton: true)
        
        if rewardedAd == nil {
            createAndLoadRewardAd(callFromAlert: true)
        } else {
            if !rewardedAd!.isReady {
                rewardedAd = nil
                createAndLoadRewardAd(callFromAlert: true)
            }
        }
    
        
            runIsAdReadyController()
        
    }
    
    
    // repeating check is ad ready controller function
    private func runIsAdReadyController() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            guard self.rewardedAd != nil else {
                
                self.getOneMoreBottleAdCustomAlertController(text: self.adErrorText)
                return
            }
            if self.rewardedAd?.isReady == true {
                self.alertControllerCustom?.stopAnimating(secondButton: true)
                self.presentRewardedAdToGetOneMoreBottle()
                self.alertControllerCustom?.clouseAlert()
            } else {
                self.runIsAdReadyController()
            }
        }
    }
    
    
    
    
    
    //create and load reward Ad if we need it
    func createAndLoadRewardAdIfNeeded() {
        if accessController != nil {
            if !accessController!.premiumAccount && needsTimesToLoadRewardedAd > 0 {
                createAndLoadRewardAd()
            }
        }
    }
    
    
    //create and load reward Ad
    func createAndLoadRewardAd(callFromAlert: Bool = false) {
        // if anouther method create and use rewardAd - return
        guard rewardedAd == nil else {
            return
        }
        rewardedAd = GADRewardedAd(adUnitID: rewardedAdId)
        rewardedAd?.load(GADRequest()) { error in
            if let _ = error {
                print("ERROR")
                // Handle ad failed to load case.
                self.rewardedAd = nil
                // try to load 3 times
                if self.adLoadCount > 0 {
                    self.adLoadCount -= 1
                    self.createAndLoadRewardAd(callFromAlert: callFromAlert)
                } else {
                    self.adLoadCount = 1
                    if callFromAlert {
                        DispatchQueue.main.async {
                            self.getOneMoreBottleAdCustomAlertController(text: self.adErrorText)
                        }
                    }
                }
            } else {
                // Ad successfully loaded.
                self.adLoadCount = 1
            }
        }
    }
    
    func presentRewardedAdToGetOneMoreBottle() {
        
        if rewardedAd?.isReady == true {
            rewardedAd?.present(fromRootViewController: self, delegate:self)
        }
    }
    
    //delegate methods
    
    // Tells the delegate that the user earned a reward.
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
      //get container VC
        guard let containerVC = self.parent as? ContainerViewController else {
            currentUser.currentVolumeInBottle = 1
            return
        }
        self.rewardedAd = nil
        //decreese times to load and load new Ad if needed
        needsTimesToLoadRewardedAd -= 1
        createAndLoadRewardAdIfNeeded()
        //change and save count of available bottles
        containerVC.accessController?.bottelsAvailable += 1
        containerVC.accessController?.lastWatchingRewardAdsTime = Date()
        containerVC.saveContextInLocalDataBase()
        bottomMenuCollectionView?.reloadData()
    }
    
    // Tells the delegate that the rewarded ad was presented.
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
     
    }
    // Tells the delegate that the rewarded ad was dismissed.
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        //if user dissmissed we load new Ad
        self.rewardedAd = nil
        createAndLoadRewardAd()
        let textAdDismissed = AppTexts.textAdDismissedAppTexts
        self.getOneMoreBottleAdCustomAlertController(text: textAdDismissed)
        
        //show alert user dissmissed Ad so try again
    }
    // Tells the delegate that the rewarded ad failed to present.
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        //if Ad failed to present we load new Ad
        self.rewardedAd = nil
        createAndLoadRewardAd()
      
        self.getOneMoreBottleAdCustomAlertController(text: adErrorText)
        
        // show alert with try again, take credit
    }
}
