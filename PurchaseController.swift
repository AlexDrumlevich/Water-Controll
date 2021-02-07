//
//  PurchaseController.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 22.01.2021.
//  Copyright © 2021 ALEXEY DRUMLEVICH. All rights reserved.
//



import UIKit
import StoreKit

class PurchaseController {
    
    
    
    var iapManager: IAPManager!
    
    var containerVC: ContainerViewController
    
    var alertControllerCustom: AlertControllerCustom?
    
    var productIdentifire: String!
    
    init(containerVC: ContainerViewController, needToRestoreOnly: Bool) {
        
        self.containerVC = containerVC
        //берем синглтон - наш менеджер
        iapManager = IAPManager.shared
        let notificationCenter = NotificationCenter.default
        // add observer when we get all goods (now we hawe one good)
        notificationCenter.addObserver(self, selector: #selector(goodsBecameEnable), name: NSNotification.Name(IAPManager.productsWereReceivedNotificationIdentifier), object: nil)
        
        //add observer for our goods
        notificationCenter.addObserver(self, selector: #selector(completeGetPremiumVersion), name: NSNotification.Name(IAPProducts.premiumVersionWaterController.rawValue), object: nil)
        
        //add observer for error
        notificationCenter.addObserver(self, selector: #selector(errorReceiveProducts), name: NSNotification.Name(IAPManager.errorProductsReceivingNotificationIdentifier), object: nil)
        
        if needToRestoreOnly {
            restorePurchases()
        } else {
        // show alert
        purchasePremiumVersionAlertController()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func removeNotificationObserver() {
        //delite from observers
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //restore purchases
    private func restorePurchases() {
        iapManager.restoreCompletedTransactions()
    }
    
    // reload alert
    @objc private func goodsBecameEnable() {
        purchasePremiumVersionAlertController()
    }
    
    //error receiving products or 0 products
    @objc private func errorReceiveProducts() {
        purchasePremiumVersionAlertController( wasError: true)
    }
    
    //transaction finished
    @objc private func completeGetPremiumVersion() {
        //later
        
        purchasePremiumVersionAlertController(premiumVersionWasPurchase: true)
    }
    
    
    
    
    
    //MARK: опрелеляем цену локальную
    //определяем цены по месту нахождения пользователя - метод вернет строку с ценой
    private func priceStringFor(product: SKProduct) -> String? {
        //создаем объект NumberFormatter()
        let numberFormatter = NumberFormatter()
        //выбираем свойство стиля .currency - т е валюта
        numberFormatter.numberStyle = .currency
        //и в этот формат передаем локалюную цену
        // т е по сути локальная цена - то свойство товара  product.priceLocale
        numberFormatter.locale = product.priceLocale
        //а теперь просто все цены помещаем в форматер настроенный
        
        return numberFormatter.string(from: product.price)
    }
    
    private func tryLoadProductsOneMoreTime() {
        IAPManager.shared.setupPurchases { success in
            if success {
                IAPManager.shared.getProducts()
            } else {
                self.purchasePremiumVersionAlertController(wasError: true)
            }
        }
    }
    
    
    // purchase premium version alert
    private func purchasePremiumVersionAlertController(premiumVersionWasPurchase: Bool = false, wasError: Bool = false) {
        
            if self.alertControllerCustom != nil {
                self.alertControllerCustom?.clouseAlert()
                self.containerVC.removeViewBehindAlertAnderBanner()
            }
        DispatchQueue.main.async {
            self.alertControllerCustom = AlertControllerCustom()
            
            var text = ""
            var isLoading = false
            var isError = false
            isError = wasError
            
            // user got premium version
            if premiumVersionWasPurchase {
                
                text = AppTexts.congratulationsGetVIPVersionAppTexts
                //user in process of getting premium version
            } else {
                //no products - so we try to get products
                if self.iapManager.products.isEmpty {
                    if isError {
                        text = AppTexts.errorAppTexts
                    } else {
                    text = AppTexts.loadingAppTexts
                    isLoading = true
                        
                        if !IAPManager.isRequestProductsInProcces {
                        self.tryLoadProductsOneMoreTime()
                        }
                    
                    }
                    // we have products
                } else {
                    // we take fist product
                    if let product = self.iapManager.products.first {
                        if let prise = self.priceStringFor(product: product) {
                            self.productIdentifire = product.productIdentifier
                            text = AppTexts.offerPremiumVersionAppTexts + prise + "\n\t" + "RP -" + AppTexts.restorePurchasesAppTexts
                        } else {
                            text = AppTexts.errorAppTexts
                            isError = true
                        }
                        // error with get first product
                    } else {
                        text = AppTexts.errorAppTexts
                        isError = true
                    }
                }
                
            }
            
            
            guard self.alertControllerCustom != nil else { return }
            self.alertControllerCustom!.createAlert(observer: self, alertIdentifire: .purchasePremium, view: self.containerVC.createViewBehindAlertAnderBanner(), text: text, imageName: nil, firstButtonText: premiumVersionWasPurchase ? "Ok" : AppTexts.cancelAppTexts, secondButtonText: premiumVersionWasPurchase ? nil : isLoading ? nil : isError ? nil : "RP", thirdButtonText: premiumVersionWasPurchase ? nil : isLoading ? nil : isError ? nil : AppTexts.buyAppTexts, imageInButtons: false, isActivityIndicatorButtonSecond: isLoading)
            
        }
        
    }
    
}



extension PurchaseController: AlertControllerCustomActions {
    
    func buttonPressed(indexOfPressedButton: Int, identifire: AlertIdentifiers) {
        //close alert
        alertControllerCustom?.clouseAlert()
        containerVC.removeViewBehindAlertAnderBanner()
        
        // button index pressed
        switch indexOfPressedButton {
        
        //cancel (ok) button
        case 0:
            
            if containerVC.menuViewController == nil {
                containerVC.prepareToGetAdConsent(callFromGetOneMoreBottle: false)
            }
            containerVC.clousePurchaseController()
        
            
        case 1:
            
            restorePurchases()
            
            
        case 2:
            
            iapManager.purchase(productWith: productIdentifire)
            
        default:
            break
        }
        
    }
}

