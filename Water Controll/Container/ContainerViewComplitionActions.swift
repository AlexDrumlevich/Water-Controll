//
//  ContainerViewComplitionActions.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 04.06.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import Foundation

enum ContainerViewComplitionActions {
    //close settings view controller from settings view controller (back button)
    case closeSettingsViewContainer
    
    case saveContextInLocalDataBase
    
    case addNewUser
    
    case changeUserNext
    
    case changeUserPrevious

    case deleteUser
    
    case setupNotificationsTime(Notificaton, NotificationsStructure, Bool)
    
    case updateMenuViewController
    
    case showDeniedNotificationCustomAlert(Bool)
    
}
