//
//  SiriIntentionSupporting.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 23.04.2021.
//  Copyright © 2021 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit
import Intents

class SiriIntentionSupporting {
    

    // Create an intent for drink water
    public func donateDrinkWaterIntent() {
        let intent = DrinkWaterIntent()
        intent
        intent.article = INObject(
            INObject(identifier: self.title, display: self.title)
        intent.publishDate = formattedDate()
        
        let interaction = INInteraction(intent: intent, response: nil)
        
        interaction.donate { error in
            if let error = error {
                print("Donating intent failed with error \(error)")
            }
        }
    }
}
