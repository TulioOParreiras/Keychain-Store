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
        self.clearUserData()
    }
    
    @IBAction func buttonSaveAction(_ sender: UIButton) {
        self.saveUserModel()
    }
    
    // MARK: - Properties
    
    private var userModel = UserModel()
    private let userModelKey: String = String(describing: UserModel.self)
    private lazy var textFields: [UITextField] = {
       return [self.textFieldName, self.textFieldEmail, self.textFieldFullAddress, self.textFieldCity, self.textFieldState, self.textFieldCountry]
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUserModel()
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
    
    // MARK: - Keychain

    func initUserModel() {
        KeychainStore.loadData(forKey: self.userModelKey) { result in
            switch result {
            case let .success(data):
                self.decodeUserModel(fromData: data)
            case .failure:
                print("Failed to load ", self.userModelKey, " from keychain")
            }
        }
    }
    
    func decodeUserModel(fromData data: Data) {
        do {
            let userModel = try JSONDecoder().decode(UserModel.self, from: data)
            self.updateUserModel(with: userModel)
        } catch {
            print("Failed to decode", self.userModelKey, " with error: ", error)
        }
    }
    
    func updateUserModel(with userModel: UserModel) {
        self.userModel = userModel
        self.textFieldName.text = userModel.name
        self.textFieldEmail.text = userModel.email
        self.textFieldFullAddress.text = userModel.fullAddres
        self.textFieldCity.text = userModel.city
        self.textFieldState.text = userModel.state
        self.textFieldCountry.text = userModel.country
    }
    
    func saveUserModel() {
        do {
            let data = try JSONEncoder().encode(self.userModel)
            KeychainStore.save(data: data, forKey: self.userModelKey) { result in
                switch result {
                case .success:
                    print("Saved ", self.userModelKey, " successfully")
                case let .failure(error):
                    print("Failed to save ", self.userModelKey, " with error: ", error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func clearUserData() {
        KeychainStore.deleteCache(forKey: self.userModelKey) { result in
            switch result {
            case .success:
                self.textFields.forEach { $0.text = nil }
                self.userModel = .init()
            case let .failure(error):
                print("Failed to remove ", self.userModelKey, " from Keychain with error: ", error)
            }
        }
    }
    
    // MARK: - General Methods
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        switch textField {
        case self.textFieldName:
            self.userModel.name = text
        case self.textFieldEmail:
            self.userModel.email = text
        case self.textFieldFullAddress:
            self.userModel.fullAddres = text
        case self.textFieldCity:
            self.userModel.city = text
        case self.textFieldState:
            self.userModel.state = text
        case self.textFieldCountry:
            self.userModel.country = text
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
            self.saveUserModel()
        default:
            textFields[index + 1].becomeFirstResponder()
        }
        return true
    }
    
}
