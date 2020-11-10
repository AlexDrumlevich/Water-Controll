//
//  NotificationViewController.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 21.06.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//
/*
import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
  
    
    let constantConstraint: CGFloat = 5
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var volumePicker: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    var volumeTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var pourWaterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var laterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var openAppButton: UIButton = {
          let button = UIButton()
          button.translatesAutoresizingMaskIntoConstraints = false
          return button
      }()
    
    var dismissButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    var laterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var backButtonFromLaterViewInLaterView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let laterLabelInLaterView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let fiveMinutesButtonLaterInLaterView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let tenMinutesButtonLaterInLaterView: UIButton = {
           let button = UIButton()
           button.translatesAutoresizingMaskIntoConstraints = false
           return button
       }()
    
    let otherLabelInLaterView: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    let timePickerInLaterView: UIDatePicker = {
        let dataPicker = UIDatePicker()
        dataPicker.translatesAutoresizingMaskIntoConstraints = false
        return dataPicker
    }()
    
    let okButtonInLaterView: UIButton = {
             let button = UIButton()
             button.translatesAutoresizingMaskIntoConstraints = false
             return button
         }()
    
    
    
    // @IBOutlet weak var label: UILabel?
    //@IBOutlet weak var likeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setNotificationCategories()
    }
    
    //    @IBAction func likeButtonTapped(_ sender: Any) {
    //        // закрашиваем сердечко при нажатии на него
    //        likeButton.setTitle("♥", for: .normal)
    //    }
    
    //    @IBAction func openAppButton(_ sender: Any) {
    //        //при нажатии на кнопку открываем приложение
    //        openApp()
    //    }
    
    private func addViewsInMainView() {
        view.addSubview(nameLabel)
        view.addSubview(volumePicker)
        view.addSubview(volumeTypeLabel)
        view.addSubview(pourWaterButton)
        view.addSubview(laterButton)
        view.addSubview(openAppButton)
        view.addSubview(dismissButton)
        
        setupConstraintsToMainView()
        
        setupFont(for: [nameLabel, volumeTypeLabel])
        addActions()
    }
    
    
    
    private func setupFont(for labels: [UILabel]) {
        for label in labels {
            label.textAlignment = .center
            label.font = UIFont(name: "AmericanTypewriter", size:  view.bounds.height * 1 / 7 )
            label.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.2
        }
    }
    
    private func setupConstraintsToMainView () {
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: constantConstraint).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constantConstraint).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: constantConstraint).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: (view.bounds.height - (5 * constantConstraint)) * 1 / 6).isActive = true
        
        volumePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant:  constantConstraint).isActive = true
        volumePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constantConstraint).isActive = true
        volumePicker.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -constantConstraint / 2).isActive = true
        volumePicker.heightAnchor.constraint(equalToConstant: (view.bounds.height - (5 * constantConstraint)) * 3 / 6).isActive = true
        
        volumeTypeLabel.topAnchor.constraint(equalTo: volumePicker.bottomAnchor, constant:  constantConstraint).isActive = true
        volumeTypeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constantConstraint).isActive = true
        volumeTypeLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -constantConstraint / 2).isActive = true
        volumeTypeLabel.heightAnchor.constraint(equalToConstant: (view.bounds.height - (5 * constantConstraint)) * 1 / 6).isActive = true
                
        pourWaterButton.leadingAnchor.constraint(equalTo: volumePicker.trailingAnchor, constant: constantConstraint).isActive = true
        pourWaterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constantConstraint).isActive = true
        pourWaterButton.firstBaselineAnchor.constraint(equalTo: volumePicker.firstBaselineAnchor).isActive = true
        pourWaterButton.lastBaselineAnchor.constraint(equalTo: volumeTypeLabel.lastBaselineAnchor).isActive = true
        
        laterButton.topAnchor.constraint(equalTo: volumeTypeLabel.bottomAnchor, constant:  constantConstraint).isActive = true
        laterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constantConstraint).isActive = true
        laterButton.widthAnchor.constraint(equalToConstant: (view.bounds.width - (constantConstraint * 4)) / 3).isActive = true
        laterButton.heightAnchor.constraint(equalToConstant: (view.bounds.height - (5 * constantConstraint)) * 1 / 6).isActive = true
        
        dismissButton.leadingAnchor.constraint(equalTo: laterButton.trailingAnchor, constant: constantConstraint).isActive = true
        dismissButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -constantConstraint).isActive = true
        dismissButton.firstBaselineAnchor.constraint(equalTo: laterButton.firstBaselineAnchor).isActive = true
        dismissButton.lastBaselineAnchor.constraint(equalTo: laterButton.lastBaselineAnchor).isActive = true
    }
    
    //actions
        
    private func addActions() {
        pourWaterButton.addTarget(self, action: #selector(pourWaterAction), for: .touchUpInside)
        laterButton.addTarget(self, action: #selector(laterAction), for: .touchUpInside)
        openAppButton.addTarget(self, action: #selector(openAppAction), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
    }
    
    @objc func pourWaterAction() {
        
    }
    
    @objc func laterAction() {
        
    }
    
    //dismiss notification
    @objc func dismissAction () {
      dismissNotification()
    }
    
    @objc func openAppAction() {
        extensionContext?.performNotificationDefaultAction()
    }
    

 //dismiss notification
    private func dismissNotification() {
           extensionContext?.dismissNotificationContentExtension()
    }
    
    
    
    private func createLaterView() {
        
        
    }
    
    
    
    
    
    
    
    func didReceive(_ notification: UNNotification) {
          return
      }
    
    //метод протокола который позволяет работать с контентом уведомления
    //notification - это поступившее уведомление со всем его содержимым
 //   func didReceive(_ notification: UNNotification) {
      //  label?.text = notification.request.content.body
   // }
    
    
    // этот метод обрабатывает действия от класса NSNotificationActions и в нем можно настроить пользовательские действия для уведомления
    // т е вызывается когда пользователь совершил какое либо действие с уведомлением
   
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        //настраиваем дополнительные пункты меню
        //response - содержит информацию о пользовательских действиях
        // если идентификатор экшена у нас Snooze" то добавляем действия дополнительные (экшены)
        switch response.actionIdentifier {
            
        //обрабатываем все действия для которых предусмотрены дополнительные возможности после выбора этих действий
        case NotificationActionTypes.later.rawValue:
            //создаем массив экшенов
            let actions = [
                UNNotificationAction(identifier: NotificationActionTypes.fiveMinutesLater.rawValue,  title: "5 minutes", options: []),
                UNNotificationAction(identifier: NotificationActionTypes.tenMinutesLater.rawValue,  title: "10 minutes", options: []),
                UNNotificationAction(identifier: NotificationActionTypes.tenMinutesLater.rawValue,  title: "15 minutes", options: []),
            ]
            
            //MARK: add new actions
            extensionContext?.notificationActions = actions
            
            
        case NotificationActionTypes.fiveMinutesLater.rawValue:
            //вызываем новое уведомление и скрываем текущее уведомление
            reminder(timeInterval: 300)
            dismissNotification()
        case NotificationActionTypes.tenMinutesLater.rawValue:
            reminder(timeInterval: 600)
            dismissNotification()
        case NotificationActionTypes.tenMinutesLater.rawValue:
            reminder(timeInterval: 900)
            dismissNotification()
        case NotificationActionTypes.dissmis.rawValue:
            dismissNotification()
        default:
            dismissNotification()
        }
    }
    
    
    //reminder notification
    func reminder(timeInterval: Double) {
        
    // 1 content
        let content = UNMutableNotificationContent()
      //  (currentUser.name ?? ""), body: "It`s time to drink pure water!"
        content.title = ""
        content.body = "It`s time to drink pure water!"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = NotificationCategories.timeToDrink.rawValue
        
        
        //trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let uuid = UUID().uuidString
        
        // request
        let request = UNNotificationRequest(identifier: uuid,
                                            content: content,
                                            trigger: trigger)
        //add to notification center
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    
    //MARK: Действия пользователя с уведомлением identifier сами придумываем
    func setNotificationCategories() {
        //1   определяем список доступных действий с уведомлением
        // это не сами действия это лиш заголовки для меню действий и опции этих заголовков например выделение красным
        let actions = [
            //Snooze - отложение уведомления
            UNNotificationAction(identifier: "Snooze",  title: "Snooze", options: []),
            //отменить - больше не показывать -ничего больше не делать
            //.destructive - выделено красным цветом
            UNNotificationAction(identifier: "DismissDestructive",  title: "Dismiss", options: [.destructive]),
            UNNotificationAction(identifier: "Dismiss",  title: "Dismisss", options: []),
        ]
        //2 создаем категорию уведомлений т е создаем категорию уведомлений под определенным идентификатором (у нас "User Actions") и в этой категории определяем список возможных действий т е если наше уведомление будет в какой либо категории то у нашего уведомления будет доступен список действий которые такой категорией определены
        // в свойство categorySummaryFormat мы передаем формат строки который хотим видетль в сгруппированных уведомлениях
        //%u - отвечает за количество сообщейни в группе (его можно модифицировать с помощью argument summary counts т е в контенте свойству контента  summaryArgumentCount присвоить какое либо число иначе это просто количество аргументов будет(например нам надо отправить уведомление что стало доступно какое либо количество новых тем и чтобы не отправлять уведомление по каждой теме можно отправить одно уведомление с количеством новых тем
        //при этом если мы например отправили 10 и второй раз 10 то хотя и будет всего 2 уведомления на в группе будет написано 20 новых уведомлений
        //%@ - значение переменной summaryArgument также являющейся свойством контента и можно в него что либо передать при отправке уведомления
        let category = UNNotificationCategory(identifier: "User Actions",
                                              actions: actions, // это наш массив действий
            intentIdentifiers: [],
            hiddenPreviewsBodyPlaceholder: nil,
            categorySummaryFormat: "%u новых уведомлений в разделе %@",
            options: [])
        //3. регистрируем созданную категорию в центре уведомлений
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        //Сейчас мы настроили только строки для уведомления которые нам покажутся если мы потянем за уведомление а реализацию того что мы будем делать делаем в  Notifications.swift
    }
 
 
 
 
 
 
 
 
 
 //MARK: UNNotificationContentExtension
  
  func dismissNotification() {
        //метод закрывает уведомление
        extensionContext?.dismissNotificationContentExtension()
    }
  
  
  func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
      
        switch response.actionIdentifier {
            
        case UNNotificationDismissActionIdentifier:
            print("Default Dismiss Action")
            
        case UNNotificationDefaultActionIdentifier:
            print("Default Open App Action")
            
        case "Later":
            print("Snooze")

            let actions = [
                       UNNotificationAction(identifier: "5 second",  title: "Отложить на 5 секунд", options: []),
                       UNNotificationAction(identifier: "10 second",  title: "Отложить на 10 секунд", options: []),
                       UNNotificationAction(identifier: "60 second",  title: "Отложить на 60 секунд", options: []),
                       ]
            
             extensionContext?.notificationActions = actions
            
          reminder(timeInterval: 5)
      
      
         case "5 second":
             //вызываем новое уведомление и скрываем текущее уведомление
             reminder(timeInterval: 5)
             dismissNotification()
         case "10 second":
             reminder(timeInterval: 10)
             dismissNotification()
         case "60 second":
             reminder(timeInterval: 60)
             dismissNotification()
        case "Dismiss":
               print ("Dismiss")
           default:
               print("Unknown action")
           }
 
  }
  
  
  func didReceive(_ notification: UNNotification) {
      print("OK")
  }
  
}
*/
