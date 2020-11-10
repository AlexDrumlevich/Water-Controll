//
//  Notifications.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 21.06.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit
import UserNotifications


class Notifications: NSObject, UNUserNotificationCenterDelegate {
    
    
    
    //notification center
    let notificationCenter = UNUserNotificationCenter.current()
    
    // get information about availability of sending notifications
    func getNotificationSettings(status: @escaping (UNAuthorizationStatus) -> Void) {
        notificationCenter.getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            status(settings.authorizationStatus)
        }
    }
    
    
    //request autorization
    func requestAutorization(result: @escaping (Bool) -> Void) {
        
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            //.providesAppNotificationSettings
            print("Permission granted: \(granted)")
            
            if granted == true {
                result(true)
            } else {
                result(false)
            }
        }
    }
    
    
    // schedule notification
    func createScheduleNotification(title: String, body: String, categoryIdentifier: String, threadIdentifier: String, weekDay: Int, hour: Int, minute: Int, isLast: Bool, complitionAction: @escaping() -> Void) {
        
        //content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        content.categoryIdentifier = categoryIdentifier
        
        //доавляем картинку в уведомление - это картинка должна быть на устройстве
        //коментируем т будем через расширение добавлять картинку
        /*
         guard let path = Bundle.main.path(forResource: "favicon", ofType: "png") else{return}
         let url = URL(fileURLWithPath: path)
         
         do {
         let attachement = try UNNotificationAttachment(identifier: "favicon", url: url, options: nil)
         content.attachments = [attachement]
         } catch {
         print("Attachment cold not be loaded")
         }
         */
        
        content.threadIdentifier = threadIdentifier
        
        
        //trigger
        var dateComponents = DateComponents()
        dateComponents.calendar = .current
        dateComponents.weekday = weekDay
        dateComponents.hour = hour
        dateComponents.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        //identifire
        let identifire = UUID().uuidString
        
        //request for notification center
        let request = UNNotificationRequest(identifier: identifire,
                                            content: content,
                                            trigger: trigger)
        
        //add request  to notification center
        notificationCenter.add(request) { (error) in
            print(" notificatin with weekday: \(weekDay), hour: \(hour), minute: \(minute), identifire: \(identifire), name: \(title) added")
            if isLast {
                //we call this complition in func  when we add last notification
                self.notificationCenter.getPendingNotificationRequests { (requests) in
                    for request in requests {
                        guard let trigger = request.trigger as? UNCalendarNotificationTrigger else { continue}
                        print ("mounth: \(trigger.dateComponents.month), day: \(trigger.dateComponents.weekday), hour: \(trigger.dateComponents.hour), minute: \(trigger.dateComponents.minute)")
                        
                    }
                }
                complitionAction()
            }
            if let error = error {
                print("Error \(error.localizedDescription)")
                
            }
        }
    }
    
    
    
    //test notification
    func testNotification(timeInterval: Double) {
        
        // 1 content
        let content = UNMutableNotificationContent()
        content.title = ""
        content.body = "TEST It`s time to drink pure water!"
        content.sound = .default
        content.categoryIdentifier = NotificationCategories.timeToDrink.rawValue
        content.threadIdentifier = "A"
        // 2 trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
        // 3 identifire
        let uuid = UUID().uuidString
        
        // 4 request
        let request = UNNotificationRequest(identifier: uuid,
                                            content: content,
                                            trigger: trigger)
        // 5 add to notification center
        notificationCenter.add(request) { (error) in
            print("testNotification added")
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    
    //reminder notification
    func reminder(timeInterval: Double, textBody: String) {
        
        // 1 content
        let content = UNMutableNotificationContent()
        content.title = ""
        content.body = textBody
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = NotificationCategories.timeToDrink.rawValue
        // 2 trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        // 3 identifire
        let uuid = UUID().uuidString
        
        // 4 request
        let request = UNNotificationRequest(identifier: uuid,
                                            content: content,
                                            trigger: trigger)
        // 5 add to notification center
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    
    
    
    //MARK: Notification Actions
    
    func createTimeToDrinkNotificationCategory(with categoryName: String) {
        //actions
        let timeToDrinkNotificationActions = [
            //Later notification
            UNNotificationAction(identifier: NotificationActionTypes.fiveMinutesLater.rawValue,  title: NotificationActionTypes.fiveMinutesLater.rawValue, options: []),
            
                UNNotificationAction(identifier: NotificationActionTypes.tenMinutesLater.rawValue,  title: NotificationActionTypes.tenMinutesLater.rawValue, options: []),
                  
                UNNotificationAction(identifier: NotificationActionTypes.fifteenMinutesLater.rawValue,  title: NotificationActionTypes.fifteenMinutesLater.rawValue, options: []),
                    
            UNNotificationAction(identifier: NotificationActionTypes.dissmis.rawValue,  title: NotificationActionTypes.dissmis.rawValue, options: [.destructive]),
        ]
        
        // notification category
        
        let timeToDrinkNotificationCategory = UNNotificationCategory(identifier: categoryName,
                                                                     actions: timeToDrinkNotificationActions,
                                                                     intentIdentifiers: [],
                                                                     hiddenPreviewsBodyPlaceholder: nil,
                                                                     categorySummaryFormat: nil,
                                                                     options: [])
        // register category
        UNUserNotificationCenter.current().setNotificationCategories([timeToDrinkNotificationCategory])
        
    }
    
    
    
    
    //MARK: UNUserNotificationCenterDelegate
    
    // 1 show notification even if app is active
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //в замыкании мы прописываем те опции с которыми должно прийти уведомление
        completionHandler([.alert, .sound])
    }
    
    
    // 2 users actions complition
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {

        //check identifire
        if response.notification.request.identifier == NotificationCategories.timeToDrink.rawValue {
            print("Handling notification with " + NotificationCategories.timeToDrink.rawValue + " identifire")
        }
        
        let bodyText = response.notification.request.content.body
        
        //настройка отображения с уведомлениями в NotificationViewController.swift
        //смотреть будем по идентификатору действия которые мы писали при создании действий в NotificationViewController.swift
        switch response.actionIdentifier {
            
        case UNNotificationDismissActionIdentifier:
            print("Default Dismiss Action")
            
        case UNNotificationDefaultActionIdentifier:
            print("Default Open App Action")
            
        case NotificationActionTypes.fiveMinutesLater.rawValue:
        print("Snooze 5 minutes")
        reminder(timeInterval: 300, textBody: bodyText)
      
        case NotificationActionTypes.tenMinutesLater.rawValue:
        print("Snooze 10 minutes")
        reminder(timeInterval: 600, textBody: bodyText)
            
        case NotificationActionTypes.fifteenMinutesLater.rawValue:
        print("Snooze 15 minutes")
        reminder(timeInterval: 900, textBody: bodyText)
            
        case NotificationActionTypes.dissmis.rawValue:
            print ("Dismiss")
            
        default:
            print("Unknown action")
        }
        
        completionHandler()
    }
    
    
    
    
    
    /*
     // метод делегата вызывается при открытии наших кастомных настроек через операционную системы для уведомлений
     func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
     //получаем доступ к классу AppDelegate т к открывать сториборд с настойками мы будем через класс апп делегейт
     let appDelegate = UIApplication.shared.delegate as? AppDelegate
     //октырываем метод openSettings()
     appDelegate?.openSettings()
     }
     
     */
}

