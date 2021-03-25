//
//  IAP.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 22.01.2021.
//  Copyright © 2021 ALEXEY DRUMLEVICH. All rights reserved.
//

import Foundation
import StoreKit



//1  нам нужно сделать чтобы был единственный объект который будет работать с покупками т е нам не надо делать много объектов этого класса у нас будет один объект только т е класс будет синглтоном, для этого пишем   static let shared = IAPManager() и приячем инициализатор  private override init() {}
//2  StoreKit импортируем
// 3  проверяем можно ли с устройства совершать платежи (нельзя например если стоит родительский контроль) - setupPurchases
// 4 подписываемся под протокол SKPaymentTransactionObserver для наблюдения за транзакциями
//5 !!!!в методе апп делегат didFinishLaunchingWithOptions  в качестве наблюдателя делаем свой менеджер т е там вызываем тетод setupPurchases т к наблюдатель у нас устанавливается при запуске приложения сразу т е все транзкции обязательно должны наблюдаться с момента запуска приложения
//6 Берем идентификаторы наших покупок и передаем их в качестве параметра запроса, запускаем запрои и назначаем себя делегатом протокола реализующего методы вызывающиеся по окончанию этого запроса (т е мы получим ответ - соответствующий метод делегата будет вызван + запускаем запрос - все в методе getProducts
// т е мы как бы проверяем наличие продуктов по нашим идентификаторам т к продуктов уже таких может и не быть с таким иидентификаторами которые мы передали от сервера или которые заложены в нашем приложении

//7 Работа с экраном покупок - файл PurchaseController.swift

//8 методы отвечающие за покупки - func purchase (1 Проверяем наличие товара по идентификатору в нашем массие на всякий случай, 2 создаем платеж, 3 передаем платеж в очередь платежей)
//9 после того как платеж передан в очередь он начинает отслеживаться методом paymentQueue протокола SKPaymentTransactionObserver (см в методе реализацию )
//10 метод покупки вызываем при нажатии пользователем на ячейку (где берем идентификатор товара соответствующего этой ячейке)
//11 Нужной удентифицировать какой именно товар был куплен и сооветствующим образом на это отреагировть т е сли куплена подписка - предоставить ее или дать игровую валюту -это все в кейсе .purchased (все покупки) и надо их дифференцировать - 2 варианта или создаем делегата который в зависимости от идентификатора товара будет выполнять разные методы или сделать это все через уведомления

//12 Валидация чека - как защита от взлома приложения и получения товаров бесплатно
//      1 чек хранится с приложением и он зашифрован и просто так его не прочитать
//цель валидации - проверка , что чек действительно предоставлен от аппл (тут м б локальная валидация или через сервер)
//заходим apple.com/certificareautority и там нам нужен Apple Inc. root ertificate - скачиваем его
//перетаскиваем сертификат в проект , выделяем его и в правой панели ставим галочку напротив нашего таргета
//      2  ставим pod -библиотеку open ssl через которую можно расшифровать чек
// сайт cocoapods.org - ищем OpenSSL (установка cocoapods на главной странице)
// в терминале внутри проекта pod init (формируем pod файл) -вносим необходимую строку в pod файл и закрываем - pod install (в терминале)
//    3 создаем несколькофайло - у нас в папке Validation
 //               Новый файл - Objective-C File + на предложение создать Bridging Header создаем его (потом сказу можно удалить Objective-C File созданный т к создавали ради  Bridging Header )
//                  В Bridging Header указываем фреймворки библиотек которые работают на Objective-C (#include "pkcs7_union_accessors.h"
//#import <openssl/pkcs7.h>
//#import <openssl/objects.h>
//#import <openssl/sha.h>
//#import <openssl/x509.h>
 
//              + добавляем файлы pkcs7_union_accessors.c и pkcs7_union_accessors.h (эти файлы били созданы Эндриу Бенкрафтем (см можно его ресурсы например на git hub - andrewcbancrift/SwiftyLocalReceiptValidator
//при использовании его библиотеки мы можем получить много разныхзначений (см на гит хаб) а нам пока интересно значение subscriptionExpirationDate - дата окончания подписки
// + добавляем файл ReceiptValidator.swift
//благодаря все указанным файлам можно делать валидацию
//возможно в настройках проекта в Build Settings в строке Enable Bitcode надо будет поставить NO (если будет ошибка)




//метод восстановления покупок
class IAPManager: NSObject {
    
    //идентификатор - нужен для отправки уведомления внутреннего при получении товаров по запросу
    static let productsWereReceivedNotificationIdentifier = "IAPManagerProductWereReceived"
    static let errorProductsReceivingNotificationIdentifier = "IAPManagerErrorProductsReceiving"
    
