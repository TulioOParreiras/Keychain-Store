//
//  UserModel.swift
//  Keychain Store
//
//  Created by Tulio Parreiras on 30/08/20.
//  Copyright © 2020 Tulio Parreiras. All rights reserved.
//

import Foundation

final class UserModel {
    
    var name: String
    var email: String
    var fullAddres: String
    var city: String
    var state: String
    var country: String
    
    init(name: String, email: String, fullAddres: String, city: String, state: String, country: String) {
        self.name = name
        self.email = email
        self.fullAddres = fullAddres
        self.city = city
        self.state = state
        self.country = country
    }
    
}
