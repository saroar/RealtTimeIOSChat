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
        let calender = Calendar.current
        
        for (index, item) in chatItems.enumerated() {
            
            var addTimestamp = false
            var showTail = false
            let nextMessage: ChatItemProtocol? = (index + 1 < chatItems.count) ? chatItems[index + 1] : nil
            let previousMessage: ChatItemProtocol? = (index > 0) ? chatItems[index - 1] : nil
            
            if let previousMessage = previousMessage as? MessageModelProtocol {
                
                addTimestamp = !calender.isDate((item as! MessageModelProtocol).date , inSameDayAs: previousMessage.date)
                
            } else {
                addTimestamp = true
            }
            
            if addTimestamp == true {
                let timeSepatorModel = TimeSeparatorModel(uid: UUID().uuidString, date: (item as! MessageModelProtocol).date.toWeekDayAndDateString())
                decoratedItems.append(DecoratedChatItem(chatItem: timeSepatorModel, decorationAttributes: nil))
            }
            
            if let nextMessage = nextMessage as? MessageModelProtocol {
                showTail = (item as! MessageModelProtocol).senderId != nextMessage.senderId
            } else {
                showTail = true
            }
            
            let buttomMargin = separationAfterItem(current: item, next: nextMessage)
            let decoratedItem = DecoratedChatItem(chatItem: item, decorationAttributes: ChatItemDecorationAttributes(bottomMargin: buttomMargin, canShowTail: showTail, canShowAvatar: showTail, canShowFailedIcon: false))
            decoratedItems.append(decoratedItem)
            
            if let status = (item as? MessageModelProtocol)?.status, status != .success {
                let statusModel = SendingStatusModel(uid: UUID().uuidString, status: status)
                decoratedItems.append(DecoratedChatItem(chatItem: statusModel, decorationAttributes: nil))
            }
        
        }
        
        return decoratedItems
    
    }
    
    func separationAfterItem(current: ChatItemProtocol?, next: ChatItemProtocol?) -> CGFloat {
        guard let next = next else { return 0 }
        
        let currentMessage = current as? MessageModelProtocol
        let nextMessage = next as? MessageModelProtocol
        
        if let status = currentMessage?.status, status != .success {
          return 10
        } else if currentMessage?.senderId != nextMessage?.senderId {
            return 10
        } else {
            return 3
        }
    }
}
