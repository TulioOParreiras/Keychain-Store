//
//  UserModel.swift
//  Keychain Store
//
//  Created by Tulio Parreiras on 30/08/20.
//  Copyright © 2020 Tulio Parreiras. All rights reserved.
//

import Foundation

final class UserModel: Encodable, Decodable {
    
    var name: String?
    var email: String?
    var fullAddres: String?
    var city: String?
    var state: String?
    var country: String?
    
}
