//
//  MenuViewControllerGetOneMoreBottle.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 08.11.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit
import GoogleMobileAds

// get one more bottle
extension MenuViewController: GADRewardedAdDelegate {
    
    
    
    func getOneMoreBottleAdCustomAlertController() {
        
        if rewardedAd == nil {
            createAndLoadRewardAd(callFromAlert: true)
        } else {
            if !rewardedAd!.isReady {
                rewardedAd = nil
                createAndLoadRewardAd(callFromAlert: true)
            }
        }
        
        
        if alertControllerCustom != nil {
            alertControllerCustom?.clouseAlert()
        }
        
        alertControllerCustom = AlertControllerCustom()
        let name = currentUser.name ?? ""
        let textGetOneMoreBottleOrGetPremium = "Hi," + name + "! To get one more bottle You should watch Rewarded Ads or buy a premium account to get unlimited water!"
        guard alertControllerCustom != nil else { return }
        alertControllerCustom!.createAlert(observer: self, alertIdentifire: .getOneMoreBottle, view: view, text: textGetOneMoreBottleOrGetPremium, imageName: nil, firstButtonText: "cancelSmallBlue", secondButtonText: "watchAd", thirdButtonText: "unlimitedBottels", imageInButtons: true, isActivityIndicatorButtonSecond: true)
    }
//        var isReady = false
//
//        if rewardedAd != nil {
//            print("STOP ELSE0")
//            isReady = rewardedAd!.isReady
//            print("STOP ELSE1")
//            if isReady {
//                alertControllerCustom?.stopAnimating(secondButton: true)
//            } else {
//                print("STOP ELSE2")
//                    repeat {
//
//                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
//                            print("STOP ELSE4")
//
//                            if self.rewardedAd?.isReady == true {
//                                isReady = true
//                                DispatchQueue.main.async {
//                                    if self.alertControllerCustom == nil {
//                                        print("Alert is nil")
//                                    } else {
//                                        print("Alert is not nil")
//                                    }
//                                    self.alertControllerCustom?.stopAnimating(secondButton: true)
//                                }
//                            }
//                        }
//                            if self.rewardedAd == nil {
//                                let textLoadError = "Ad loading error! You can try one more time or buy a premium account to get unlimited water!"
//                                DispatchQueue.main.async {
//                                    self.tryAgainAdLoadCustomAlert(text: textLoadError)
//                                }
//                                break
//                            }
//
//                    } while isReady != true
//
//            }
//
//        }
//    }
    
    
    
    //alert when ad falled
    func tryAgainAdLoadCustomAlert(text: String) {
        
        if alertControllerCustom != nil {
            alertControllerCustom?.clouseAlert()
        }
        
        alertControllerCustom = AlertControllerCustom()
        let textTryAgain = text
        guard alertControllerCustom != nil else { return }
        alertControllerCustom!.createAlert(observer: self, alertIdentifire: .tryAgainLoadAd, view: view, text: textTryAgain, imageName: nil, firstButtonText: "cancelSmallBlue", secondButtonText: "repeat", thirdButtonText: "unlimitedBottels", imageInButtons: true)
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
                        let textLoadError = "Ad loading error! You can try one more time or buy a premium account to get unlimited water!"
                        DispatchQueue.main.async {
                            self.tryAgainAdLoadCustomAlert(text: textLoadError)
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
        containerVC.saveContextInLocalDataBase()
        bottomMenuCollectionView.reloadData()
    }
    // Tells the delegate that the rewarded ad was presented.
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
        print("Rewarded ad presented.")
    }
    // Tells the delegate that the rewarded ad was dismissed.
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        //if user dissmissed we load new Ad
        self.rewardedAd = nil
        createAndLoadRewardAd()
        //show alert user dissmissed Ad so try again
    }
    // Tells the delegate that the rewarded ad failed to present.
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        //if Ad failed to present we load new Ad
        self.rewardedAd = nil
        createAndLoadRewardAd()
        // show alert with try again, take credit
    }
}
