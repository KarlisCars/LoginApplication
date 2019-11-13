//
//  Users.swift
//  LoginApplication
//
//  Created by Karlis Cars on 12/11/2019.
//  Copyright © 2019 Karlis Cars. All rights reserved.
//

import Foundation
import Firebase

class Users{
    let uid: String
    let email: String
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
    }
}
