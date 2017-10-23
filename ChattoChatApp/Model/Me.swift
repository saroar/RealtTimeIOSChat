//
//  Me.swift
//  ChattoChatApp
//
//  Created by Alif on 20/10/2017.
//  Copyright © 2017 Alif. All rights reserved.
//

import Foundation
import FirebaseAuth

class Me {
    static var uid: String {
        //return Auth.auth().currentUser!.uid
        return Auth.auth().currentUser!.uid
    }
}
