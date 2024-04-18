//
//  DetailViewController.swift
//  WhitehousePetitions
//
//  Created by Rodrigo Cavalcanti on 17/04/24.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem else { return }
        
        title = detailItem.title
        navigationItem.largeTitleDisplayMode = .never
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
        body {
            padding: 25px;
            font-size: 150%;
        }
        </style>
        </head>
        <body>
        \(detailItem.body.isEmpty ? detailItem.title : detailItem.body)
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil) // custom url locally
    }
}
