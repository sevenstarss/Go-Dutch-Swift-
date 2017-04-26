//
//  ActivityDetailsLocationCell.swift
//  Go Dutch
//
//  Created by Denis Litvinskiy on 04.01.17.
//  Copyright © 2017 Sergey Bill. All rights reserved.
//

import UIKit

class ActivityDetailsLocationCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
