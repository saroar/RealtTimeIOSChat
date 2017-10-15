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
    var socket = WebSocket(url: URL(string: "ws://46.101.189.163:8181/api/v1/chat")!, protocols: ["chat"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socket.delegate = self
        socket.connect()
    }
    
    // MARK: Websocket Delegate Methods.
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("Received text: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received data: \(data.count)")
    }
    
    // MARK: Write Text Action
    
    @IBAction func sendText(_ sender: Any) {
        socket.write(string: "hello there!")
    }
    
    // MARK: Disconnect Action
    
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
