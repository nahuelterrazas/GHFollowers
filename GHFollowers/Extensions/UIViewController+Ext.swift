//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Nahuel Terrazas on 20/06/2023.
//

import UIKit
import SafariServices

var containerView: UIView!

extension UIViewController {
    func presentGFAlert(title: String, message: String, buttonTitle: String){
        let alertVC = GFAlertVC(alertTitle: title, message: message, buttonTitle: buttonTitle)
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        self.present(alertVC, animated: true)
    }
    
    
    func presentDefaultError(){
        let alertVC = GFAlertVC(alertTitle: "Something went wrong",
                                message: "we were unable to complete your task at this time. Please try again.",
                                buttonTitle: "Ok")
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        self.present(alertVC, animated: true)
    }
    
    
    func presentGFAlertAndPopVCOnMainThread(title: String, message: String, buttonTitle: String){
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(alertTitle: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }

    
    func presentSafariVC(url: URL){
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}

