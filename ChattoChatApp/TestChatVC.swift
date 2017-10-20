//
//  TestChatVC.swift
//  ChattoChatApp
//
//  Created by Alif on 15/10/2017.
//  Copyright © 2017 Alif. All rights reserved.
//

import UIKit
import Starscream

class TestChatVC: UIViewController, WebSocketDelegate {
    
    // u cant connect with my real server use this ip
    var socket = WebSocket(url: URL(string: "ws://localhost:8181/api/v1/chat")!, protocols: ["chat"])
    
    var username = ""
    var displayName = ""
    var avatar = ""
    var msg = ""
    
    // MARK: - IBOutlets

    @IBOutlet var textMsg: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        socket.delegate = self
        socket.connect()
        
        info()
    }
    
    func info() {
        print("UserDisAVA", username = "Alif", displayName = "Saroar", avatar = "Avatar")
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        socket.write(string: username)
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        // 1
        guard let data = text.data(using: .utf16),
            let jsonData = try? JSONSerialization.jsonObject(with: data),
            let jsonDict = jsonData as? [String: Any],
            let messageType = jsonDict["type"] as? String else {
                return
        }
        
        // 2
        if messageType == "message",
            let messageData = jsonDict["data"] as? [String: Any],
            let messageAuthor = messageData["author"] as? String,
            let messageText = messageData["text"] as? String {
            
            messageReceived(messageText, senderName: messageAuthor)
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received data: \(data.count)")
    }
    
    
    @IBAction func disconnect(_ sender: Any) {
        if socket.isConnected {
            print("Connect")
            socket.disconnect()
        } else {
            print("Disconnect")
            socket.connect()
        }
    }
    
    
}

extension TestChatVC {
    @IBAction func textMsgSend(_ sender: Any) {
        msg = textMsg.text!
        sendMessage(msg)
    }
    
}

extension TestChatVC {
    
    fileprivate func sendMessage(_ message: String) {
        socket.write(string: message)
    }
    
    fileprivate func messageReceived(_ message: String, senderName: String) {
        textMsg.text = message
        username = senderName
    }
}
