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
import FirebaseAuth
import FirebaseDatabase

class ChatLogController: BaseChatViewController {    
    var presenter: BasicChatInputBarPresenter!
    var dataSource: DataSource!
    var decorator = Decorator()
    var userUID = String()
    
    var username = ""
    var displayName = ""
    var avatar = ""

    override func viewDidLoad() {
    
        super.viewDidLoad()
    

        self.chatDataSource = dataSource
        self.chatItemsDecorator = self.decorator
        self.constants.preferredMaxMessageCount = 300
    
    }

    deinit {
        print("DEINIT")
    }
    
    override func didReceiveMemoryWarning() {
    
        super.didReceiveMemoryWarning()
        
    }
    
    override func createPresenterBuilders() -> [ChatItemType : [ChatItemPresenterBuilderProtocol]] {
        
        let textMessageBuilder = TextMessagePresenterBuilder(viewModelBuilder: TextBuilder(), interactionHandler: TaxtHandler())
        
        
        let photoMessageBuilder = PhotoMessagePresenterBuilder(viewModelBuilder: PhotoBuilder(), interactionHandler: PhotoHandler())
        
        return [
            TextModel.chatItemType : [textMessageBuilder],
            PhotoModel.chatItemType: [photoMessageBuilder]
        ]
    
    }
    
    override func createChatInputView() -> UIView {
    
        let inputBar = ChatInputBar.loadNib()
        var appearance = ChatInputBarAppearance()
        appearance.sendButtonAppearance.title = "Send"
        appearance.textInputAppearance.placeholderText = "Type a message"
        self.presenter = BasicChatInputBarPresenter(
            chatInputBar: inputBar,
            chatInputItems: [handleSend(), handlePhoto()],
            chatInputBarAppearance: appearance
        )
        return inputBar
   
    }
    
    func handleSend() -> TextChatInputItem {
        
        let item = TextChatInputItem()
        
        item.textInputHandler = { [ weak self ] text in
            
            for i in 1...201 {
                let text = "\(i)"
                let date = Date()
                let double = Double(date.timeIntervalSinceReferenceDate)
                let senderID = Me.uid
                let msgUID = (senderID + "\(double)").replacingOccurrences(of: ".", with: "")
                
                let message = MessageModel(
                    uid: msgUID,
                    senderId: senderID,
                    type: TextModel.chatItemType,
                    isIncoming: false,
                    date: date,
                    status: .sending
                )
                
                let textMessage = TextModel(messageModel: message, text: text)
                self?.dataSource.addMessage(message: textMessage)
                self?.sendOnlineTextMsg(text: text, uid: msgUID, double: double, senderId: senderID)
            }
            
            
        }

        return item
    
    }
    
    func handlePhoto() -> PhotosChatInputItem {
        
        let item = PhotosChatInputItem(presentingController: self)
        
        item.photoInputHandler = { [ weak self ] photo in
            
            let date = Date()
            let double = Double(date.timeIntervalSinceReferenceDate)
            let senderID = "me"
            
            let message = MessageModel(uid: "\(double, senderID)", senderId: senderID, type: PhotoModel.chatItemType, isIncoming: false, date: date, status: .success)
            let photoMessage = PhotoModel(messageModel: message, imageSize: photo.size, image: photo)
            self?.dataSource.addMessage(message: photoMessage)
            
        }
        
        return item
    }

    func sendOnlineTextMsg(text: String, uid: String, double: Double, senderId: String) {
        let msg = ["text": text, "uid": uid, "date": double, "senderId": senderId, "type": TextModel.chatItemType, "status": "success"] as [String: Any]
        let childUpdates = [
            "User-messages/\(senderId)/\(self.userUID)/\(uid)": msg,
            "User-messages/\(self.userUID)/\(senderId)/\(uid)": msg
        ]
        
        Database.database().reference().updateChildValues(childUpdates) { (error, _) in
            if error != nil {
                self.dataSource.updateTextMessage(uid: uid, status: .failed)
                return
            }
            
            self.dataSource.updateTextMessage(uid: uid, status: .success)
        
        }
        
    }
    
}
