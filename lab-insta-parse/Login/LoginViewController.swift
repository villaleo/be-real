//
//  LoginViewController.swift
//  lab-insta-parse
//
//  Forked from Charlie Hieger on 11/1/22.
//  Created by Leonardo Villalobos on 3/2/23.
//

import UIKit
import ParseSwift

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var loginErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        loginErrorLabel.isHidden = true
    }
    
    // MARK: IBActions
    @IBAction func onLoginTapped(_ sender: Any) {
        guard let username = usernameField.text,
            let password = passwordField.text,
            !username.isEmpty,
            !password.isEmpty else
        {
            animateErrorLabels(areHidden: false)
            return
        }
        
        animateErrorLabels(areHidden: true)
        User.login(username: username, password: password) { result in
            switch result {
            case .success(let user):
                print("Logged in as \(user)")
                NotificationCenter.default.post(
                    name: Notification.Name("login"),
                    object: nil
                )
            case .failure(let error):
                self.loginErrorLabel.text = error.description
                UIView.animate(withDuration: 0.2, delay: 0) { [self] in
                    self.loginErrorLabel.isHidden = false
                }
            }
        }
    }

    // MARK: Private helpers
    private func animateErrorLabels(areHidden: Bool) {
        UIView.animate(withDuration: 0.2, delay: 0) { [self] in
            self.passwordErrorLabel.isHidden = self.passwordField.hasText || areHidden
            self.usernameErrorLabel.isHidden = self.usernameField.hasText || areHidden
        }
    }
}
