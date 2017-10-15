//
//  ChatItemController.swift
//  ChattoChatApp
//
//  Created by Alif on 12/10/2017.
//  Copyright © 2017 Alif. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class ChatItemController {
    
    var items = [ChatItemProtocol]()
    
    func insertItem(message: ChatItemProtocol) {
        
        self.items.append(message)
    
    }

}
