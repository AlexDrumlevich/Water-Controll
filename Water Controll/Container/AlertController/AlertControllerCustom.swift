//
//  AletControllerCustom.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 21.08.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

protocol AlertControllerCustomActions {
    func buttonPressed(indexOfPressedPutton: Int, identifire: AlertIdentifiers)
}


class AlertControllerCustom: UIView {
    
    
    let constantConstraint: CGFloat = 10
    var stackView: UIStackView?
    var label: UILabel?
    var imageView: UIImageView?
    var buttons: [UIButton] = []
    var observer: AlertControllerCustomActions!
    var alertIdentifire: AlertIdentifiers!
    var activityIndicatorFirst: UIActivityIndicatorView?
    var activityIndicatorSecond: UIActivityIndicatorView?
    var activityIndicatorThird: UIActivityIndicatorView?
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
    
    func createAlert(observer: AlertControllerCustomActions, alertIdentifire: AlertIdentifiers, view: UIView, text: String, imageName: String?, firstButtonText: String, secondButtonText: String?, thirdButtonText: String?, imageInButtons: Bool = false, isActivityIndicatorButtonFirst: Bool = false, isActivityIndicatorButtonSecond: Bool = false, isActivityIndicatorButtonThird: Bool = false) {
        
        self.observer = observer
        self.alertIdentifire = alertIdentifire
        view.addSubview(self)
        self.backgroundColor = .black
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2).isActive = true
        self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
       label = createLabel(in: self, with: text)
        if imageName != nil {
           imageView = createImageView(in: self, with: imageName!)
        }
        
        // create activity indicators
        createActivityIndicators(isActivityIndicatorButtonFirst, isActivityIndicatorButtonSecond, isActivityIndicatorButtonThird)
        
        //create buttons
        createButton(in: self, with: firstButtonText, isPicture: imageInButtons, activityIndicator: activityIndicatorFirst)
        if secondButtonText != nil {
            createButton(in: self, with: secondButtonText!, isPicture: imageInButtons, activityIndicator: activityIndicatorSecond)
        }
        if thirdButtonText != nil {
            createButton(in: self, with: thirdButtonText!, isPicture: imageInButtons, activityIndicator: activityIndicatorThird)
        }
        addButtonActions()
        
        setConstraints(label: label!, imageView: imageView)
        
    }
    
    func clouseAlert() {
        observer = nil
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }
    }
    
    func stopAnimating(firstButton: Bool = false, secondButton: Bool = false, thirdButton: Bool = false) {
      
        if firstButton && activityIndicatorFirst != nil && buttons.count >= 1 {
            activityIndicatorFirst?.stopAnimating()
            activityIndicatorFirst?.removeFromSuperview()
            buttons[0].isEnabled = true
        }
        if secondButton && activityIndicatorSecond != nil && buttons.count >= 2 {
            activityIndicatorSecond?.stopAnimating()
            activityIndicatorSecond?.removeFromSuperview()
            buttons[1].isEnabled = true
        }
        if thirdButton && activityIndicatorThird != nil && buttons.count >= 3 {
            activityIndicatorThird?.stopAnimating()
            activityIndicatorThird?.removeFromSuperview()
            buttons[2].isEnabled = true
        }
    }
    
    private func createLabel(in view: UIView, with text: String) -> UILabel {
        let label = UILabel()
        view.addSubview(label)
        label.text = text
        label.backgroundColor = .clear
        label.textAlignment = .center
        let fontSize = view.superview!.frame.height * 1/15
        print(fontSize)
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "AmericanTypewriter", size:  fontSize)
        label.textColor = #colorLiteral(red: 0.2500994205, green: 0.2834563255, blue: 1, alpha: 1)
        label.minimumScaleFactor = 0.1
        label.numberOfLines = 0
        return label
    }
    
    private func createImageView(in view: UIView, with imageName: String) -> UIImageView {
        let imageView = UIImageView()
        view.addSubview(imageView)
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }
    
    
    private func createActivityIndicators(_ isFirstActivityIndicator: Bool, _ isSecondActivityIndicator: Bool, _ isThirdActivityIndicator: Bool) {
        if isFirstActivityIndicator {
            activityIndicatorFirst = UIActivityIndicatorView()
        }
        if isSecondActivityIndicator {
            activityIndicatorSecond = UIActivityIndicatorView()
        }
        if isThirdActivityIndicator {
            activityIndicatorThird = UIActivityIndicatorView()
        }

    }
    
    
    private func createButton(in view: UIView, with text: String, isPicture: Bool = false, activityIndicator: UIActivityIndicatorView? = nil) {
        
        
        let button = UIButton()
        button.backgroundColor = .clear
        
        if isPicture {
            button.setImage(UIImage(named: text), for: .normal)
            
           
        } else {
            button.setTitle(text, for: .normal)
        }
        
        if activityIndicator != nil {
            button.addSubview(activityIndicator!)
            activityIndicator?.startAnimating()
            button.isEnabled = false
            activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator?.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
            activityIndicator?.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
            
        }
        
        if stackView == nil {
            stackView = UIStackView()
            view.addSubview(stackView!)
            stackView?.alignment = .center
            stackView?.distribution = .equalCentering
            stackView?.spacing = 15
            stackView?.backgroundColor = .red
            //stackView!.isLayoutMarginsRelativeArrangement = false
        }
        stackView?.addArrangedSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalTo: stackView!.heightAnchor, multiplier: 8/10).isActive = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
      
        buttons.append(button)
    }
    
    
    
    private func setConstraints(label: UILabel, imageView: UIImageView?) {
        
        //label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: constantConstraint).isActive = true
        
        if imageView == nil {
            label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 2/3).isActive = true
            
        } else {
            label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3).isActive = true
            // image view
            imageView!.translatesAutoresizingMaskIntoConstraints = false
            imageView!.topAnchor.constraint(equalTo: label.bottomAnchor, constant:  constantConstraint).isActive = true
            imageView!.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            imageView!.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            imageView?.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3).isActive = true
        }
        
        stackView!.translatesAutoresizingMaskIntoConstraints = false
        stackView!.topAnchor.constraint(equalTo: imageView == nil ? label.bottomAnchor : imageView!.bottomAnchor, constant:  constantConstraint).isActive = true
        stackView!.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
  
    }
    
    private func addButtonActions() {
        
        for (index, button) in buttons.enumerated() {
           
            switch index {
            case 0:
                 button.addTarget(self, action: #selector(actionButtonFirst), for: .touchUpInside)
            case 1:
                button.addTarget(self, action: #selector(actionButtonSecond), for: .touchUpInside)
            case 2:
                  button.addTarget(self, action: #selector(actionButtonThird), for: .touchUpInside)
            default:
                break
            }
        }
    }
    
    @objc func actionButtonFirst() {
        observer.buttonPressed(indexOfPressedPutton: 0, identifire: alertIdentifire)
    }
    
    @objc func actionButtonSecond() {
        observer.buttonPressed(indexOfPressedPutton: 1, identifire: alertIdentifire)
    }
    
    @objc func actionButtonThird() {
        observer.buttonPressed(indexOfPressedPutton: 2, identifire: alertIdentifire)
    }
    
}
