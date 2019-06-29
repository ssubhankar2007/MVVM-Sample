//
//  ProductCollectionViewCell.swift
//  SampleDemoApp
//
//  Created by Subhankar on 26/06/19.
//  Copyright © 2019 Subhankar. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: ReusableCollectionViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(data: Product) {
        self.productPriceLabel.text = "\(data.currency) " + data.price
        self.productNameLabel.text = data.name
        self.productImageView.layer.cornerRadius = 3
        self.productImageView.layer.borderWidth = 1
        self.productImageView.layer.borderColor = UIColor(red: 220/255, green: 220/255, blue: 210/255, alpha: 1).cgColor
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: data.url), let imageData = NSData(contentsOf: url) {
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData as Data)
                    self.productImageView.image = image
                    self.productImageView.contentMode = .scaleToFill
                }
            }
        }
    }
    
}
