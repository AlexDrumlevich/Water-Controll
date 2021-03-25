//
//  ContainerViewControllerGetAdConsent.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 14.11.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit
import PersonalizedAdConsent
import UserMessagingPlatform
import AppTrackingTransparency
import AdSupport
import GoogleMobileAds
//fo testing
import AdSupport


//get Ad Consent
extension ContainerViewController {
    
    
    /*
     //get Ad consent using UMP framework
     // Request an update to the consent information.
     func getAdUMPConsent() {
     DispatchQueue.main.async {
     
     
     // create object - UMPRequestParameters.
     let parameters = UMPRequestParameters()
     parameters.tagForUnderAgeOfConsent = false
     UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: parameters, completionHandler: { [self] (error) in
     if error != nil {
     //handle error
     } else {
     // we have information of consent
     // You are now ready to see if a form is available
     let formStatus = UMPConsentInformation.sharedInstance.formStatus
     if formStatus == .available {
     loadUMPForm()
     } else if formStatus == .unavailable {
     //alert custom
     
     } else if formStatus == .unknown {
     if canRepeatRequestUMPConsent {
     canRepeatRequestUMPConsent = false
     getAdUMPConsent()
     return
     } else {
     //alert custom
     }
     }
     }
     })
     }
     
     }
     
     func loadUMPForm() {
     DispatchQueue.main.async {
     //load form
     UMPConsentForm.load(completionHandler: { form, loadError in
     if loadError != nil {
     // Handle the error
     
     } else {
     // Present the form
     // Present the form. You can also hold on to the reference to present
     // later.
     // if we have required consent status
     if UMPConsentInformation.sharedInstance.consentStatus == .required {
     form?.present(from: self,
     completionHandler: { dismissError in
     if UMPConsentInformation.sharedInstance.consentStatus == .obtained {
     // App can start requesting ads.
     }
     
     })
     } else {
     // Keep the form available for changes to user consent.
     }
     }
     })
     }
     
     }
     
     
     */
    
    

