//
//  MessageTableVC.swift
//  ChattoChatApp
//
//  Created by Alif on 19/10/2017.
//  Copyright © 2017 Alif. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftyJSON
import FirebaseDatabase
import FirebaseDatabaseUI
import Chatto

class MessageTableVC: UIViewController, FUICollectionDelegate, UITableViewDelegate, UITableViewDataSource {

    let conteacts = FUIArray(query: Database.database().reference().child("Users").child(Me.uid).child("Contacts"))
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.conteacts.observeQuery()
        self.conteacts.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        Database.database().reference().child("User-message").child(Me.uid).keepSynced(true)

    }
    
    deinit {
        print("DEINIT")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func Add(_ sender: Any) {
        self.presentAlert()
    }
    
    @IBAction func SignOut(_ sender: Any) {
        try! Auth.auth().signOut()
        self.navigationController?.popToRootViewController(animated: true)
    }

    func presentAlert() {
        let alertController = UIAlertController(title: "Email?", message: "Please write the email:", preferredStyle: .alert)
        alertController.addTextField { (textField ) in
            textField.placeholder = "Email"
        }
        
        let cancelAction  = UIAlertAction(title: "Cancel",  style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] (_) in
            
            if let email = alertController.textFields?[0].text {
                self?.addContact(email: email)
            }
        
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func addContact(email: String)  {
        Database.database().reference().child("Users").observeSingleEvent(of: .value, with: { [ weak self ] (snapshot) in
            let snapshot = JSON(snapshot.value as Any).dictionaryValue
            if let index = snapshot.index(where: { (key, value) -> Bool in
                return value["email"].stringValue == email
            }) {
                Database.database().reference().child("Users").child(Me.uid).child("Contacts").child(snapshot[index].key).updateChildValues(["email" : snapshot[index].value["email"].stringValue, "name": snapshot[index].value["name"].stringValue])
                
                
                    let allUpdates = [

                    "/Users/\(Me.uid)/Contacts/\(snapshot[index].key)": ([
                        "email" : snapshot[index].value["email"].stringValue,
                        "name": snapshot[index].value["name"].stringValue]),
                    
                    "/Users/\(snapshot[index].key)/Contacts/\(Me.uid)": ([
                        "email" : Auth.auth().currentUser!.email!,
                        "name": Auth.auth().currentUser!.displayName!])

                    ]
                
                    Database.database().reference().updateChildValues(allUpdates)
                    self?.alert(message: "success")
                
            } else {
                
                self?.alert(message: "No such email")
            
            }
        })
    }
}

extension MessageTableVC {
    
    func array(_ array: FUICollection, didAdd object: Any, at index: UInt) {
    
        self.tableView.insertRows(at: [IndexPath(row: Int(index), section: 0)], with: .automatic)
    
    }
    
    func array(_ array: FUICollection, didMove object: Any, from fromIndex: UInt, to toIndex: UInt) {
    
        self.tableView.insertRows(at: [IndexPath(row: Int(toIndex),   section: 0)], with: .automatic)
        self.tableView.insertRows(at: [IndexPath(row: Int(fromIndex), section: 0)], with: .automatic)
    
    }
    
    func array(_ array: FUICollection, didRemove object: Any, at index: UInt) {
        
        self.tableView.deleteRows(at: [IndexPath(row: Int(index), section: 0)], with: .automatic)
        
    }
    
    func array(_ array: FUICollection, didChange object: Any, at index: UInt) {
        
        self.tableView.reloadRows(at: [IndexPath(row: Int(index), section: 0)], with: .automatic)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return Int(self.conteacts.count)
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageTableViewCell
        let info = JSON((conteacts[(UInt(indexPath.row))] as? DataSnapshot)?.value as Any).dictionaryObject
        cell.name.text = info?["name"] as? String
        cell.lastMessageDate.text = nil
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let uid = (conteacts[UInt(indexPath.row)] as? DataSnapshot)?.key
        let reference = Database.database().reference().child("User-messages").child(Me.uid).child(uid!).queryLimited(toLast: 51)
        self.tableView.isUserInteractionEnabled = false
        
        reference.observeSingleEvent(of: .value, with: { [ weak self ] (snapshot) in
            let msg = Array(JSON(snapshot.value as Any).dictionaryValue.values).sorted(by: {(lhs, rhs) -> Bool in
                return lhs["date"].doubleValue < rhs["date"].doubleValue
            })
            
            let converted = self!.convertToChatItemProtocal(messages: msg)
            let chatLog = ChatLogController()
            chatLog.userUID = uid!
            chatLog.dataSource = DataSource(initialMessages: converted, uid: uid!)
            self?.navigationController?.show(chatLog, sender: nil)
            self?.tableView.deselectRow(at: indexPath, animated: true)
            self?.tableView.isUserInteractionEnabled = true
        })
    
    }
    
}















