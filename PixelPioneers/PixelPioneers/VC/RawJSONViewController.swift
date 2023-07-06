//
//  RawJSONViewController.swift
//  PixelPioneers
//
//  Created by Ashish Singh on 06/07/23.
//

import UIKit
import WebKit

class RawJSONViewController: UIViewController {
    
    var json: Data?
    
    private var pasteJSON = ""
    
    @IBOutlet weak var webview: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard
            let data = json,
            let jsonObject = try? JSONSerialization.jsonObject(with: data),
            let prettyPrintedData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
            let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8)
        else {
            return
        }
        let appearance = UINavigationBar.appearance()
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        pasteJSON = prettyPrintedString
        let titleLabel = UILabel()
        titleLabel.text = "JSON"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        self.navigationItem.titleView = titleLabel

        let rightBarButton = UIBarButtonItem(title: "Copy", style: .plain, target: self, action: #selector(rightBarButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButton

        
        // Load the formatted JSON string into WKWebView
        webview.loadHTMLString("<pre>\(prettyPrintedString)</pre>", baseURL: nil)
    }
    
    @objc func rightBarButtonTapped() {
        if pasteJSON.count > 0 {
            UIPasteboard.general.string = pasteJSON
            self.showToast(message: "JSON copied to clipboard")
        }
    }

}
