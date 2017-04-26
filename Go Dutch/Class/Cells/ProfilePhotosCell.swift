//
//  ProfilePhotosCell.swift
//  Go Dutch
//
//  Created by Denis Litvinskiy on 05.12.16.
//  Copyright © 2016 Sergey Bill. All rights reserved.
//

import UIKit

class ProfilePhotosCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
