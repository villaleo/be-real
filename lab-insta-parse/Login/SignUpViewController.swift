//
//  SignUpViewController.swift
//  lab-insta-parse
//
//  Forked from Charlie Hieger on 11/1/22.
//  Created by Leonardo Villalobos on 3/2/23.
//

import UIKit
import ParseSwift

class SignUpViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
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
            showMissingFieldsAlert()
            return
        }
        let user = User(username: username, email: email, password: password)
        user.signup { [weak self] result in
            switch result {
            case .success(let user):
                print("Successfuly signed up User: \(user)")
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
            title: "Unable to Sign Up",
            message: description ?? "Unknown error",
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }

    private func showMissingFieldsAlert() {
        let alertController = UIAlertController(
            title: "Opps...",
            message: "We need all fields filled out in order to sign you up.",
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
