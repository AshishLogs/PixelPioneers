//
//  ServiceCell.swift
//  PixelPioneers
//
//  Created by Sushant on 06/07/23.
//

import UIKit

class ServiceCell: UITableViewCell {
    
    @IBOutlet weak var serviceTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        serviceTitleLabel.layer.borderWidth = 1.0
        serviceTitleLabel.layer.cornerRadius = 5.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureService(title : String) {
        serviceTitleLabel.text = title
    }
    
}
