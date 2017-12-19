//
//  TargetTableViewCell.swift
//  Targets
//
//  Created by Sandeep Chowdhury on 19/12/2017.
//  Copyright © 2017 Sandeep Chowdhury. All rights reserved.
//

import UIKit

class TargetTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