    static let errorInTransaction = "IAPManagerErrorInTransacton"
    static let errorInRestore = "IAPManagerErrorInRestore"
    static let userRefusedTransaction = "userRefusedTransaction"
    
    static var isRequestProductsInProcces = false
    
    //создаем синглтон
    //это свойство и есть экземпляр класса
    static let shared = IAPManager()
    //прячем инициализатор, override - т к наследуемся от другого класса и переопределяем его инициализатор
    private override init() {}
    
    
    //массив для хранения товаров которые нам вернутся по запросу товаров по нашим идентификаторам т к только такие товары можно продавать
    var products: [SKProduct] = []
    
    //Создаем очередь для платежей
    let paymentQueue = SKPaymentQueue.default()
    
    
    
    //проверяем можно ли с устройства совершать платежи (нельзя например если стоит родительский контроль)
    // передаем в замыкание может или нет
    public func setupPurchases(callback: @escaping(Bool) -> ()) {
        //  может ли  устройство выполнять платеж
        if SKPaymentQueue.canMakePayments() {
            //если может то попадаем в этот блок
           // SKPaymentQueue.default().add(<#T##observer: SKPaymentTransactionObserver##SKPaymentTransactionObserver#>) - метод добавляет наблюдателя за транзакцией - этот метод мы здесь используем
            //в качестве <#T##observer: SKPaymentTransactionObserver##SKPaymentTransactionObserver#>  пишем self и в бальнейшем надо добавть протокол с методом одним чтобы получать информацию о состоянии блатежа
           // SKPaymentQueue.default().add(<#T##payment: SKPayment##SKPayment#>) - это уже метод по добавлению платежа в очередь
            paymentQueue.add(self)
            //возвращаем в комплишн хендлер true
            callback(true)
            return
        }
        //возвращаем в комплишн хендлер то что устройство платить не может
        callback(false)
    }
    
   
    //MARK: метод по получению товаров
    //( у нас просто из другого файла) но м б и с  сервера надо реализовывать
    //получаем в виде Set - неупорядоченная коллекция уникальных элементов
    public func getProducts() {
        //получаем набор идентификаторов
        let identifiers: Set = [IAPProducts.premiumVersionWaterController.rawValue]
        //делаем запрос на полуение товаров по этим идентификаторам
        let productRequest = SKProductsRequest(productIdentifiers: identifiers)
        //в качестве делегата назначаем себя (т е при реализации соответствующего метода он вызовется когда придет ответ на наш запрос) - подписываемся под протокол и реализуем метод протокола SKProductsRequestDelegate
        productRequest.delegate = self
        
        // запускаем запрос
        productRequest.start()
       
        IAPManager.isRequestProductsInProcces = true
        
    }
    
   
    //MARK: метод покупки
    //передаем сюда идентификатор товара
    public func purchase(productWith identifier: String) {
        // проверяем что продукт с переданным в метод идентификатором действительно существует
        //для этого ищем идентификатор в нашем массиве
        //filter - фильтрация по заданным параметрам т е если идентификатор элемента массива $0.productIdentifier  равен полученному в методе идентификатору
        //на выходе у метода .filter получается массив поэтому берем первый элемент массива (по идее он должен быть всегда один в массиве)
        guard let product = products.filter({ $0.productIdentifier == identifier }).first else { return }
        //создаем платеж передав в него товар
        let payment = SKPayment(product: product)
        
        /*
        //если пользователь выбирает сколько хочет купить например сколько месяцев подписки (если например товар - 1 месяц) или сколюко игровой валты купить (а товар - это 1 алмаз а он хочет 10 купит) то нужен другой платеж (таким образом в примере ниже будет платеж сразу за 10 товаров):
        let payment2 = SKMutablePayment(product: product)
        payment2.quantity = 10
        */
        
        //помещаем платеж в очередь paymentQueue- это SKPaymentQueue.default()
        paymentQueue.add(payment)
    }
    
    
    //MARK: метод для восстановления покупок
    //
    public func restoreCompletedTransactions() {
        //восстанавливаем покупки
        paymentQueue.restoreCompletedTransactions()
    }
}


