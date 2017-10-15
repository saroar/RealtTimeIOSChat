//
//  TextModel.swift
//  ChattoChatApp
//
//  Created by Alif on 12/10/2017.
//  Copyright © 2017 Alif. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions
    
class TextModel: TextMessageModel<MessageModel> {

    static let  chatItemType = "text"
    
    override init(messageModel: MessageModel, text: String) {
    
        super.init(messageModel: messageModel, text: text)
    
    }
}
