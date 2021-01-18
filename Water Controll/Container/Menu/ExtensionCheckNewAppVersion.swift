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
        
        guard let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, accessController != nil, let containerVC = self.parent as? ContainerViewController else {
            return
        }
        
        // get last version from app store
        fetchAppVersionInAppStore { (lastVersion) in
            guard let lastVersionInAppStore = lastVersion else {
                return
            }
            
            // if we have last version
            if lastVersionInAppStore == currentAppVersion {
                if self.accessController!.userWasNotifiedAboutNewAppVersion {
                    self.accessController?.userWasNotifiedAboutNewAppVersion = false
                    containerVC.saveContextInLocalDataBase()
                }
                return
                
                // we don`t have last version
            } else {
                if self.accessController!.userWasNotifiedAboutNewAppVersion {
                    return
                } else {
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
        alertControllerCustom!.createAlert(observer: self, alertIdentifire: .newAppVersionIsReady, view: view, text: textWeHaveNewAppVersion, imageName: nil, firstButtonText: "cance", secondButtonText: "update", thirdButtonText: nil, imageInButtons: false)
        
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


