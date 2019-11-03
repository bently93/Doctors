//
//  DoctorsTableViewCell.swift
//  Doctors
//
//  Created by n.leontiev on 17.05.2018.
//  Copyright © 2018 bently_93.com. All rights reserved.
//

import UIKit

class DoctorsTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var decriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
