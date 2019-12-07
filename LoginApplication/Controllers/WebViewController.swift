//
//  WebViewController.swift
//  LoginApplication
//
//  Created by Karlis Cars on 07/12/2019.
//  Copyright © 2019 Karlis Cars. All rights reserved.
//

import UIKit
import WebKit


class WebViewController: UIViewController, WKNavigationDelegate{

    var passedValue = ""
    
    @IBOutlet var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: passedValue)
        webView.load(URLRequest(url: url!))
//        webView.allowsBackForwardNavigationGestures = true
        webView.needsUpdateConstraints()
    }
   
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
