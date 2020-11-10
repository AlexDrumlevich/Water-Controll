//
//  BottomMenuModel.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 23.05.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit


enum BottomMenuModelIdentifire: String {
    case pourWaterIntoGlass, pourWaterIntoBottle, getOneMoreBottleInBottomMenu, notification, graph, settings, closeCustomAlerts
}


struct BottomMenuModel {
    var image: UIImage?
    let identifire: BottomMenuModelIdentifire
    
    static func fetchContent(isPremiumAccount: Bool) -> [BottomMenuModel] {
        let pourWaterIntoGlassItem = BottomMenuModel(image: UIImage(named: BottomMenuModelIdentifire.pourWaterIntoGlass.rawValue), identifire: .pourWaterIntoGlass)
        let pourWaterIntoBottleItem = BottomMenuModel(image: UIImage(named: BottomMenuModelIdentifire.pourWaterIntoBottle.rawValue), identifire: .pourWaterIntoBottle)
        let notificationItem = BottomMenuModel(image: UIImage(named: BottomMenuModelIdentifire.notification.rawValue), identifire: .notification)
        let graphItem = BottomMenuModel(image: UIImage(named: BottomMenuModelIdentifire.graph.rawValue), identifire: .graph)
        let settingsItem = BottomMenuModel(image: UIImage(named: BottomMenuModelIdentifire.settings.rawValue), identifire: .settings)
        let getOneMoreBottle = BottomMenuModel(image: UIImage(named: BottomMenuModelIdentifire.getOneMoreBottleInBottomMenu.rawValue), identifire: .getOneMoreBottleInBottomMenu)
        
        var content = [pourWaterIntoGlassItem, pourWaterIntoBottleItem, notificationItem, graphItem, settingsItem]
        //if we dont`t have premium we add get one more bottle
        if !isPremiumAccount {
            content.insert(getOneMoreBottle, at: 2)
        }
        
        return content
    }
}
