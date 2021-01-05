//
//  ExtensionActivityIndicator.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 05.12.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

extension ContainerViewController {
    
    func activityIndicatorStartAnimating() {
        DispatchQueue.main.async {
            self.createActivityIndicator()
        }
    }
    
    func activityIndicatorStopAnimating() {
        DispatchQueue.main.async {
            self.deleteActivityIndicator()
        }
    }
    
    private func createActivityIndicator() {
        
        deleteActivityIndicator()
        
        var activityIndicator: UIActivityIndicatorView?
        
        if menuViewController != nil {
            menuViewController.activityIndicatorInMenuViewController = UIActivityIndicatorView()
            activityIndicator = menuViewController.activityIndicatorInMenuViewController
        } else {
            activityIndicatorInContainerViewController = UIActivityIndicatorView()
            activityIndicator = activityIndicatorInContainerViewController
        }
        
        guard  activityIndicator != nil else {
            return
        }
        
        guard let viewForActivityIndicator = menuViewController == nil ? view : menuViewController.view else { return }
        
        
        viewForActivityIndicator.addSubview(activityIndicator!)
        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator?.centerYAnchor.constraint(equalTo: viewForActivityIndicator.centerYAnchor).isActive = true
        activityIndicator?.centerXAnchor.constraint(equalTo: viewForActivityIndicator.centerXAnchor).isActive = true
        activityIndicator?.startAnimating()
        
    }
    
    private func deleteActivityIndicator() {
        
        
        if menuViewController != nil {
            if menuViewController.activityIndicatorInMenuViewController != nil {
                menuViewController.activityIndicatorInMenuViewController?.removeFromSuperview()
                menuViewController.activityIndicatorInMenuViewController = nil
            }
        }
        
        if activityIndicatorInContainerViewController != nil {
            activityIndicatorInContainerViewController?.removeFromSuperview()
            activityIndicatorInContainerViewController = nil
            
        }
    }
}
