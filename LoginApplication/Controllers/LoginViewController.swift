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
    let segueIdentifier = "fireSegue"

    var ref:DatabaseReference!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    func displayWarningLabel(withText text:String){
        warningLabel.text = text
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: { [weak self] in
            self?.warningLabel.alpha = 0
        }) { [weak self] complete in
            self?.warningLabel.alpha = 1
        }
    }
    
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
            self.performSegue(withIdentifier: self.segueIdentifier, sender: nil)
            return
        }
        self.displayWarningLabel(withText: "No such user")
    }
   
    }
    
    @IBAction func registerButton(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
                    displayWarningLabel(withText: "Email/Password incorrect!")
                    return
                }
                Auth.auth().createUser(withEmail: email, password: password, completion:  { (user, error) in
                    guard error == nil, user != nil else {
                        print(error!.localizedDescription)
                        self.displayWarningLabel(withText: "User is not creadted!")
                        return
                    }
        //            let userRef = self.ref.child((user?.user.uid)!)
        //            userRef.setValue(["email": user?.user.email])
                })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

