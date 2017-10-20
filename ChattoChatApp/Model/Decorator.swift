//
//  Decorator.swift
//  ChattoChatApp
//
//  Created by Alif on 12/10/2017.
//  Copyright © 2017 Alif. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class Decorator: ChatItemsDecoratorProtocol {
    
    func decorateItems(_ chatItems: [ChatItemProtocol]) -> [DecoratedChatItem] {
        
        var decoratedItems = [DecoratedChatItem]()
        
        for item in chatItems {
            
            let decoratedItem = DecoratedChatItem(chatItem: item, decorationAttributes: ChatItemDecorationAttributes(bottomMargin: 3, canShowTail: false, canShowAvatar: true, canShowFailedIcon: false))
            decoratedItems.append(decoratedItem)
        
        }
        
        return decoratedItems
    
    }
}
