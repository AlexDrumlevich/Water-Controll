//
//  ExtensionSettingsViewControllerShareAndRateTheApp.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 05.01.2021.
//  Copyright © 2021 ALEXEY DRUMLEVICH. All rights reserved.
//

import Foundation
import StoreKit
import Network

//rate app and share app

extension SettingsViewController {
    
    
    
    // rate if user wish it
    func rateAppByUserWish() {
        
        if !isInternetConnectionAvailable() {
            errorWithShareOrRateTheAppCustomAlert(isInternetConnectionAvalable: false)
            return
        }
        
        guard let productURL = shareAndRateAvailable() else {
            errorWithShareOrRateTheAppCustomAlert()
            return
        }
        
        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
        
        components?.queryItems = [
            URLQueryItem(name: "action", value: "write-review")
        ]
        
        guard let writeReviewURL = components?.url else {
            errorWithShareOrRateTheAppCustomAlert()
            return
        }
        
        UIApplication.shared.open(writeReviewURL)
        
    }
    
    //share app
    func shareAppWithFriends() {
        
        if !isInternetConnectionAvailable() {
            errorWithShareOrRateTheAppCustomAlert(isInternetConnectionAvalable: false)
            return
        }
        
        guard let productURL = shareAndRateAvailable() else {
            errorWithShareOrRateTheAppCustomAlert()
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [productURL], applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    
    func shareAndRateAvailable () -> URL? {
        return URL(string: productURLString)
    }
    
    
    //check internet connection
    private func isInternetConnectionAvailable() -> Bool {
        
        let monitor = NWPathMonitor()
        
        switch monitor.currentPath.status {
        case .satisfied:
            return true
        default:
            return false
        }
    }
    
    //alert controller custom
    private func errorWithShareOrRateTheAppCustomAlert(isInternetConnectionAvalable: Bool = true) {
        
        if alertControllerCustom != nil {
            alertControllerCustom?.clouseAlert()
        }
        
        alertControllerCustom = AlertControllerCustom()
        // let alertId = alertControllerCustom?.alertID
        let name = currentUser.name
        let firstGreetingWord = "Hi"
        
        let greetingText = firstGreetingWord + (name == nil ? "!" : ", " + name! + "!")
        
        var messageText = " We are sorry, this function unavailable."
        if !isInternetConnectionAvailable() {
            messageText = " No Internet connection!"
        }
        
        guard alertControllerCustom != nil else { return }
        
        alertControllerCustom!.createAlert(observer: self, alertIdentifire: .general, view: view, text: greetingText + messageText, imageName: nil, firstButtonText: "cancelSmallBlue", secondButtonText: nil, thirdButtonText: nil, imageInButtons: true)        
    }

}


