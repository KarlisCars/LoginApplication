//
//  SignUpViewController.swift
//  LoginApplication
//
//  Created by Karlis Cars on 07/12/2019.
//  Copyright © 2019 Karlis Cars. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    let segueIndentifier = "fireSegue"
    var ref:DatabaseReference!
    

    @IBOutlet weak var emailSignUpTextField: UITextField!
    @IBOutlet weak var passwordSignUpTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        warningLabel.alpha = 0
        
        // self.hideKeyboardWhenTappedAround()
        ref = Database.database().reference(withPath: "users")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
//        Auth.auth().addStateDidChangeListener { (auth, user) in
//            if user != nil {
//                self.performSegue(withIdentifier: self.segueIndentifier, sender: nil)
//            }
//        }

        
    }
    
    // MARK: - Keyboard
    @objc func keyboardWillShow(notification: Notification) {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 150
                let logo = UIImage(named: "tree.png")
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
    // MARK: - Warning Label
    func displayWarningLabel(withText text:String){
        warningLabel.text = text
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: { [weak self] in
            self?.warningLabel.alpha = 1
        }) { [weak self] complete in
            self?.warningLabel.alpha = 0
        }
    }
    
    func goToTasksViewController(){
        let initController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TasksVC") as! UINavigationController
        view.endEditing(true)
        present(initController, animated: true, completion: nil)
    }
    
    // MARK: - Buttons
    
    @IBAction func haveAccountButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func signUpButton(_ sender: Any) {
        guard let email = emailSignUpTextField.text, let password = passwordSignUpTextField.text, email != "", password != "" else {
                        displayWarningLabel(withText: "Email/Password incorrect!")
                        return
                    }
                    Auth.auth().createUser(withEmail: email, password: password, completion:  { (user, error) in
                        guard error == nil, user != nil else {
                            print(error!.localizedDescription)
                            self.displayWarningLabel(withText: "User is not creadted!")
                            return
                        }
                        let userRef = self.ref.child((user?.user.uid)!)
                        userRef.setValue(["email": user?.user.email])
                        self.goToTasksViewController()
                        
                    })
        }
        
    }
    
    

