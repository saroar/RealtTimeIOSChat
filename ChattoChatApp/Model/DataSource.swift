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
    
    weak var delegate: ChatDataSourceDelegateProtocol?
    var controller = ChatItemController()
    var currentlyLoading = false
    
    init(initialMessages: [ChatItemProtocol], uid: String) {
        self.controller.initialMessages = initialMessages
        self.controller.userUID = uid
        self.controller.loadIntoItemArray(neededMsg: min(initialMessages.count, 50), moreToLoad: initialMessages.count > 50)
    }
    
    var hasMoreNext: Bool {
        return false
    }
    
    var hasMorePrevious: Bool {
        return controller.loadMore
    }
    
    var chatItems: [ChatItemProtocol] {
    
        return controller.items
    
    }
    
    func loadNext() {
        
    }
    
    func loadPrevious() {
        if currentlyLoading == false {
            currentlyLoading = true
            controller.loadPrevious() {
                self.delegate?.chatDataSourceDidUpdate(self, updateType: .pagination)
                self.currentlyLoading = false
            }
        }
        
    }
    
    func adjustNumberOfMessages(preferredMaxCount: Int?, focusPosition: Double, completion: (Bool) -> Void) {
        if focusPosition > 0.9 {
            self.controller.adjustWindow()
            completion(true)
        }else {
            completion(false)
        }
    
    }
    
    func addMessage(message: ChatItemProtocol) {
        
        self.controller.insertItem(message: message)
        self.delegate?.chatDataSourceDidUpdate(self)
    
    }
    
    func updateTextMessage(uid: String, status: MessageStatus) {
    
        if let index = self.controller.items.index(where: { (msg) -> Bool in
        
            return msg.uid == uid
        
        }) {
            
            let message = self.controller.items[index] as! TextModel
            message.status = status
            self.delegate?.chatDataSourceDidUpdate(self)
   
        }
    
    }
    

}
