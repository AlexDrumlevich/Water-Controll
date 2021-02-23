//
//  AletControllerCustom.swift
//  Water Controll
//
//  Created by ALEXEY DRUMLEVICH on 21.08.2020.
//  Copyright © 2020 ALEXEY DRUMLEVICH. All rights reserved.
//

import UIKit

protocol AlertControllerCustomActions {
    func buttonPressed(indexOfPressedButton: Int, identifire: AlertIdentifiers)
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
    let heightMultiplier: CGFloat = 2 / 3
    let widthMultiplier: CGFloat = 4 / 5
    
    //alert id
    let alertID = UUID().uuidString
    
    // create UIVisualEffectView for blur effect
    let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
    
    func createAlert(observer: AlertControllerCustomActions, alertIdentifire: AlertIdentifiers, view: UIView, text: String, imageName: String?, firstButtonText: String?, secondButtonText: String?, thirdButtonText: String?, imageInButtons: Bool = false, isActivityIndicatorButtonFirst: Bool = false, isActivityIndicatorButtonSecond: Bool = false, isActivityIndicatorButtonThird: Bool = false) {
        
        self.observer = observer
        self.alertIdentifire = alertIdentifire
      
        
        
        view.addSubview(self)
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: heightMultiplier).isActive = true
        self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: widthMultiplier).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //set blur view
        self.addSubview(blurView)
        setupBlurView(view: view)
        
       label = createLabel(in: self, with: text)
        if imageName != nil {
           imageView = createImageView(in: self, with: imageName!)
        }
        
       
        
        //create buttons
        if firstButtonText != nil {
        createButton(in: self, with: firstButtonText!, isPicture: imageInButtons, activityIndicator: &activityIndicatorFirst)
        }
        
        if secondButtonText != nil {
            createButton(in: self, with: secondButtonText!, isPicture: imageInButtons, activityIndicator: &activityIndicatorSecond)
        }
        if thirdButtonText != nil {
            createButton(in: self, with: thirdButtonText!, isPicture: imageInButtons, activityIndicator: &activityIndicatorThird)
        }
        addButtonActions()
        
        setConstraints(label: label!, imageView: imageView)
        
        
   //     setSizeButtonTitle()
        
    }
    
    func clouseAlert() {
        observer = nil
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }
    }
    
    
    //add blurView setup constraints and effects for blurView
    private func setupBlurView(view: UIView) {
     
        blurView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        let blurEffect = UIBlurEffect(style: .regular)
        blurView.effect = blurEffect
        
    }
    
    
    
    func startAnimating(firstButton: Bool = false, secondButton: Bool = false, thirdButton: Bool = false) {
      
        
        if firstButton && activityIndicatorFirst != nil && buttons.count >= 1 {
            activityIndicatorFirst?.isHidden = false
            activityIndicatorFirst?.startAnimating()
            buttons[0].isEnabled = false
        }
        if secondButton && activityIndicatorSecond != nil && buttons.count >= 2 {
            activityIndicatorSecond?.isHidden = false
            activityIndicatorSecond?.startAnimating()
            buttons[1].isEnabled = false
        }
        if thirdButton && activityIndicatorThird != nil && buttons.count >= 3 {
            activityIndicatorThird?.isHidden = false
            activityIndicatorThird?.startAnimating()
            buttons[2].isEnabled = false
        }
    }
    
    func stopAnimating(firstButton: Bool = false, secondButton: Bool = false, thirdButton: Bool = false) {
      
        if firstButton && activityIndicatorFirst != nil && buttons.count >= 1 {
            activityIndicatorFirst?.stopAnimating()
            activityIndicatorFirst?.isHidden = true
            buttons[0].isEnabled = true
        }
        if secondButton && activityIndicatorSecond != nil && buttons.count >= 2 {
            activityIndicatorSecond?.stopAnimating()
            activityIndicatorSecond?.isHidden = true
            buttons[1].isEnabled = true
        }
        if thirdButton && activityIndicatorThird != nil && buttons.count >= 3 {
            activityIndicatorThird?.stopAnimating()
            activityIndicatorThird?.isHidden = true
            buttons[2].isEnabled = true
        }
    }
    
    private func createLabel(in view: UIView, with text: String) -> UILabel {
        let label = UILabel()
        view.addSubview(label)
        label.text = text
        label.backgroundColor = .clear
        label.textAlignment = .center
        var fontSize = view.superview!.frame.height * 1/15
        if fontSize == 0 {
            fontSize = UIScreen.main.bounds.height * 1/15
        }
        print(fontSize)
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "AmericanTypewriter", size:  fontSize)
        label.textColor = #colorLiteral(red: 0.2688689828, green: 0.27911973, blue: 0.9976477027, alpha: 1)
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
    
    
    
    private func createButton(in view: UIView, with text: String, isPicture: Bool = false, activityIndicator: inout UIActivityIndicatorView?) {
        
        
        let button = UIButton()
        button.backgroundColor = .clear
        button.isEnabled = true
        
        if isPicture {
            button.setImage(UIImage(named: text), for: .normal)
            
           
        } else {
            button.setTitle(text, for: .normal)
            var fontSize = view.superview!.frame.height * 1/35
            if fontSize == 0 {
               fontSize = UIScreen.main.bounds.height * 1/35
            }

            var font = UIFont(name: "AmericanTypewriter", size: fontSize)
            
            if font == nil {
                font = UIFont.systemFont(ofSize: fontSize)
            }
            
            
            
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.minimumScaleFactor = 0.1
            
            let titleAttributesNormalState: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.font: font!, NSAttributedString.Key.foregroundColor: UIColor.purple
            ]
            let titleAttributesAssignState: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.font: font!, NSAttributedString.Key.foregroundColor: UIColor.blue
            ]
            
            let attributedStringNormal = NSMutableAttributedString(string: text, attributes: titleAttributesNormalState)
            let attributedStringAssigne = NSMutableAttributedString(string: text, attributes: titleAttributesAssignState)
            button.setAttributedTitle(attributedStringNormal, for: .normal)
            button.setAttributedTitle(attributedStringAssigne, for: .highlighted)
        }
        
        // insert activity indicator
            activityIndicator = UIActivityIndicatorView()
            button.addSubview(activityIndicator!)
            activityIndicator?.isHidden = true
            
            activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator?.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
            activityIndicator?.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
            
        
        
        if stackView == nil {
            stackView = UIStackView()
            view.addSubview(stackView!)
            stackView?.alignment = .center
            stackView?.distribution = .equalCentering
            stackView?.spacing = 20
            stackView?.backgroundColor = .clear
            //stackView!.isLayoutMarginsRelativeArrangement = false
        }
        stackView?.addArrangedSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: view.frame.width >= view.frame.height ? 1/5 : 1/3, constant: -10).isActive = true
        
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true

      
        buttons.append(button)
    }
   
    /*
    private func setSizeButtonTitle() {
        var size: CGFloat?
        for button in buttons {
            
            let fontSize = button.titleLabel?.font.xHeight
           // let scaleText = label?.scale
            print("scale: \(fontSize)")
            if size == nil {
                size = fontSize
                guard  size != nil else {
                    return
                }
            } else {
                guard fontSize != nil else {
                    return
                }
                size = size! <= fontSize! ? size : fontSize
            }
         
        }
      //  guard scale != nil, let sizeText = label?.font.pointSize else {
        //    return
        //}
    
        //let size = sizeText * scale!
        
        var font = UIFont(name: "AmericanTypewriter", size: size! * 1.5)
        
        if font == nil {
            font = UIFont.systemFont(ofSize: size!)
        }

        let titleAttributesNormalState: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: font!, NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        let titleAttributesAssignState: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: font!, NSAttributedString.Key.foregroundColor: UIColor.red
        ]
        
        
        
        for button in buttons {
            
            let text = button.titleLabel?.text
            guard  text != nil else {
                return
            }
            let attributedStringNormal = NSMutableAttributedString(string: text!, attributes: titleAttributesNormalState)
            let attributedStringAssigne = NSMutableAttributedString(string: text!, attributes: titleAttributesAssignState)
            button.setAttributedTitle(attributedStringNormal, for: .normal)
            button.setAttributedTitle(attributedStringAssigne, for: .highlighted)
        }
        
    }
*/
    
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
        
        guard stackView != nil else {
            return
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
        observer.buttonPressed(indexOfPressedButton: 0, identifire: alertIdentifire)
    }
    
    @objc func actionButtonSecond() {
        observer.buttonPressed(indexOfPressedButton: 1, identifire: alertIdentifire)
    }
    
    @objc func actionButtonThird() {
        observer.buttonPressed(indexOfPressedButton: 2, identifire: alertIdentifire)
    }
    
}
