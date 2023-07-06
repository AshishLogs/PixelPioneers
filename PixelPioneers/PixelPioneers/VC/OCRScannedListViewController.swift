//
//  ScannerViewController.swift
//  PixelPioneers
//
//  Created by Ashish Singh on 05/07/23.
//

import UIKit

class OCRScannedListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var titleName: String?
    
    var titleImage : UIImage?
    
    var models : [OCRValues] = []
    
    var rawData : Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCells()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.navigationItem.title = titleName ?? "OCR"
        let rightBarButton = UIBarButtonItem(title: "Raw JSON", style: .plain, target: self, action: #selector(rightBarButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButton
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func rightBarButtonTapped() {
        if let jsonReader = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RawJSONViewController") as? RawJSONViewController {
            jsonReader.json = rawData
            self.navigationController?.pushViewController(jsonReader, animated: true)
        }
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "OCRScannedListTableViewCell",
                                  bundle: nil)
        self.tableView.register(textFieldCell,
                                forCellReuseIdentifier: "OCRScannedListTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 150))
        headerView.backgroundColor = .white
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = titleImage
        headerView.addSubview(imageView)
        return titleImage == nil ? nil : headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if titleImage == nil {
            return 0
        }
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OCRScannedListTableViewCell") as? OCRScannedListTableViewCell {
            cell.wrap(models[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        // Extract the keyboard frame from the notification
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            // Adjust the content inset of the table view to make the cell visible above the keyboard
            tableView.contentInset.bottom = keyboardFrame.size.height
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        // Reset the content inset of the table view when the keyboard is hidden
        tableView.contentInset = .zero
    }

    
}
