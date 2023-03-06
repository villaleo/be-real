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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
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
        User.login(username: username, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                print("Logged in as \(user)")
                NotificationCenter.default.post(
                    name: Notification.Name("login"),
                    object: nil
                )
            case .failure(let error):
                self?.showAlert(description: error.localizedDescription)
            }
        }
    }

    // MARK: Private helpers
    private func showAlert(description: String?) {
        let alertController = UIAlertController(
            title: "Unable to Log in",
            message: description ?? "Unknown error",
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }

    private func animateErrorLabels(areHidden: Bool) {
        UIView.animate(withDuration: 0.2, delay: 0) { [self] in
            self.passwordErrorLabel.isHidden = self.passwordField.hasText || areHidden
            self.usernameErrorLabel.isHidden = self.usernameField.hasText || areHidden
        }
    }
}
