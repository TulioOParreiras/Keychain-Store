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
    }
    
}

