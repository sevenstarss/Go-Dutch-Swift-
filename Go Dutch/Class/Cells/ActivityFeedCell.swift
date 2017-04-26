//
//  ActivityFeedCell.swift
//  Go Dutch
//
//  Created by Denis Litvinskiy on 15.10.16.
//  Copyright © 2016 Sergey Bill. All rights reserved.
//

import UIKit

class ActivityFeedCell: UITableViewCell {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventCategoryLabel: UILabel!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventPriceLabel: UILabel!
    @IBOutlet weak var likesView: UIView!
    @IBOutlet weak var likesCountView: UIView!
    @IBOutlet var userLikesView: [UIView]!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var likesTextLabel: UILabel!
    
    var animating = false
    
    var likeView: UIView!
    var likeButton: UIButton!
    var heartImageView: UIImageView!
    var likeMessageView: UIImageView!
    
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
            
            self.likesTextLabel.text = "\(newValue) Dutches like activity"
        }
        get {
            return self.likesCountPrimitive
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.animating = false
        
        self.setupLikeView()
        
        self.likesCountView.clipsToBounds = true
        self.likesCountView.layer.cornerRadius = 7.5
        self.likesCountView.layer.borderColor = UIColor.white.cgColor
        self.likesCountView.layer.borderWidth = 1.0
        
        for view in self.userLikesView {
            view.layer.cornerRadius = 14.0
            view.layer.borderColor = UIColor.white.cgColor
            view.layer.borderWidth = 1.0
            view.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        
        for view in self.userLikesView {
            view.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func changeLikeImage(liked: Bool) {
        
        let likeImage = !liked ? #imageLiteral(resourceName: "heart") : #imageLiteral(resourceName: "heart_liked")
        self.heartImageView.image = likeImage
    }
    
    func animateLikeButton(liked: Bool, animated: Bool, completion: @escaping () -> ()) {
        
        self.changeLikeImage(liked: liked)
        
        if liked {
            self.likeMessageView.alpha = 1.0
            if animated {
                
                self.animating = true
                
                let duration = 0.1
                
                UIView.animate(withDuration: duration, animations: {
                    self.likeView.frame.origin.y = self.frame.size.height - 106.0
                }, completion: { (_) in
                    UIView.animate(withDuration: 0.07, animations: {
                        self.likeView.frame.origin.y = self.frame.size.height - 96.0
                    }, completion: { (_) in
                        UIView.animate(withDuration: 0.05, animations: {
                            self.likeView.frame.origin.y = self.frame.size.height - 101.0
                        }, completion: { (_) in
                            UIView.animate(withDuration: 0.03, animations: {
                                self.likeView.frame.origin.y = self.frame.size.height - 96.0
                            }, completion: { (completed) in
                                if completed {
                                    self.animating = false
                                    completion()
                                }
                            })
                        })
                    })
                })
                
                UIView.animate(withDuration: 1.0, animations: {
                    self.likeMessageView.alpha = 0.0
                })
                
            } else {
                self.likeMessageView.alpha = 0.0
                self.likeView.frame.origin.y = self.bounds.size.height - 96
                self.animating = false
                completion()
            }
        } else {
            
            if animated {
                self.animating = true
                UIView.animate(withDuration: 0.3, animations: {
                    self.likeView.frame.origin.y = self.frame.size.height - 76.0
                }, completion: { (completed) in
                    self.likeMessageView.alpha = 0.0
                    if completed {
                        self.animating = false
                        completion()
                    }
                })
            } else {
                self.likeView.frame.origin.y = self.frame.size.height - 76.0
                self.likeMessageView.alpha = 0.0
                self.animating = false
            }
        }
    }
    
    func setupLikeView() {
        
        self.likeView = UIView(frame: CGRect(x: 10.0, y: self.bounds.size.height - 76.0, width: 50.0, height: 76.0))
        self.likeView.backgroundColor = .clear
        
        self.addSubview(self.likeView)
        
        self.heartImageView = UIImageView(frame: CGRect(x: 5.0, y: 28.0, width: 40.0, height: 40.0))
        self.heartImageView.image = #imageLiteral(resourceName: "heart")
        self.likeView.addSubview(heartImageView)
        
        self.likeButton = UIButton(frame: CGRect(x: 5.0, y: 28.0, width: 40.0, height: 40.0))
        self.likeButton.backgroundColor = .clear
        self.likeView.addSubview(self.likeButton)
        
        self.likeMessageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 24.0))
        self.likeMessageView.image = #imageLiteral(resourceName: "liked")
        self.likeMessageView.alpha = 0.0
        self.likeView.addSubview(self.likeMessageView)
    }
}
