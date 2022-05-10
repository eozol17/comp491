//
//  ProductsTableViewCell.swift
//  CompTermProject
//
//  Created by Eren Ege Özol on 11.03.2022.
//

import UIKit

class ProductsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productTime: UILabel!
    @IBOutlet weak var ProductName: UILabel!
    @IBOutlet weak var productAttributes: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
