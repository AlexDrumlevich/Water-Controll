//
//  SettingsTableViewModel.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 25.05.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

enum SettingsViewControllerTableViewCellType: Int, CaseIterable {
    case name = 0, bottleSettings, notification, isAutoFillWater, deleteUser
    
    var cellHeightMultiplicator: CGFloat {
        switch self {
        case .name:
            return 0.12
        case .bottleSettings:
            return 0.2
        default:
            return 0.2
        }
    }
    
}
