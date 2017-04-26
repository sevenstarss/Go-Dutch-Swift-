//
//  ProfileMessageCell.swift
//  Go Dutch
//
//  Created by Denis Litvinskiy on 05.12.16.
//  Copyright © 2016 Sergey Bill. All rights reserved.
//

import UIKit

class ProfileMessageCell: UITableViewCell {

    @IBOutlet weak var messageView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.messageView.layer.cornerRadius = 4.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
