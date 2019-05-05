//
//  ViewController.swift
//  lookbackheisei
//
//  Created by 中岡黎 on 2019/05/04.
//  Copyright © 2019 NakaokaRei. All rights reserved.
//

import UIKit
import WebKit
class HeiseiViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: Date(timeIntervalSince1970: 0), completionHandler: {})
        
        let myURL = URL(string: "https://look-back-heisei.herokuapp.com/helloios")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        // リンクの適性をチェック
        guard let url = navigationAction.request.url else {
            return nil
        }
        
        // リンクがtarget="_blank"で設定されている場合
        guard let targetFrame = navigationAction.targetFrame, targetFrame.isMainFrame else {
            
            // Safariで開く
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
            return nil
            
        }
        
        return nil
        
    }
    
}

