//
//  LoginViewController.swift
//  lab-insta-parse
//
//  Created by Leonardo Villalobos on 3/6/23.
//

import UIKit
import ParseSwift

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var loginErrorLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        loginErrorLabel.isHidden = true
        hideSpinner()
    }
    
    // MARK: IBActions
    @IBAction func onLoginTapped(_ sender: Any) {
        guard let username = usernameField.text,
            let password = passwordField.text,
            !username.isEmpty,
            !password.isEmpty else
        {
            missingFieldsErrorsAreHidden(false)
            return
        }
        
        missingFieldsErrorsAreHidden(true)
        showSpinner()
        User.login(username: username, password: password) { [self] result in
            switch result {
            case .success(_):
                UIView.animate(withDuration: 0.2, delay: 0) { [weak self] in
                    self?.loginErrorLabel.isHidden = true
                }
                DispatchQueue.main.async {
                    NotificationCenter.default.post(
                        name: Notification.Name("login"),
                        object: nil
                    )
                }
            case .failure(let error):
                hideSpinner()
                loginErrorLabel.text = error.message
                UIView.animate(withDuration: 0.2, delay: 0) { [weak self] in
                    self?.loginErrorLabel.isHidden = false
                }
            }
        }
    }

    // MARK: Private helpers
    private func missingFieldsErrorsAreHidden(_ state: Bool) {
        UIView.animate(withDuration: 0.2, delay: 0) { [self] in
            passwordErrorLabel.isHidden = passwordField.hasText || state
            usernameErrorLabel.isHidden = usernameField.hasText || state
        }
    }
    
    private func showSpinner() {
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
    }
    
    private func hideSpinner() {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
    }
}
