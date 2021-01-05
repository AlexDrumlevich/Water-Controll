//
//  ContainerViewController GADBannerViewDelegate.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 07.11.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit
import GoogleMobileAds

// banner ADs
extension ContainerViewController: GADBannerViewDelegate {
    
    func createBanner() {
        
        createBlurViewBehindBanner()
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        
        if blurViewBehindBanner != nil {
            addBannerViews(subView: blurViewBehindBanner!)
        }
     
        addBannerViews(subView: bannerView)
    
       setConstraints(bannerView, isLimit: true)
        
        if blurViewBehindBanner != nil {
         setConstraints(blurViewBehindBanner!, isLimit: false)
        }
        
        bannerView.adUnitID = bannerViewId
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
    }
    
    
    
    private func createBlurViewBehindBanner() {
        
        
        blurViewBehindBanner = UIView()
        blurViewBehindBanner?.backgroundColor = #colorLiteral(red: 0.9035461545, green: 0.9148401618, blue: 0.9662012458, alpha: 1)
        let blurView = UIVisualEffectView()
        let blurEffect = UIBlurEffect(style: .regular)
        blurView.effect = blurEffect
        blurViewBehindBanner?.addSubview(blurView)
    }
    
    

    
    
    
    private func addBannerViews(subView: UIView) {

        subView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subView)
    }
    
    // add banner  into view function
    private func setConstraints(_ subView: UIView, isLimit: Bool) {
      //  subView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(
            [NSLayoutConstraint(item: subView,
                                attribute: .top,
                                relatedBy: .equal,
                                toItem: isLimit ? view.safeAreaLayoutGuide : view,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: subView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
       
        if isLimit {
            subView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            subView.widthAnchor.constraint(equalToConstant: 320).isActive = true
        } else {
            subView.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor).isActive = true
            subView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        }
    }
    
}
