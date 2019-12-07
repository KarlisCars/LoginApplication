//
//  Extensions.swift
//  LoginApplication
//
//  Created by Karlis Cars on 11/11/2019.
//  Copyright © 2019 Karlis Cars. All rights reserved.
//

import UIKit

// MARK: - Keyboard dismisses when tapped

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
     let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
      tap.cancelsTouchesInView = false
      view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
       view.endEditing(true)
    }
    
    
    func warningPopUp(withTitle title : String?, withMessage message : String?){
        DispatchQueue.main.async {
            
            let popUP = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            popUP.addAction(okButton)
            self.present(popUP, animated: true, completion: nil)
        }
    }
}


