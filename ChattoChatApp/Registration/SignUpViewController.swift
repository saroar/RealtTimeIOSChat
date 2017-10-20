//
//  SingUpViewController.swift
//  ChattoChatApp
//
//  Created by Alif on 18/10/2017.
//  Copyright © 2017 Alif. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var fullname: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showingKeyboard), name: Notification.Name("UIKeyboardWillShowNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hidingKeyboard), name: Notification.Name("UIKeyboardWillHideNotification"), object: nil)
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        self.view.endEditing(true)
    
    }
    
    
    @IBAction func singUp(_ sender: Any) {
    
        guard let email = email.text, let password = password.text, let fullname = fullname.text else { return }
    
        Auth.auth().createUser(withEmail: email, password: password) { [ weak self ] (user, error) in

            if let error = error {
                self?.alert(message: error.localizedDescription)
                return
            }
            
            Database.database().reference().child("Users").child(user!.uid).updateChildValues(["email": email, "name": fullname])
            let changeRequest = user!.createProfileChangeRequest()
            changeRequest.displayName = fullname
            changeRequest.commitChanges(completion: nil)
            
        }
        
        let table = self.storyboard?.instantiateViewController(withIdentifier: "table") as! MessageTableVC
        self.navigationController?.show(table, sender: nil)
    
    }
    
}
