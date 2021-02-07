//
//  AppTexts.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 09.01.2021.
//  Copyright © 2021 ALEXEY DRUMLEVICH. All rights reserved.
//

import Foundation

struct  AppTexts {
    
    static let firstGreetingWord = NSLocalizedString("Hi", comment: "first greeting word")
    
    static let firstTypeTextNotificationBody = NSLocalizedString("It`s time to drink pure water!", comment: "notification text")
   
    static let secondTypeTextNotificationBody = NSLocalizedString("It`s time to drink ... of course water!", comment: "notification text")
    
    static let thirdTypeTextNotificationBody = NSLocalizedString("It`s time to drink some water!", comment: "notification text")
    
    static let alertTryGetAdConsentOneMoreTimeOrByPremiumAlertControllerCantLoadAdTextAppTexts = NSLocalizedString("\tWe are sorry, but we have a problem downloading the app to use it for free by viewing ads.\n\t\"Cancel\" - app will continue downloading, but you won`t be able to get more bottles with water.\n\t\"Ad-free\" - you can paiy for ad-free version.", comment: "alertTryGetAdConsentOneMoreTimeOrByPremiumAlertControllerText")
    
    static let alertGetAdsConsentForNotEuropeanZoneTextAppTexts = NSLocalizedString("\tWelcome! We keep this app free by showing ads. We care about your privacy and data security.\n\t\"Ads\" - your agree that our partners will collect data and use a unique identifier on your device to show you ads. Advertising may have age restrictions. By selecting \"Ads\" you confirm that you have reached the age of majority, otherwise you should use the \"Ad-free\" version.\n\t\"Ad-free\" - ad-free version.\n\t\"Cancel\" - app will continue downloading, but you won`t be able to get more bottles with water.", comment: "alertGetAdsConsentForNotEuropeanZoneText")
    
    static let alertBeforeGetAdsConsentForEuropeanZoneTextAppTexts = NSLocalizedString("\tWelcome! We keep this app free by showing ads. Advertising may have age restrictions. By selecting \"Ads\" version you confirm that you have reached the age of majority, otherwise you should use the \"Ad-free\" version.", comment: "alertBeforeGetAdsConsentForEuropeanZoneTextAppTexts")
    
    static let changeConsentTextAppTexts =  NSLocalizedString("\tWe keep this app free by showing ads. We care about your privacy and data security.\n\t\"Ads\" - your agree that our partners will collect data and use a unique identifier on your device to show you ads.\n\t\"Ad-free\" - ad-free version.", comment: "changeConsentText")
    
    static let alertRequestIDFAWillShowAppTexts = NSLocalizedString("\tWe keep this app free by showing ads. Tap 'Allow tracking' on the next screen to give permission to use your device identifiers, such as the device’s advertising identifier, to display ads in the app. You can also pay for ad-free version.", comment: "alertRequestIDFAWillShow")
    
    static let alertRequestIDFAWasDeniedAppTexts = NSLocalizedString("\nWe keep this app free by showing ads. We use your device identifiers, such as the device’s advertising identifier, to display ads in the app. You denied access to these data. You can 'Allow tracking' in the phone`s settings or pay for ad-free version.", comment: "alertRequestIDFAWasDenied")
    
    
    static let alertProblemsWithOpenSettingsAppTexts = NSLocalizedString("\tSorry! We have a problem openning the app notification settings. You can try to do this manually in your phone settings.", comment: "alertProblemsWithOpenSettingsAppTexts")
    
    static let alertTryGetAdConsentOneMoreTimeOrByPremiumAlertControllerTextAppTexts = NSLocalizedString("\tWe are sorry, but we have a problem downloading the app to use it for free by viewing ads. It can be problems with the Interet connection.\n\t\"Cancel\" - app will continue downloading, but you won`t be able to get more bottles with water.\n\t\"Try again\" - try to load app to use it free by showing ads.\n\t\"Ad-free\" - you can paid for ad-free version.", comment: "alertTryGetAdConsentOneMoreTimeOrByPremiumAlertControllerText")
    
    static let adErrorTextAppTexts = NSLocalizedString("Ad loading error! You can try one more time or buy a premium account to get unlimited water!", comment: "textLoadError")
    
    static let alertTextNotificationDeniedAppTexts = NSLocalizedString("\tWe use notifications to remind you to drink water. But you refused to notify the app. You can enable notifications in your phone settings.", comment: "alertTextNotificationDenied")
    
    
    static let textGetOneMoreBottleOrGetPremiumAppTexts = NSLocalizedString(" To get one more bottle, you should watch Rewarded Ads or buy a premium account to get unlimited water!", comment: "textGetOneMoreBottleOrGetPremium")
    
    static let youHaveMaximumFullBottlesAppTexts = NSLocalizedString(" You have maximum full bottles:", comment: "youHaveMaximumFullBottlesAppTexts")
    
    static let adToGetOneMoreBottleWillBeAvailableInAppTexts = NSLocalizedString(" Ad to get one more bottle will be available in: ", comment: "adToGetOneMoreBottleWillBeAvailableInAppTexts")
    
    static let adsToGetOneMoreBottleNotAvailableAppTexts = NSLocalizedString(" We are sorry, Ads to get one more bottle are not available now, please try later.", comment: "adsToGetOneMoreBottleNotAvailableAppTexts")
    
    static let meAppTexts = NSLocalizedString("me", comment: "me(Do you really want to delete me)")
    
    static let doYouReallyWantToDeleteMeAppTexts = NSLocalizedString("Do you really want to delete ", comment: "doYouReallyWantToDeleteMeAppTexts")
    
    static let functionUnavailableAppTexts  = NSLocalizedString(" We are sorry, this function is unavailable.", comment: "functionUnavailableAppTexts")
    
