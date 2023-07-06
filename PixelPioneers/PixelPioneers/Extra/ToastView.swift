//
//  ToastView.swift
//  PixelPioneers
//
//  Created by Sushant on 06/07/23.
//

import Foundation
import UIKit

class ToastView: UIView {
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    private func configureView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        addSubview(messageLabel)
        // Constraints
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    func showMessage(_ message: String) {
        messageLabel.text = message
    }
}
