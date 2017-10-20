//
//  PhotoModel.swift
//  ChattoChatApp
//
//  Created by Alif on 17/10/2017.
//  Copyright © 2017 Alif. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class PhotoModel: PhotoMessageModel<MessageModel> {
    
    static let chatItemType = "photo"
    
    override init(messageModel: MessageModel, imageSize: CGSize, image: UIImage) {
    
        super.init(messageModel: messageModel, imageSize: imageSize, image: image)
    
    }
}
