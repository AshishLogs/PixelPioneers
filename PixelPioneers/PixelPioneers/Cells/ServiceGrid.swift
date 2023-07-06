//
//  ServiceGrid.swift
//  PixelPioneers
//
//  Created by Sushant on 06/07/23.
//

import UIKit

class ServiceGrid: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var serviceTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        // Initialization code
    }
    
    func configureCell(type : ServiceType, title : String) {
        imageView.image = UIImage.init(named: type.imageName)
        serviceTitle.text = title
    }

}
