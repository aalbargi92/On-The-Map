//
//  UIViewControllerExtension.swift
//  On The Map
//
//  Created by Abdullah AlBargi on 25/10/2019.
//  Copyright © 2019 Abdullah AlBargi. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showAddInfoViewController(_ sender: Any?) {
        let addInfoViewController = storyboard!.instantiateViewController(withIdentifier: "AddInfoViewController")
        addInfoViewController.modalPresentationStyle = .fullScreen
        
        if UdacityService.Auth.objectId != "" {
            let alert = UIAlertController(title: "Already exists", message: "A Student location already exists", preferredStyle: .alert)
            alert.addAction(.init(title: "Override", style: .default, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
                self.present(addInfoViewController, animated: true, completion: nil)
            }))
            alert.addAction(.init(title: "Cancel", style: .cancel, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        } else {
            present(addInfoViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func dismiss(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logout(_ sender: Any?) {
        UdacityService.logout(completion: handleLogoutResponse(success:error:))
    }
    
    func handleLogoutResponse(success: Bool, error: Error?) {
        if success {
            UdacityService.Auth.userId = ""
            UdacityService.Auth.user = nil
            UdacityService.Auth.objectId = ""
            dismiss(nil)
        } else {
            showAlert(title: "Error", message: error!.localizedDescription)
        }
    }
}
