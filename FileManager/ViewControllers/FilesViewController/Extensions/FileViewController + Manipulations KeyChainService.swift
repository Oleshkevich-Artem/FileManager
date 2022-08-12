//
//  FileViewController + Manipulations KeyChainService.swift
//  FileManager
//
//  Created by Oleshkevich Artem on 2.07.22.
//

import UIKit

extension FilesViewController {
    private func showKeychainServiceEnterPasswordAllert() {
        let alertController = UIAlertController(title: "Locked!",
                                                message: "Please, enter your password",
                                                preferredStyle: .alert)
        
        alertController.addTextField {
            $0.placeholder = "Password"
            $0.isSecureTextEntry = true
        }
        
        let addAction = UIAlertAction(title: "Enter",
                                      style: .default,
                                      handler: { [weak self] _ in
            if let textFieldText = alertController.textFields?.first?.text {
                self?.checkPasswordVerificationOnKeyChainService(enteredPassword: textFieldText)
            }
            else {
                self?.showKeychainServiceEnterPasswordAllert()
            }
        })
        
        alertController.addAction(addAction)
        
        present(alertController, animated: true)
    }
    
    private func showKeychainServiceAddPasswordAllert() {
        let alertController = UIAlertController(title: "Create a password",
                                                message: "Please create a password",
                                                preferredStyle: .alert)
        
        alertController.addTextField {
            $0.placeholder = "New password"
            $0.isSecureTextEntry = false
        }
        
        let addAction = UIAlertAction(title: "Add",
                                      style: .default,
                                      handler: { [weak self] _ in
            if let textFieldText = alertController.textFields?.first?.text {
                self?.addPasswordOnKeyChainService(password: textFieldText)
                self?.checkVerificationStatus()
            }
            else {
                self?.showKeychainServiceAddPasswordAllert()
            }
        })
        
        alertController.addAction(addAction)
        
        present(alertController, animated: true)
    }
    
    private func checkContainsKeyChainServicePassword() {
        if KeychainService.shared.getPassword() != nil {
            self.showKeychainServiceEnterPasswordAllert()
        }
        else {
            self.showKeychainServiceAddPasswordAllert()
        }
    }
    
    private func addPasswordOnKeyChainService(password: String) {
        KeychainService.shared.setPassword(value: password)
    }
    
    private func checkPasswordVerificationOnKeyChainService(enteredPassword: String) {
        let savedPassword = KeychainService.shared.getPassword()
        
        if enteredPassword == savedPassword {
            self.verificationStatus = true
        }
        else {
            self.showWrongPasswordKeyChainServiceAlert()
        }
    }
    
    func checkVerificationStatus() {
        if self.verificationStatus == false {
            checkContainsKeyChainServicePassword()
        }
    }
    
    private func showWrongPasswordKeyChainServiceAlert() {
        let alertController = UIAlertController(title: "Oops!",
                                                message: "Wrong password, try again!",
                                                preferredStyle: .alert)
        
        let tryAgainAction = UIAlertAction(title: "Try again",
                                           style: .default,
                                           handler: { [weak self] _ in
            self?.showKeychainServiceEnterPasswordAllert()
        })
        
        alertController.addAction(tryAgainAction)
        
        present(alertController, animated: true)
    }
}
