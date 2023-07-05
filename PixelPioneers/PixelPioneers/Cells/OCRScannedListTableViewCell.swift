//
//  OCRScannedListTableViewCell.swift
//  PixelPioneers
//
//  Created by Ashish Singh on 05/07/23.
//

import UIKit

struct OCRValues {
    var key: String?
    var value: String?
}

class OCRScannedListTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var key: UILabel!
    @IBOutlet weak var valueTF: UITextField!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        valueTF.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func wrap(_ model: OCRValues) {
        self.key.text = model.key
        self.valueTF.text = model.value
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
}