    static let alertTextChouseVolumeType = NSLocalizedString("\tPlease select the units system: \"Liter\" or \"Oz\"", comment: "alertTextChouseVolumeType")
    
    static let doctorConsultationText = NSLocalizedString("\tCaution!\n\tThe app only controls the amount of water you drink based on daily quantity you choose. To choose daily quantity, you should consult your doctor.", comment: "doctorConsultationText")
    
    static let addUserAppTexts = NSLocalizedString("Add user", comment: "Add user button")
    
    static let textWeHaveNewAppVersionAppTexts = NSLocalizedString("Hi! A new version of the app is waiting for you!", comment: "textWeHaveNewAppVersion")
    
    static let textNoAvailableBottlesWithWater = NSLocalizedString("No available bottles with water", comment: "textNoAvailableBottlesWithWater")
    
    static let textFillTheIsNotEmptyBottle = NSLocalizedString("Your bottle is not empty. Do you still want to fill it?", comment: "textFillTheIsNotEmptyBottle")
    
    static let textNoWaterInTheBottleAppTexts = NSLocalizedString("There is no water in the bottle. You should fill the bottle!", comment: "textNoWaterInTheBottle")
    
    static let doYouReallyWantToDeleteTheFirstAppTexts = NSLocalizedString("Do you really want to delete the first ", comment: "Do you really want to delete the first")
    
    static let ofWaterConsumptionAppTexts = NSLocalizedString(" of water consumption?", comment: " of water consumption?")
    
    static let textAdDismissedAppTexts = NSLocalizedString("Ad was dismissed! You can try one more time or buy a premium account to get unlimited water!", comment: "textAdDismissed")
    
    static let dayAppTexts = NSLocalizedString(" day", comment: "day (день)")
    
    static let daysAppTexts = NSLocalizedString(" days", comment: "days (дня(ей))")
    
    static let mlAppTexts = NSLocalizedString("ml", comment: "mililitre (shortly)")

    static let literAppTexts = NSLocalizedString(" liter", comment: "ex. progress 0.5 out of 1 liter")
    static let litersAppTexts = NSLocalizedString(" liters", comment: "ex. progress 1  out of 2 liters")
    
    static let progressAppTexts = NSLocalizedString(" Progress", comment: "progress")
    
    static let outOffAppTexts = NSLocalizedString("out of", comment: "ex. progress 10 liters of 20 liters")
    
    static let changeNameAppTexts = NSLocalizedString("Change name", comment: "Change user name")
    
    static let restorePurchasesAppTexts = NSLocalizedString("Restore purchases", comment: "Restore purchases")
    
    static let rateTheAppAppTexts = NSLocalizedString("Rate the app", comment: "Rate the app")
    
    static let shareTheAppAppTexts = NSLocalizedString("Share the app", comment: "Share the app")
  
    static let literShortlyAppTexts = NSLocalizedString(" L", comment: "L - liter shortly")
     
    static let notificationsAppTexts = NSLocalizedString("notifications", comment: "Notifications")
    
    static let autoAppTexts = NSLocalizedString("auto", comment: "Auto - type of working")
    
    static let manuallyAppTexts = NSLocalizedString("manually", comment: "manually - type of working")
    
    static let deleteUserAppTexts = NSLocalizedString("delete user", comment: "delete user")
    
    static let commonAppTexts = NSLocalizedString("Common", comment: "common settings")
    
    static let specialAppTexts = NSLocalizedString("Special", comment: "special settings")
    
    static let timesADayAppTexts = NSLocalizedString("times a day:", comment: "times a day:")
    
    static let mondayAppTexts = NSLocalizedString("Monday", comment: "Monday")
    
    static let tuesdayAppTexts = NSLocalizedString("Tuesday", comment: "Tuesday")
    
    static let wednesdayAppTexts = NSLocalizedString("Wednesday", comment: "Wednesday")
    
    static let thursdayAppTexts = NSLocalizedString("Thursday", comment: "Thursday")
    
    static let fridayAppTexts = NSLocalizedString("Friday", comment: "Friday")
    
    static let saturdayAppTexts = NSLocalizedString("Saturday", comment: "Saturday")
  
    static let sundayAppTexts = NSLocalizedString("Sunday", comment: "Sunday")

    static let nameAppTexts = NSLocalizedString("Name", comment: "Name")
    
    static let cancelAppTexts = NSLocalizedString("Cancel", comment: "Cancel")
    
    static let buyAppTexts = NSLocalizedString("Buy", comment: "Buy")

    static let offerPremiumVersionAppTexts = NSLocalizedString("\tHi! \n\tDo you want to buy app version with out ad and with unlimited water bottles!? /n/t/The prise: ", comment: "offer premium version")
    
    static let loadingAppTexts = NSLocalizedString("\tLoading...", comment: "loading")
    
    static let errorAppTexts = NSLocalizedString("\tSorry! An error occurred. Please, try again later.", comment: "error")
    
    static let congratulationsGetVIPVersionAppTexts = NSLocalizedString("\tCongratulations! \n\tNow you have an ad-free version of the app with unlimited water bottles!", comment: "Congratulations Get VIP Version")
    
    static let laterAppTexts = NSLocalizedString("later", comment: "later")
    static let fiveMinutesLaterAppTexts = NSLocalizedString("5 minutes later", comment: "5 minutes later")
    static let tenMinutesLaterAppTexts = NSLocalizedString("10 minutes later", comment: "10 minutes later")
    static let fifteenMinutesLaterAppTexts = NSLocalizedString("15 minutes later", comment: "15 minutes later")
    static let dissmisAppTexts = NSLocalizedString("dissmis", comment: "dissmis")
 
}
