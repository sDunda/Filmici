//
//  WebView.swift
//  Filmici
//
//  Created by D&M on 25.02.2017..
//  Copyright © 2017. Dunja Sasic. All rights reserved.
//

import UIKit

class WebView: UIViewController {
    
        var webView: UIWebView!
   
    
        var url:String!
    
        convenience init(url: String!) {                  
            self.init()
            self.url = url
        }
    
    
        override func viewDidLoad() {
            super.viewDidLoad()
            webView = UIWebView(frame: UIScreen.main.bounds)
            view.addSubview(webView)
            if let url = URL(string: url) {
                print(url)
                let request = URLRequest(url: url)
                webView.loadRequest(request)
            }
    
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
