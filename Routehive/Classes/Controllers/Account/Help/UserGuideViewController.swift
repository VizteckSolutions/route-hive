//
//  UserGuideViewController.swift
//  Routehive
//
//  Created by Mac on 01/11/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import WebKit

class UserGuideViewController: UIViewController {

    // MARK: - Variables & Constants
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    
    var type = WebViewType.userGuide.rawValue
    var titleLabel = ""
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        
        if type == WebViewType.userGuide.rawValue {
            loadUserGuide()
            
        } else if type == WebViewType.faqs.rawValue {
            loadFaqs()
            
        } else if type == WebViewType.termsConditions.rawValue {
            loadTermsConditions()
            
        } else if type == WebViewType.privacyPolicy.rawValue {
            loadPrivacyPolicy()
        }
    }
    
    // MARK: - Private Methods
    
    func loadUserGuide() {
        title = titleLabel
        let myURL = URL(string: kUserGuideUrl)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    func loadFaqs() {
        title = titleLabel
        let myURL = URL(string:kFaqsUrl)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

    func loadTermsConditions() {
        title = titleLabel
        let myURL = URL(string:kTermsAndConditionsUrl)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

    func loadPrivacyPolicy() {
        title = titleLabel
        let myURL = URL(string:kPrivacyPolicy)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}

extension UserGuideViewController: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
}
