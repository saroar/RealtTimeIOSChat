//
//  ViewController.swift
//  ChattoChatApp
//
//  Created by Alif on 12/10/2017.
//  Copyright © 2017 Alif. All rights reserved.
//

import UIKit
import Chatto
import ChattoAdditions
import Starscream

class ChatLogController: BaseChatViewController {    
    var presenter: BasicChatInputBarPresenter!
    var dataSource = DataSource()
    var decorator = Decorator()

    override func viewDidLoad() {
    
        super.viewDidLoad()
        self.chatDataSource = dataSource
        self.chatItemsDecorator = self.decorator
    
    }

    override func didReceiveMemoryWarning() {
    
        super.didReceiveMemoryWarning()
    
    }
    
    override func createPresenterBuilders() -> [ChatItemType : [ChatItemPresenterBuilderProtocol]] {
        
        let textMessageBuilder = TextMessagePresenterBuilder(viewModelBuilder: TextBuilder(), interactionHandler: TextHandler())
        return [TextModel.chatItemType : [textMessageBuilder]]
    
    }
    
    override func createChatInputView() -> UIView {
    
        let inputBar = ChatInputBar.loadNib()
        var appearance = ChatInputBarAppearance()
        appearance.sendButtonAppearance.title = "Send"
        appearance.textInputAppearance.placeholderText = "Type a message"
        self.presenter = BasicChatInputBarPresenter(chatInputBar: inputBar, chatInputItems: [handleSend()] , chatInputBarAppearance: appearance)
        return inputBar
   
    }
    
    func handleSend() -> TextChatInputItem {
        
        let item = TextChatInputItem()
        
        item.textInputHandler = { [ weak self ] text in
            let date = Date()
            let double = Double(date.timeIntervalSinceReferenceDate)
            let senderID = "me"
            
            let message = MessageModel(uid: "(\(double, senderID))", senderId: senderID, type: TextModel.chatItemType, isIncoming: false, date: date, status: .success)
            let textMessage = TextModel(messageModel: message, text: text)
            self?.dataSource.addTextMessage(message: textMessage)
        }
        

        return item
    
    }

}
