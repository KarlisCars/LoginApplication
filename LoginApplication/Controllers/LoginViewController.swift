//
//  LoginViewController.swift
//  LoginApplication
//
//  Created by Karlis Cars on 09/11/2019.
//  Copyright © 2019 Karlis Cars. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    let segueIndentifier = "fireSegue"

    var ref:DatabaseReference!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
  
    override func viewWillLayoutSubviews() {
        self.navigationItem.titleView = nil
        self.navigationItem.title = "Login"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        warningLabel.alpha = 0
        self.hideKeyboardWhenTappedAround()
        
        ref = Database.database().reference(withPath: "users")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
            
            Auth.auth().addStateDidChangeListener { (auth, user) in
                if user != nil {
                    self.goToTasksViewController()
                   // self.performSegue(withIdentifier: self.segueIndentifier, sender: nil)
                }
            }
        }
    
    // MARK: - Keyboard
    
        
        @objc func keyboardWillShow(notification: Notification) {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 150
                let logo = UIImage(named: "fire.png")
                let imageView = UIImageView(image: logo)
                self.navigationItem.titleView = imageView
             
            }
        }
        @objc func keyboardWillHide(notification: Notification) {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += 150
            }
        }
        
    
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
        
  // MARK: - Warning label
    
        func displayWarningLabel(withText text:String){
            warningLabel.text = text
            UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: { [weak self] in
                self?.warningLabel.alpha = 1
            }) { [weak self] complete in
                self?.warningLabel.alpha = 0
            }
        }
    // MARK: - Buttons
    
    @IBAction func loginButton(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(withText: "Email/Password incorrect!")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) {(user, error) in
        if error != nil {
            self.displayWarningLabel(withText: "error ocured!")
            return
        }
        if user != nil{
           
            self.goToTasksViewController()
            // self.performSegue(withIdentifier: self.segueIndentifier, sender: nil)
            return
        }
        self.displayWarningLabel(withText: "No such user")
    }
   
        
    }
    
//    @IBAction func registerButton(_ sender: Any) {
//        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
//                    displayWarningLabel(withText: "Email/Password incorrect!")
//                    return
//                }
//                Auth.auth().createUser(withEmail: email, password: password, completion:  { (user, error) in
//                    guard error == nil, user != nil else {
//                        print(error!.localizedDescription)
//                        self.displayWarningLabel(withText: "User is not creadted!")
//                        return
//                    }
//                    let userRef = self.ref.child((user?.user.uid)!)
//                    userRef.setValue(["email": user?.user.email])
//                })
//    }
    
    func goToTasksViewController(){
        let initController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TasksVC") as! UINavigationController
        view.endEditing(true)
        present(initController, animated: true, completion: nil)
    }
}

