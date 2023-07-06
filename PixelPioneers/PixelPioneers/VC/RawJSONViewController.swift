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
        
        // Load the formatted JSON string into WKWebView
        webview.loadHTMLString("<pre>\(prettyPrintedString)</pre>", baseURL: nil)
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
