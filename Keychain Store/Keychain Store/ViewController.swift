//
//  ViewController.swift
//  Keychain Store
//
//  Created by Tulio Parreiras on 30/08/20.
//  Copyright © 2020 Tulio Parreiras. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldFullAddress: UITextField!
    @IBOutlet weak var textFieldCity: UITextField!
    @IBOutlet weak var textFieldState: UITextField!
    @IBOutlet weak var textFieldCountry: UITextField!
    
    @IBOutlet weak var buttonClear: UIButton!
    @IBOutlet weak var buttonSave: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func buttonClearAction(_ sender: UIButton) {
        
    }
    
    @IBAction func buttonSaveAction(_ sender: UIButton) {
        
    }
    
    // MARK: - Properties
    
    let userModel = UserModel()
    
    lazy var textFields: [UITextField] = {
       return [self.textFieldName, self.textFieldEmail, self.textFieldFullAddress, self.textFieldCity, self.textFieldState, self.textFieldCountry]
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }


}

private extension ViewController {
    
    // MARK: - Setup UI
    
    func setupUI() {
        [self.buttonClear, self.buttonSave].forEach {
            $0?.layer.cornerRadius = 6
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = $0?.tintColor.cgColor
        }
        self.textFields.forEach {
            $0.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
            $0.delegate = self
        }
    }
    
    // MARK: - General Methods
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        switch textField {
        case self.textFieldName:
            self.userModel.name = text
        case self.textFieldEmail:
            self.userModel.name = text
        case self.textFieldFullAddress:
            self.userModel.name = text
        case self.textFieldCity:
            self.userModel.name = text
        case self.textFieldState:
            self.userModel.state = text
        case self.textFieldCountry:
            self.userModel.name = text
        default: break
        }
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let index = self.textFields.firstIndex(where: { $0 == textField }) else { return true }
        switch index {
        case textFields.count - 1:
            textField.resignFirstResponder()
        default:
            textFields[index + 1].becomeFirstResponder()
        }
        return true
    }
    
}
