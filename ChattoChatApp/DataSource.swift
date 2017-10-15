//
//  DataSource.swift
//  ChattoChatApp
//
//  Created by Alif on 12/10/2017.
//  Copyright © 2017 Alif. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class DataSource: ChatDataSourceProtocol {
    
    var controller = ChatItemController()
    
    var hasMoreNext: Bool {
        return false
    }
    
    var hasMorePrevious: Bool {
        return false
    }
    
    var delegate: ChatDataSourceDelegateProtocol?
    
    var chatItems: [ChatItemProtocol] {
    
        return controller.items
    
    }
    
    func loadNext() {
        
    }
    
    func loadPrevious() {
        
    }
    
    func adjustNumberOfMessages(preferredMaxCount: Int?, focusPosition: Double, completion: (Bool) -> Void) {
    
        completion(false)
    
    }
    
    func addTextMessage(message: ChatItemProtocol) {
        
        self.controller.insertItem(message: message)
        self.delegate?.chatDataSourceDidUpdate(self)
    
    }

}
