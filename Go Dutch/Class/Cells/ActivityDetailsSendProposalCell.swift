//
//  ActivityDetailsSendProposalCell.swift
//  Go Dutch
//
//  Created by Denis Litvinskiy on 18.10.16.
//  Copyright © 2016 Sergey Bill. All rights reserved.
//

import UIKit

class ActivityDetailsSendProposalCell: UITableViewCell {

    @IBOutlet weak var sendProposalLabel: UILabel!
    @IBOutlet weak var sendProposalView: UIView!
    @IBOutlet weak var likesView: UIView!
    @IBOutlet weak var likesCountView: UIView!
    @IBOutlet var userLikesView: [UIView]!
    @IBOutlet weak var likesCountLabel: UILabel!
    
    private var likesCountPrimitive = 0
    var likesCount: Int {
        set {
            self.likesCountPrimitive = newValue
            self.likesCountLabel.text = "\(newValue)"
            
            var index = 0
            for view in userLikesView {
                if index < newValue {
                    view.isHidden = false
                } else {
                    view.isHidden = true
                }
                
                index += 1
            }
        }
        get {
            return self.likesCountPrimitive
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.likesCountView.clipsToBounds = true
        self.likesCountView.layer.cornerRadius = 7.5
        self.likesCountView.layer.borderColor = UIColor.white.cgColor
        self.likesCountView.layer.borderWidth = 1.0
        
        for view in self.userLikesView {
            view.layer.cornerRadius = 14.0
            view.layer.borderColor = UIColor.white.cgColor
            view.layer.borderWidth = 1.0
        }
        
        self.sendProposalView.layer.shadowColor = UIColor.black.cgColor
        self.sendProposalView.layer.shadowOpacity = 0.2
        self.sendProposalView.layer.shadowOffset = CGSize.zero
        self.sendProposalView.layer.shadowRadius = 3.5
        let rect = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width - 21.0 - 43.0, height: 92)
        self.sendProposalView.layer.shadowPath = UIBezierPath(rect: rect).cgPath
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
