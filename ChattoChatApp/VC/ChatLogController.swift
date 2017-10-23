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
import FirebaseDatabaseUI
import SwiftyJSON
import FirebaseStorage
import Kingfisher

class ChatLogController: BaseChatViewController, FUICollectionDelegate {
    var presenter: BasicChatInputBarPresenter!
    var dataSource: DataSource!
    var decorator = Decorator()
    var userUID = String()
    var messageArray: FUIArray!
    
    var username = ""
    var displayName = ""
    var avatar = ""

    override func viewDidLoad() {
    
        super.viewDidLoad()
        self.chatDataSource = dataSource
        self.chatItemsDecorator = self.decorator
        self.constants.preferredMaxMessageCount = 300
        self.messageArray.observeQuery()
        self.messageArray.delegate = self
    
    
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
        
        textMessageBuilder.baseMessageStyle = Avatar()
        photoMessageBuilder.baseCellStyle = Avatar()
        
        return [
            TextModel.chatItemType : [textMessageBuilder],
            PhotoModel.chatItemType: [photoMessageBuilder],
            TimeSeparatorModel.chatItemType: [TimeSeparatorPresenterBuilder()],
            SendingStatusModel.chatItemType: [SendingStatusPresenterBuilder()]
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
            
            let date = Date()
            let double = Double(date.timeIntervalSinceReferenceDate)
            let senderID = Me.uid
            let msgUID = ("\(double)" + senderID ).replacingOccurrences(of: ".", with: "")
            
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

        return item
    
    }
    
    func handlePhoto() -> PhotosChatInputItem {
        
        let item = PhotosChatInputItem(presentingController: self)
        
        item.photoInputHandler = { [ weak self ] photo in
            
            let date = Date()
            let double = date.timeIntervalSinceReferenceDate
            let senderID = Me.uid
            let msgUID = ("\(double)" + senderID ).replacingOccurrences(of: ".", with: "")
            
            let message = MessageModel(
                uid: msgUID,
                senderId: senderID,
                type: PhotoModel.chatItemType,
                isIncoming: false,
                date: date,
                status: .sending
            )
            
            let photoMessage = PhotoModel(messageModel: message, imageSize: photo.size, image: photo)
            self?.dataSource.addMessage(message: photoMessage)
            self?.uploadToStorage(photo: photoMessage)
            
        }
        
        return item
    }
    
    func uploadToStorage(photo: PhotoModel) {
        let imageName = photo.uid
        let storage = Storage.storage().reference().child("images").child(imageName)
        let data = UIImagePNGRepresentation(photo.image)
        storage.putData(data!, metadata: nil) { [weak self] (metadata, error) in
            if let imageURL = metadata?.downloadURL()?.absoluteString {
                self?.sendOnilneImageMessage(photoMessage: photo, imageURL: imageURL)
            } else {
                self?.dataSource.updatePhotoMessage(uid: photo.uid, status: .failed)
            }
        }
    }
    
    func sendOnilneImageMessage(photoMessage: PhotoModel, imageURL: String) {
        let message = ["image": imageURL, "uid": photoMessage.uid, "date": photoMessage.date.timeIntervalSinceReferenceDate, "senderId": photoMessage.senderId, "status": "success", "type": PhotoModel.chatItemType] as [String : Any]
        
        let childUpdates = ["User-messages/\(photoMessage.senderId)/\(self.userUID)/\(photoMessage.uid)": message,
                            "User-messages/\(self.userUID)/\(photoMessage.senderId)/\(photoMessage.uid)": message,
                            "Users/\(Me.uid)/Contacts/\(self.userUID)/lastMessage": message,
                            "Users/\(self.userUID)/Contacts/\(Me.uid)/lastMessage": message,
                            ]
        
        Database.database().reference().updateChildValues(childUpdates) { [weak self] (error, _) in
            if error != nil {
                self?.dataSource.updatePhotoMessage(uid: photoMessage.uid, status: .failed)
                return
            }
            
            self?.dataSource.updatePhotoMessage(uid: photoMessage.uid, status: .success)
        }
    }

    func sendOnlineTextMsg(text: String, uid: String, double: Double, senderId: String) {
        let msg = [
            "text": text, "uid": uid, "date": double, "senderId": senderId,
            "type": TextModel.chatItemType, "status": "success"
        ] as [String: Any]
        
        let childUpdates = [
            "User-messages/\(senderId)/\(self.userUID)/\(uid)": msg,
            "User-messages/\(self.userUID)/\(senderId)/\(uid)": msg,
            "Users/\(Me.uid)/Contacts/\(self.userUID)/lastMessage": msg,
            "Users/\(self.userUID)/Contacts/\(Me.uid)/lastMessage": msg
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

extension ChatLogController {
    func array(_ array: FUICollection, didAdd object: Any, at index: UInt) {
        
        let message = JSON((object as! DataSnapshot).value as Any)
        let type = message["type"].stringValue
        let uid = message["uid"].stringValue
        let contains = self.dataSource.controller.items.contains { (collectionViewMessage) -> Bool in
            return collectionViewMessage.uid == message["uid"].stringValue
        }
        
        if contains == false {
            let senderId = message["senderId"].stringValue
            let model = MessageModel(
                uid: uid,
                senderId: senderId,
                type: type,
                isIncoming: senderId == Me.uid ? false : true,
                date: Date(timeIntervalSinceReferenceDate: message["date"].doubleValue),
                status: message["status"] == "success" ? MessageStatus.success : MessageStatus.sending
            )
            
            if type == TextModel.chatItemType {
                let textMessage = TextModel(messageModel: model, text: message["text"].stringValue)
                self.dataSource.addMessage(message: textMessage)
            } else if type == PhotoModel.chatItemType {
                KingfisherManager.shared.retrieveImage(
                    with: URL(string: message["image"].stringValue)!,
                    options: nil,
                    progressBlock: nil,
                    completionHandler: { [weak self] (image, error, _, _) in
                    
                    if error != nil {
                        self?.alert(message: "error receiving image from friend")
                    } else {
                        
                        let photoMessage = PhotoModel(messageModel: model, imageSize: image!.size, image: image!)
                        self?.dataSource.addMessage(message: photoMessage)
                    }
                })
            }
            
        }
    }
}
