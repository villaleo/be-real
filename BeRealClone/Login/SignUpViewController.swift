//
//  SignUpViewController.swift
//  lab-insta-parse
//
//  Created by Leonardo Villalobos on 3/6/23.
//

import UIKit
import ParseSwift

class SignUpViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var signupErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        missingFieldsErrorsAreHidden(true)
        signupErrorLabel.isHidden = true
    }

    // MARK: IBActions
    @IBAction func onSignUpTapped(_ sender: Any) {
        guard let username = usernameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              !username.isEmpty,
              !email.isEmpty,
              !password.isEmpty else
        {
            missingFieldsErrorsAreHidden(false)
            return
        }
        
        missingFieldsErrorsAreHidden(true)
        let user = User(username: username, email: email, password: password)
        user.signup { [weak self] result in
            switch result {
            case .success(_):
                UIView.animate(withDuration: 0.2, delay: 0) { [weak self] in
                    self?.signupErrorLabel.isHidden = true
                }
                DispatchQueue.main.async {
                    NotificationCenter.default.post(
                        name: Notification.Name("login"),
                        object: nil
                    )
                }
            case .failure(let error):
                self?.signupErrorLabel.text = error.message
                UIView.animate(withDuration: 0.2, delay: 0) { [weak self] in
                    self?.signupErrorLabel.isHidden = false
                }
            }
        }
    }

    // MARK: Private helpers
    private func missingFieldsErrorsAreHidden(_ state: Bool) {
        UIView.animate(withDuration: 0.2, delay: 0) { [self] in
            emailErrorLabel.isHidden = passwordField.hasText || state
            usernameErrorLabel.isHidden = usernameField.hasText || state
            passwordErrorLabel.isHidden = passwordField.hasText || state
        }
    }
}