    func startGoogleAds() {
        if !isGoogleAdsStarted{
            GADMobileAds.sharedInstance().start(completionHandler: nil)
            isGoogleAdsStarted = true
        }
    }
    
    
    // request IDFA
    func prepareToRequestIDFA() {
        DispatchQueue.main.async {
            if #available(iOS 14, *) {
                
                
                switch ATTrackingManager.trackingAuthorizationStatus {
                case .authorized:
                    print("authorized")
                    self.saveGotConsentAndChangeStatus(with: self.saveText, callFromGetOneMoreBottle: self.callSaveFunctionFromGetOneMoreBottle, needToSaveInDataBase: self.needToSaveConsentInDataBase)
                case .restricted:
                    print("restricted")
                    self.saveGotConsentAndChangeStatus(with: self.saveText, callFromGetOneMoreBottle: self.callSaveFunctionFromGetOneMoreBottle, needToSaveInDataBase: self.needToSaveConsentInDataBase)
                case .denied:
                    print("denied")
                    self.requestIDFAWasDeniedCustomAlert()
                case . notDetermined:
                    self.requestIDFAWillShowCustomAlert()
                    
                default:
                    break
                }
                
                
            } else {
                // Fallback on earlier versions
                self.saveGotConsentAndChangeStatus(with: self.saveText, callFromGetOneMoreBottle: self.callSaveFunctionFromGetOneMoreBottle, needToSaveInDataBase: self.needToSaveConsentInDataBase)
                
            }
        }
    }
    
    //show request IDFA
    func showRequestIDFA() {
        if #available(iOS 14, *) {
            DispatchQueue.main.async {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    // Tracking authorization completed. Start loading ads here.
                    // loadAd()
                    switch status {
                    
                    case .authorized:
                        self.saveGotConsentAndChangeStatus(with: self.saveText, callFromGetOneMoreBottle: self.callSaveFunctionFromGetOneMoreBottle, needToSaveInDataBase: self.needToSaveConsentInDataBase)
                        
                    case .denied:
                        self.requestIDFAWasDeniedCustomAlert()
                        
                    case .notDetermined:
                        break
                        
                    case .restricted:
                        self.saveGotConsentAndChangeStatus(with: self.saveText, callFromGetOneMoreBottle: self.callSaveFunctionFromGetOneMoreBottle, needToSaveInDataBase: self.needToSaveConsentInDataBase)
                        
                    default:
                        break
                        
                    }
                })
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    
    
    
    //get consent if needed
    func getAdConsent(callFromGetOneMoreBottle: Bool, changeAdConsent: Bool = false) {
        self.callSaveFunctionFromGetOneMoreBottle = callFromGetOneMoreBottle
        
        //for testing
        //test
        // Geography appears as in EEA for debug devices.
        
        
      PACConsentInformation.sharedInstance.debugGeography = .EEA
        
        
        // Geography appears as not in EEA for debug devices.
        //  PACConsentInformation.sharedInstance.debugGeography = PACDebugGeographyNotEEA;
        
        
        
        
        PACConsentInformation.sharedInstance.requestConsentInfoUpdate(
            forPublisherIdentifiers: publisherIdentifiers)
        {(_ error: Error?) -> Void in
            if let error = error {
                // Consent info update failed.
                DispatchQueue.main.async {
                    print(error)
                    
                    self.tryGetAdConsentOneMoreTimeOrByPremiumAlertController()
                    
                }
                
            } else {
                
                // Consent info update succeeded. The shared PACConsentInformation
                // instance has been updated.
                
                //check where is user (europian zone or not)
                switch PACConsentInformation.sharedInstance.isRequestLocationInEEAOrUnknown {
                
                //we are in europian zone
                case true:
                    //consent status
                    switch PACConsentInformation.sharedInstance.consentStatus {
                    case .nonPersonalized, .personalized:
                        
                        //start ads
                        self.startGoogleAds()
                        
                        if changeAdConsent {
                            
                            self.createGetConsentForm(callFromGetOneMoreBottle: callFromGetOneMoreBottle)
                        } else {
                            //save properties for save consent
                            self.saveText = ""
                            self.callSaveFunctionFromGetOneMoreBottle = callFromGetOneMoreBottle
                            self.needToSaveConsentInDataBase = false
                            //prepare for request IDFA if needed pr save
                            if PACConsentInformation.sharedInstance.consentStatus == .nonPersonalized {
                                self.saveGotConsentAndChangeStatus(with: self.saveText, callFromGetOneMoreBottle: self.callSaveFunctionFromGetOneMoreBottle, needToSaveInDataBase: self.needToSaveConsentInDataBase)
                            } else {
                                self.prepareToRequestIDFA()
                            }
                        }
                        
                    case .unknown:
                        if let isAdConsentWasGotten = self.accessController?.isGotConsent {
                            if !isAdConsentWasGotten {
                                DispatchQueue.main.async {
                                    self .getBeforeAdsConsentForEuropeanZoneAlertController(callFromGetOneMoreBottle: callFromGetOneMoreBottle)
                                }
                            } else {
                                //create get consent form
                                self.createGetConsentForm(callFromGetOneMoreBottle: callFromGetOneMoreBottle)
                                
                            }
                        } else {
                            //create get consent form
                            self.createGetConsentForm(callFromGetOneMoreBottle: callFromGetOneMoreBottle)
                        }
                        
                    default:
                        
                        break
                        
                    }
                    
                // we aren`t in european zone
                case false:
                    
                    if let isAdConsentWasGotten = self.accessController?.isGotConsent {
                        if isAdConsentWasGotten {
                            //start ads
                            self.startGoogleAds()
                            
                            if changeAdConsent {
                                DispatchQueue.main.async {
                                    self.getAdsConsentForNotEuropeanZoneAlertController(callFromGetOneMoreBottle: callFromGetOneMoreBottle, changeConsent: true)
                                }
                            } else {
                                //save properties for save consent
                                self.saveText = ""
                                self.callSaveFunctionFromGetOneMoreBottle = callFromGetOneMoreBottle
                                self.needToSaveConsentInDataBase = false
                                //prepare for request IDFA
                                self.prepareToRequestIDFA()
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.getAdsConsentForNotEuropeanZoneAlertController(callFromGetOneMoreBottle: callFromGetOneMoreBottle)
                            }
                            
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.getAdsConsentForNotEuropeanZoneAlertController(callFromGetOneMoreBottle: callFromGetOneMoreBottle)
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
    // create Ad consent form
    func createGetConsentForm(callFromGetOneMoreBottle: Bool) {
        activityIndicatorStartAnimating()
        //create form
        guard let privacyUrl = URL(string: privacyUrl),
              let form = PACConsentForm(applicationPrivacyPolicyURL: privacyUrl) else {
            print("incorrect privacy URL.")
            activityIndicatorStopAnimating()
            self.tryGetAdConsentOneMoreTimeOrByPremiumAlertController()
            return
        }
        // house form elements
        form.shouldOfferPersonalizedAds = true
        form.shouldOfferNonPersonalizedAds = true
        form.shouldOfferAdFree = true
        
        // load form
        form.load {(_ error: Error?) -> Void in
            print("Load complete.")
            if let error = error {
                // Handle error.
                print("Error loading form: \(error.localizedDescription)")
                self.activityIndicatorStopAnimating()
                self.incorrectURLAlertController()
                
            } else {
                // Load successful.
                //present form
                
                form.present(from: self) { (error, userPrefersAdFree) in
                    self.activityIndicatorStopAnimating()
                    
                    if let _ = error {
                        
                        // Handle error.
                        //try again
                        DispatchQueue.main.async {
                            self.tryGetAdConsentOneMoreTimeOrByPremiumAlertController()
                        }
                        
                    } else if userPrefersAdFree {
                        // User prefers to use a paid version of the app.
                        // get premium
                        self.sratrPurchasing()
                       // self.becamePremiumAccaunt()
                    } else {
                        //start ads
                        self.startGoogleAds()
                        // Check the user's consent choice.
                        let status =
                            PACConsentInformation.sharedInstance.consentStatus
                        
                        PACConsentInformation.sharedInstance.consentStatus = status
                        
                        let textToSaveConsent = "consent to ADS was gotten"
                        
                        
                        //save ad consent
                        self.saveText = textToSaveConsent
                        self.callSaveFunctionFromGetOneMoreBottle = callFromGetOneMoreBottle
                        self.needToSaveConsentInDataBase = true
                        
                        if status == .nonPersonalized {
                            self.saveGotConsentAndChangeStatus(with: self.saveText, callFromGetOneMoreBottle: self.callSaveFunctionFromGetOneMoreBottle, needToSaveInDataBase: self.needToSaveConsentInDataBase)
                        } else {
                            self.prepareToRequestIDFA()
                        }
                        
                    }
                }
            }
        }
    }
    
    
    // get conset alert controller not for European zone
    func getAdsConsentForNotEuropeanZoneAlertController(callFromGetOneMoreBottle: Bool, changeConsent: Bool = false) {
        
            if self.alertControllerCustom != nil {
                self.alertControllerCustom?.clouseAlert()
                self.removeViewBehindAlertAnderBanner()
            }
        DispatchQueue.main.async {
            self.alertControllerCustom = AlertControllerCustom()
            
            
            let alertGetAdsConsentForNotEuropeanZoneText = AppTexts.alertGetAdsConsentForNotEuropeanZoneTextAppTexts
            
            let changeConsentText =  AppTexts.changeConsentTextAppTexts
            
            
            
            self.saveText = "consent was gotten to use data and device identifire to show ads"
            self.callSaveFunctionFromGetOneMoreBottle = callFromGetOneMoreBottle
            self.needToSaveConsentInDataBase = true
            
            guard self.alertControllerCustom != nil else { return }
            self.alertControllerCustom!.createAlert(observer: self, alertIdentifire: .getAdConsentNotForEEA, view: self.createViewBehindAlertAnderBanner(), text: changeConsent ? changeConsentText : alertGetAdsConsentForNotEuropeanZoneText, imageName: nil, firstButtonText: "Cancel", secondButtonText: "Ads", thirdButtonText: "Ad-free", imageInButtons: false)
            
        }
        
        
    }
    
    // get conset alert controller not for European zone
    func getBeforeAdsConsentForEuropeanZoneAlertController(callFromGetOneMoreBottle: Bool) {
       
            if self.alertControllerCustom != nil {
                self.alertControllerCustom?.clouseAlert()
                self.removeViewBehindAlertAnderBanner()
            }
            
        DispatchQueue.main.async {
            self.alertControllerCustom = AlertControllerCustom()
            
            
            let alertText = AppTexts.alertBeforeGetAdsConsentForEuropeanZoneTextAppTexts
            
            self.saveText = "user was notificated about no age restrictions in Ads"
            self.callSaveFunctionFromGetOneMoreBottle = callFromGetOneMoreBottle
            self.needToSaveConsentInDataBase = true
            
            guard self.alertControllerCustom != nil else { return }
            self.alertControllerCustom!.createAlert(observer: self, alertIdentifire: .getAdFirstConsentForEEA, view: self.createViewBehindAlertAnderBanner(), text: alertText, imageName: nil, firstButtonText: "Cancel", secondButtonText: "Ads", thirdButtonText: "Ad-free", imageInButtons: false)
            
        }
        
        
    }
    
    //    We keep this app free by showing ads.Tap 'Allow tracking' on the next screen to give permission to show ads that are more relevant to you.
    //
    
    // request IDFA will show
    func requestIDFAWillShowCustomAlert() {
        
            if alertControllerCustom != nil {
                alertControllerCustom?.clouseAlert()
                removeViewBehindAlertAnderBanner()
            }
        DispatchQueue.main.async {
            self.alertControllerCustom = AlertControllerCustom()
            
            
            
            let alertRequestIDFAWillShow = AppTexts.alertRequestIDFAWillShowAppTexts
            
            guard self.alertControllerCustom != nil else { return }
            self.alertControllerCustom!.createAlert(observer: self, alertIdentifire: .requestIDFAWillShow, view: self.createViewBehindAlertAnderBanner(), text: alertRequestIDFAWillShow, imageName: nil, firstButtonText: "Ok", secondButtonText: "Ad-free", thirdButtonText: nil, imageInButtons: false)
            
        }
        
    }
    
    // request IDFA was denied
    func requestIDFAWasDeniedCustomAlert(isProblemsWithOpenningPhoneSettings: Bool = false) {
       
            if alertControllerCustom != nil {
                alertControllerCustom?.clouseAlert()
                removeViewBehindAlertAnderBanner()
            }
        DispatchQueue.main.async {
            self.alertControllerCustom = AlertControllerCustom()
            
            
            let alertRequestIDFAWasDenied = AppTexts.alertRequestIDFAWasDeniedAppTexts
            
            
            let alertTextIDFADeniedProblemsWithOpenSettings = AppTexts.alertProblemsWithOpenSettingsAppTexts
            
            guard self.alertControllerCustom != nil else { return }
            self.alertControllerCustom!.createAlert(observer: self, alertIdentifire: .requestIDFAWasDenied, view: self.createViewBehindAlertAnderBanner(), text: isProblemsWithOpenningPhoneSettings ? alertTextIDFADeniedProblemsWithOpenSettings : alertRequestIDFAWasDenied, imageName: nil, firstButtonText: "Cancel", secondButtonText: "Settings", thirdButtonText: isProblemsWithOpenningPhoneSettings ? nil : "Ad-free", imageInButtons: false)
            
        }
        
    }
    
    
    //problem with free by ads app
    func tryGetAdConsentOneMoreTimeOrByPremiumAlertController() {
        
        DispatchQueue.main.async { [self] in
            if self.alertControllerCustom != nil {
                self.alertControllerCustom?.clouseAlert()
            }
            
            self.alertControllerCustom = AlertControllerCustom()
            
            let alertTryGetAdConsentOneMoreTimeOrByPremiumAlertControllerText = AppTexts.alertTryGetAdConsentOneMoreTimeOrByPremiumAlertControllerTextAppTexts
            
            guard self.alertControllerCustom != nil else { return }
            alertControllerCustom!.createAlert(observer: self, alertIdentifire: .tryGetAdConsentOneMoreTime, view: createViewBehindAlertAnderBanner(), text: alertTryGetAdConsentOneMoreTimeOrByPremiumAlertControllerText, imageName: nil, firstButtonText: "Cancel", secondButtonText: "Try again", thirdButtonText: "Ad-free", imageInButtons: false)
        }
        
    }
    
    func incorrectURLAlertController() {
        
        
            if alertControllerCustom != nil {
                alertControllerCustom?.clouseAlert()
                removeViewBehindAlertAnderBanner()
            }
        DispatchQueue.main.async {
            self.alertControllerCustom = AlertControllerCustom()
            
            let alertTryGetAdConsentOneMoreTimeOrByPremiumAlertControllerText = AppTexts.alertTryGetAdConsentOneMoreTimeOrByPremiumAlertControllerCantLoadAdTextAppTexts
            
            guard self.alertControllerCustom != nil else { return }
            self.alertControllerCustom!.createAlert(observer: self, alertIdentifire: .incorrectURL, view: self.createViewBehindAlertAnderBanner(), text: alertTryGetAdConsentOneMoreTimeOrByPremiumAlertControllerText, imageName: nil, firstButtonText: "Cancel", secondButtonText: "Ad-free", thirdButtonText: nil, imageInButtons: false)
        }
        
    }
    
    
    func saveGotConsentAndChangeStatus(with text: String = "", callFromGetOneMoreBottle: Bool = false, needToSaveInDataBase: Bool, needToSetTrueisAdsConsent: Bool = true) {
        if needToSaveInDataBase {
            self.addAdConsentToDataBase(date: Date(), text: text)
            self.accessController?.isGotConsent = true
            self.saveContextInLocalDataBase()
        }
        
        //we get consent , so set flag is consent to true
        if self.isAdsConsent == false {
            if callFromGetOneMoreBottle {
                self.isNeedToShowGetOneMoreBottleAlertController = true
            }
            if needToSetTrueisAdsConsent {
                self.isAdsConsent = true
            }
        }
    }
    
    //to alert be under banner
    func createViewBehindAlertAnderBanner(becamePremium: Bool = false) -> UIView {
        guard bannerView != nil  else {
            return view
        }
        viewBehindAlertAnderBanner = UIView()
        viewBehindAlertAnderBanner?.backgroundColor = .clear
        view.addSubview(viewBehindAlertAnderBanner!)
        viewBehindAlertAnderBanner?.translatesAutoresizingMaskIntoConstraints = false
        if becamePremium {
            viewBehindAlertAnderBanner?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        } else {
            viewBehindAlertAnderBanner?.topAnchor.constraint(equalTo: bannerView.bottomAnchor).isActive = true
        }
       
        
        viewBehindAlertAnderBanner?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        viewBehindAlertAnderBanner?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        viewBehindAlertAnderBanner?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        guard bannerView != nil  else {
            return view
        }
        return viewBehindAlertAnderBanner!
    }
    
    func removeViewBehindAlertAnderBanner() {
        guard viewBehindAlertAnderBanner != nil else {
            return
        }
        DispatchQueue.main.async {
            self.viewBehindAlertAnderBanner?.removeFromSuperview()
            self.viewBehindAlertAnderBanner = nil
        }
        
    }
    
}
