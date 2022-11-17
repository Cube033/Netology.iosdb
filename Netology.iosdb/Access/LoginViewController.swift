//
//  LoginViewController.swift
//  Netology.iosdb
//
//  Created by Дмитрий Федотов on 11.11.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    private enum PasswordState {
        case emptyPassword
        case passwordSet
        case repeatPassword
    }
    
    private enum AlertAction {
        case none
        case clearPassword
    }
    
    private var passwordState: PasswordState = .emptyPassword
    
    private var firstPassword: String = ""
    
    private lazy var loginButton: UIButton = CustomButton(title: "Login", backgroundColor: nil, tapAction: {self.loginHandler()})
    
    lazy var passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.font = .systemFont(ofSize: 15)
        passwordTextField.autocapitalizationType = .none
        passwordTextField.backgroundColor = .systemGray6
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.leftView = .init(frame: .init(x: 0, y: 0, width: 5, height: passwordTextField.frame.height))
        passwordTextField.leftViewMode = .always
        passwordTextField.delegate = self
        return passwordTextField
    }()
    
    var coordinator: MainCoordinator
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        setConstraints()
        setPasswordState()
    }
    
    private func setPasswordState() {
        let keyChainResult: KeyChainResult = KeyChainService.shared.getPassword(login: "default", serviceName: "Netology.iosdb")
        switch keyChainResult {
        case .success(let currentPassword):
            passwordState = .passwordSet
            firstPassword = currentPassword
            loginButton.setTitle("Введите пароль", for: .normal)
        case .fault( _):
            passwordState = .emptyPassword
            loginButton.setTitle("Создать пароль", for: .normal)
        }
      }
    
    private func loginHandler() {
        let passwordText = passwordTextField.text ?? ""
        switch passwordState {
        case .emptyPassword:
            let numberOfCharacters = passwordText.count
            if numberOfCharacters < 4 {
                setAlert(errorMessage: "Длина пароля должна быть не менее 4 символов", extraAction: .none)
                return
            }
            firstPassword = passwordText
            passwordState = .repeatPassword
            loginButton.setTitle("Повторите пароль", for: .normal)
            passwordTextField.text = ""
        case .passwordSet:
            if passwordText == firstPassword, passwordText != "" {
                coordinator.handleAction(actionType: .successLogin)
            } else {
                setAlert(errorMessage: "Пароль введен не верно", extraAction: .none)
                passwordTextField.text = ""
                return
            }
        case .repeatPassword:
            if passwordText == firstPassword {
                let keyChainResult: KeyChainResult = KeyChainService.shared.addPassword(login: "default", password: passwordText, serviceName: "Netology.iosdb")
                switch keyChainResult {
                case .success( _):
                    coordinator.handleAction(actionType: .successLogin)
                case .fault(let errorText):
                    setAlert(errorMessage: errorText, extraAction: .none)
                    return
                }
            } else {
                setAlert(errorMessage: "Пароль не совпадает", extraAction: .clearPassword)
                passwordTextField.text = ""
            }
        }
    }
    
    private func setConstraints() {
        
        self.view.addSubview(self.passwordTextField)
        self.view.addSubview(self.loginButton)
        
        NSLayoutConstraint.activate([
            self.passwordTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            self.passwordTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.passwordTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            self.loginButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 20),
            self.loginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.loginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.loginButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func setAlert(errorMessage: String, extraAction: AlertAction) {
        let alert = UIAlertController(title: "Внимание", message: errorMessage, preferredStyle: .alert)
        let actionDismiss = UIAlertAction(title: "Закрыть", style: .default) { (_) -> Void in
            
        }
        if extraAction == .clearPassword {
            let actionClearPasswordEntry = UIAlertAction(title: "Ввести новый пароль", style: .default) { (_) -> Void in
                self.passwordState = .emptyPassword
                self.firstPassword = ""
                self.loginButton.setTitle("Создать пароль", for: .normal)
            }
            alert.addAction(actionClearPasswordEntry)
        }
        alert.addAction(actionDismiss)
        self.present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

