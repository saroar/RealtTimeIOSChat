//
//  UserListVC.swift
//  ChattoChatApp
//
//  Created by Alif on 16/10/2017.
//  Copyright © 2017 Alif. All rights reserved.
//

import UIKit

struct UserList {
    let username: String
    let displayName: String
    let avatar: String
}

class UserListVC: UITableViewController {
    var userLists = [UserList]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        fakeData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fakeData() {
        self.userLists = [
            UserList(username: "Alif", displayName: "Alif", avatar: "ok"),
            UserList(username: "Alif", displayName: "Alif", avatar: "ok"),
            UserList(username: "Alif", displayName: "Alif", avatar: "ok")
        ]
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userLists.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Users", for: indexPath)
        
        let user_list_data = userLists[indexPath.row]
        
        cell.textLabel?.text = user_list_data.username
    
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard segue.identifier == "chatVC",
//            let chatController = segue.destination as? TestChatVC,
//            let cell = sender as? UITableViewCell,
//            let indexPath = tableView.indexPath(for: cell) else { return }
//
//        let user_list_data = userLists[indexPath.row]
//
//        chatController.username = user_list_data.username
//        chatController.displayName = user_list_data.displayName
//        chatController.avatar = user_list_data.avatar
//        if segue.identifier == "chatVC" {
//            if let destination = segue.destination as? TestChatVC {
//                destination.username 
//            }
//        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "chatVC", sender: nil)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