//MRK: СОСТОЯНИЯ ТРАНЗАКЦИИ
//MARK:  SKPaymentTransactionObserver
extension IAPManager: SKPaymentTransactionObserver {
    //метод вызывается при переходе на каждую последующую стадию транзакции
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
      //метод возвращаем массив транзакций мы обрабатываем все транзакции и все состояний каждой из них (т к транзакций м б несколько сразу в очереди)
        for transaction in transactions {
            switch transaction.transactionState {
            case .deferred: break // транзакция в подвешанном состоянии бесконечно долго (например когда есть родительский контроль и родитель должен одобрить покупку но пока не одобрил а покупка уже в очереди)
                //блокировать UI здесь нельзя
            case .purchasing: break // это состояние когда у пользователя появилось окно что он что то покупает тут тоже ничего не делаем а ждем пользователя  //блокировать UI здесь нельзя
            case .failed: failed(transaction: transaction) // неудачная транзакция (из за ошибок или если пользователь нажал купить а потом отменил) - вызываем метод  failed с переданной в него транзакцией

            case .purchased: completed(transaction: transaction) // товар куплен - вызываем метод  completed с переданной в него транзакцией
            case .restored: restored(transaction: transaction) // восстановление покупки если пользователь уже ранее покупал товар  - вызываем метод  restored с переданной в него транзакцией
            @unknown default:
                print("New case is avalible")
            }
        }
    }
    
//    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
//        <#code#>
//    }
    
    //метод при неудачной транзакции вызывается у нас
    private func failed(transaction: SKPaymentTransaction) {
        //если есть ошибка
        if let transactionError = transaction.error as NSError? {
            //.code  - свойство у NSError
            //и здесь мы сравниваем является ли ошибка транзакции тем же кодом что и код отмены платежа
            //т к SKError.paymentCancelled.rawValue  - возвращает код указывающий на то что пользователь отменил платеж
            //мы выводим pдесь только ошибки а отмену пользователем покупки мы не обрабатываем
           
          
            if transactionError.code != SKError.paymentCancelled.rawValue {
                NotificationCenter.default.post(name: NSNotification.Name(IAPManager.errorInTransaction), object: nil)
                print("Ошибка транзакции: \(transaction.error!.localizedDescription)")
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(IAPManager.userRefusedTransaction), object: nil)
                
            }
        }
        //теперь надо из очереди транзакций удалить транзакцию с ошибкой
        paymentQueue.finishTransaction(transaction)
    }
    
    
    //метод при удачной завершении транзакции
    //здесь мы будем добавлять отправку уведомлений разных в зависимости от того какой товар куплен
    private func completed(transaction: SKPaymentTransaction) {
        
            paymentQueue.finishTransaction(transaction)
                NotificationCenter.default.post(name: NSNotification.Name(transaction.payment.productIdentifier), object: nil)
                
        
        
//        transaction.payment.productIdentifier
                
               // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!+ здесь надо сохранять в память например в UserDefaults какое либо свойство запоминающее что товар куплен а то пользователю при каждом запуске придется товар покупать

            }
          

    
    //метод при восстановлении покупки - транзакции
    private func restored(transaction: SKPaymentTransaction) {
        
        //очищаем очередь
        paymentQueue.finishTransaction(transaction)
        
        //get original
        guard let originalTransaction = transaction.original else {
            return
        }
        // send notification 
        NotificationCenter.default.post(name: NSNotification.Name(originalTransaction.payment.productIdentifier), object: nil)
        
    }
}




//MARK:  SKProductsRequestDelegate
extension IAPManager: SKProductsRequestDelegate {
    //метод вызывается в качестве ответа на запрос встроенных покупок по идентификаторам (запрос делаем в методе getProducts)
    //после получения ответа мы можем сохранить товары в отдельном массиве
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        IAPManager.isRequestProductsInProcces = false
        request.delegate = nil
        request.cancel()
            
        //метод возвращает нам массив продуктов и мы передаем их в наш массив
        self.products = response.products
        //теперь проверяем что продукт каждый чтото содержит и устанавлявает название исходя из локализации
        //products.forEach { print($0.localizedTitle) }
        //если у нас товаров в массиве бельше 0 то вызываем уведомление (т е уведомление будет вызвано когда вернутся товары по запросу) - это уведомление мы будем обрабатывать в классе PurchaseController.swift - где при его получении мы просто будем перезагружать нашу таблицу для отображения в ней полученных товаров
        if products.count > 0 {
        //MARK: внутреннее уведомление
            //добавляем уведомление в нотификейшн центр и отправляем его сразу с заранее созданным идентификатором
            NotificationCenter.default.post(name: NSNotification.Name(IAPManager.productsWereReceivedNotificationIdentifier), object: nil)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(IAPManager.errorProductsReceivingNotificationIdentifier), object: nil)
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
      
        guard let productRequest = request as? SKProductsRequest else {
            request.delegate = nil
            request.cancel()
            return
        }
        productRequest.delegate = nil
        productRequest.cancel()
        IAPManager.isRequestProductsInProcces = false
        NotificationCenter.default.post(name: NSNotification.Name(IAPManager.errorProductsReceivingNotificationIdentifier), object: nil)
    }
    
    func requestDidFinish(_ request: SKRequest) {
        IAPManager.isRequestProductsInProcces = false
    }
    
    
}
