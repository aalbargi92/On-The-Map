//
//  LoginViewController.swift
//  On The Map
//
//  Created by Abdullah AlBargi on 24/10/2019.
//  Copyright © 2019 Abdullah AlBargi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: - Actions
    @IBAction func loginPressed(_ sender: Any) {
        hideAllErrors()
        setLoginIn(true)
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        var cancel = false
        
        
        if email.isEmpty {
            showErrorLabel("Please enter email", with: emailErrorLabel)
            cancel = true
        }
        
        if password.isEmpty {
            showErrorLabel("Please enter password", with: passwordErrorLabel)
            cancel = true
        }
        
        if cancel {
            setLoginIn(false)
            return
        }
        
        UdacityService.login(username: email, password: password, completion: hanldeLoginResponse(success:error:))
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        guard let url = URL(string: UdacityService.Endpoints.signUp.stringValue) else {
            print("Cannot open url")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func hanldeLoginResponse(success: Bool, error: Error?) {
        setLoginIn(false)
        if success {
            UdacityService.getUser(completion: handleUserResponse(success:error:))
        } else {
            showAlert(title: "Error", message: error!.localizedDescription)
        }
    }
    
    func handleUserResponse(success: Bool, error: Error?) {
        if success {
            performSegue(withIdentifier: "showMainScreen", sender: nil)
        } else {
            showAlert(title: "Error", message: error!.localizedDescription)
        }
    }
    
    // MARK: - Helpers
    func setLoginIn(_ loginIn: Bool) {
        emailTextField.isEnabled = !loginIn
        passwordTextField.isEnabled = !loginIn
        loginButton.isEnabled = !loginIn
        signupButton.isEnabled = !loginIn
        
        loginButton.showLoading(loginIn)
    }
    
    func showErrorLabel(_ message: String, with label: UILabel) {
        label.text = message
        label.isHidden = false
    }
    
    func hideAllErrors() {
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
    }
}

