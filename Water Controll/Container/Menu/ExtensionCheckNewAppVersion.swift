//
//  ExtensionCheckNewAppVersion.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 08.01.2021.
//  Copyright © 2021 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

//check new app version

//struct : Codable {
//    var version: String?
//}
//

extension MenuViewController {
    
    func checkNewAppVersionAndNotifyUserAboutNewVersion() {
        
        
        // we have last version in store, current app version store (named in store), current app version  develop (named in xCode). if  CAVS and CAVD not equal so we had auto update and save new values else we notify user
        
        
        guard accessController != nil, let containerVC = self.parent as? ContainerViewController else { return }
        
        // get last version from app store
        fetchAppVersionInAppStore { (lastVersion) in
            guard let lastVersionInAppStore = lastVersion else {
                return
            }
            //get current version from the app
            
            guard let currentAppVersionDevelop = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
            
            // if we have nil in data base we save current versions
            guard var lastAppVersionInAppDataBase = self.accessController?.lastAppVerion,
                  var currentAppVersionStoreDataBase = self.accessController?.currrentAppVersionStore,
                  var currentAppVersionDevelopmentDataBase = self.accessController?.currentAppVersionDevelopment
            else {
                self.accessController?.lastAppVerion = lastVersionInAppStore
                self.accessController?.currrentAppVersionStore = lastVersionInAppStore
                self.accessController?.currentAppVersionDevelopment = currentAppVersionDevelop
                containerVC.saveContextInLocalDataBase()
                return
            }
            
            print(lastVersionInAppStore, lastAppVersionInAppDataBase)
            
            // if we have last version (if both not equal so we have updated version)
            if lastVersionInAppStore != currentAppVersionStoreDataBase && currentAppVersionDevelop != currentAppVersionDevelopmentDataBase {
                currentAppVersionDevelopmentDataBase = currentAppVersionDevelop
                currentAppVersionStoreDataBase = lastVersionInAppStore
                lastAppVersionInAppDataBase = lastVersionInAppStore
                containerVC.saveContextInLocalDataBase()
                return
            }  else if lastVersionInAppStore != currentAppVersionStoreDataBase && currentAppVersionDevelop == currentAppVersionDevelopmentDataBase {
                
                //develop
                // button - new version available
                
                if lastVersionInAppStore != lastAppVersionInAppDataBase {
                    lastAppVersionInAppDataBase = lastVersionInAppStore
                    containerVC.saveContextInLocalDataBase()
                    DispatchQueue.main.async {
                        self.userNotifaingAboutNewAppVersion()
                    }
                }
            }
        }
    }
    
    private func userNotifaingAboutNewAppVersion() {
        
        if alertControllerCustom != nil {
            alertControllerCustom?.clouseAlert()
        }
        
        alertControllerCustom = AlertControllerCustom()
        let textWeHaveNewAppVersion = AppTexts.textWeHaveNewAppVersionAppTexts
        guard alertControllerCustom != nil else { return }
        alertControllerCustom!.createAlert(observer: self, alertIdentifire: .newAppVersionIsReady, view: view, text: textWeHaveNewAppVersion, imageName: nil, firstButtonText: AppTexts.cancelAppTexts, secondButtonText: AppTexts.updateAppTexts, thirdButtonText: nil, imageInButtons: false)
        
    }
    
    
    func changeValueToUserWasNotifiedAboutNewVersion() {
        guard let containerVC = self.parent as? ContainerViewController, accessController != nil else {
            return
        }
        
        accessController?.userWasNotifiedAboutNewAppVersion = true
        containerVC.saveContextInLocalDataBase()
        
    }
    
    func openAppInAppStore() {
        
        guard let productURL = URL(string: productURLString) else {
            return
        }
        UIApplication.shared.open(productURL)
    }
    
    
    
    private func fetchAppVersionInAppStore(completion: @escaping (String?) -> Void) {
        
        guard let taskURL = URL(string: appURLInAppStoreToGetVersion) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: taskURL) { dataGot, _, _ in
            //get data
            guard let data = dataGot else {
                completion(nil)
                return
            }
            
            //                let decoder = JSONDecoder()
            //
            //                guard let results = try? decoder.decode(Results.self, from: data) else {
            //                    completion(nil)
            //                    return
            //                }
            
            
            
            
            
            guard let jsonDictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                completion(nil)
                return
            }
            print(jsonDictionary)
            
            
            guard let jsonDictionaryResults = jsonDictionary["results"] as? [[String: Any]] else {
                completion(nil)
                return
            }
            
            guard !jsonDictionaryResults.isEmpty else {
                completion(nil)
                return
            }
            
            
            guard let version = jsonDictionaryResults.first!["version"] as? String else {
                completion(nil)
                return
            }
            
            completion(version)
        }
        
        task.resume()
    }
    
}


