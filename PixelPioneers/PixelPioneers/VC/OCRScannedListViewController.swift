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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCells()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.navigationItem.title = titleName ?? "OCR"
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "OCRScannedListTableViewCell",
                                  bundle: nil)
        self.tableView.register(textFieldCell,
                                forCellReuseIdentifier: "OCRScannedListTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        imageView.contentMode = .scaleAspectFit
        imageView.image = titleImage
        return titleImage == nil ? nil : imageView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if titleImage == nil {
            return 0
        }
        return 100
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
    
}
