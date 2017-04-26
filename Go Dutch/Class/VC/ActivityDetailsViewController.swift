//
//  ActivityDetailsViewController.swift
//  Go Dutch
//
//  Created by Denis Litvinskiy on 17.10.16.
//  Copyright © 2016 Sergey Bill. All rights reserved.
//

import UIKit
import SDWebImage

class ActivityDetailsViewController: BasicVC, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topGradientView: UIView!
    @IBOutlet weak var bottomGradientView: UIView!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventCategoryLabel: UILabel!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventPriceLabel: UILabel!

    var mainLikeView: UIView!
    var heartImageView: UIImageView!
    var likedImageView: UIImageView!
    @IBOutlet weak var likedMessageImageView: UIImageView!
    
    let sendProposalTextLiked = "Now that you've liked the activity, view profiles and send proposal!"
    let sendProposalTextNotLiked = "Like activity and then you can see profiles and send proposals."
    
    var event: Event!
    private var user: User!
    
    private var showMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = Session.sharedInstance.currentUser
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)

        self.setupGradient()
        self.updateDetails()
        self.setupLikeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackButton(_ sender: AnyObject) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func onLikeButton() {
        
        self.playSound(Sound_SignUpComplete)
        
        if self.userLikedEvent(event: event) {
            Server().dislikeEvent(userID: self.user.userID, eventID: self.event.eventID, completion: { [weak self] (success) in
                guard let strongSelf = self else { return }
                DispatchQueue.main.async {
                    strongSelf.changeHeartImage(liked: false)
                    strongSelf.event.isLikedByUser = false
                    strongSelf.reloadEventLikes()
                    strongSelf.animateLikeButton(liked: false, animated: true)
                }
            })
        } else {
            Server().likeEvent(userID: self.user.userID, eventID: self.event.eventID) { [weak self] (success) in
                guard let strongSelf = self else { return }
                DispatchQueue.main.async {
                    strongSelf.changeHeartImage(liked: true)
                    strongSelf.event.isLikedByUser = true
                    strongSelf.reloadEventLikes()
                    strongSelf.animateLikeButton(liked: true, animated: true)
                }
            }
        }
    }
    
    //MARK: - UITableViewDelegate/DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 104.0
        }
        
        if indexPath.row == 1 {
            return UITableViewAutomaticDimension
        }
        
        if indexPath.row == 2 {
            return 110.0
        }
        
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 102
        }
        
        if indexPath.row == 1 {
            return 200.0
        }
        
        if indexPath.row == 2 {
            return 110.0
        }
        
        return 64.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityDetailsLocationCell") as! ActivityDetailsLocationCell
            self.configureLocation(cell: cell)
            
            return cell
        }
        
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityDetailsCell") as! ActivityDetailsCell
            self.configureDetails(cell: cell)
            
            return cell
        }
        
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivitySendProposalCell") as! ActivityDetailsSendProposalCell
            self.configureSendProposal(cell: cell)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell")!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            self.showMore = !self.showMore
            self.tableView.reloadData()
        }
        
        if indexPath.row == 2 {
            if !self.event.isLikedByUser { return }
            guard let users = self.event.usersLiked else { return }
            
            let whosLikedEventVC = self.storyboard?.instantiateViewController(withIdentifier: "WhosLikedEventVC") as! WhosLikedEventVC
            whosLikedEventVC.usersLikedEvent = users
            self.navigationController?.pushViewController(whosLikedEventVC, animated: true)
        }
    }
    
    //MARK: - Private
    
    private func userLikedEvent(event: Event) -> Bool {
        
        let userID = self.user.userID
        var userLikedEvent = false
        if let users = event.usersLiked {
            for user in users {
                if userID == user.userID {
                    userLikedEvent = true
                }
            }
        }
        
        return userLikedEvent
    }
    
    private func reloadEventLikes() {
        
        Server().usersLikedEvent(eventID: event.eventID) { [weak self] (result) in
            guard let strongSelf = self else { return }
            if let usresLiked = result {
                strongSelf.event.usersLiked = usresLiked
            } else {
                strongSelf.event.usersLiked = []
            }
            
            strongSelf.tableView.reloadData()
        }
    }
    
    private func setupGradient() {
        
        let topGradientLayer = CAGradientLayer()
        topGradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 155.0)
        let clear = UIColor.white.withAlphaComponent(0).cgColor
        topGradientLayer.colors = [UIColor.white.cgColor, clear]
        self.topGradientView.layer.addSublayer(topGradientLayer)
        self.topGradientView.alpha = 0.6
        
        let bottomGradientLayer = CAGradientLayer()
        bottomGradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 155.0)
        bottomGradientLayer.colors = [clear, UIColor.white.cgColor]
        self.bottomGradientView.layer.addSublayer(bottomGradientLayer)
        self.bottomGradientView.alpha = 0.6
    }
    
    private func updateDetails() {
        
        if let imageURL = URL(string: self.event.photo) {
            self.eventImageView.sd_setImage(with: imageURL)
        } else {
            self.eventImageView.image = nil
        }
        
        self.eventCategoryLabel.text = self.event.categoryName
        
        var eventTitle = self.event.title!
        
        if eventTitle.characters.count <= 25 {
            let words = eventTitle.components(separatedBy: CharacterSet.whitespaces)
            if words.count == 4 {
                eventTitle = words[0] + " " + words[1] + "\n" + words[2] + " " + words[3]
            }
            
            if words.count == 3 {
                eventTitle = words[0] + " " + words[1] + "\n" + words[2]
            }
            
            self.eventTitleLabel.text = eventTitle
        } else {
            self.eventTitleLabel.text = self.event.title
        }
        
        
        self.eventPriceLabel.text = "Starting at $" + self.event.cost
    }
    
    private func configureDetails(cell: ActivityDetailsCell) {
        
        cell.selectionStyle = .none
        
        cell.descriptionLabel.text = self.event.eventDescription
        
        if (!self.showMore) {
            let readMoreText = " Show More"
            let lengthForString = cell.descriptionLabel.text?.characters.count
            if (lengthForString! >= 500) {
                
                let tempString = cell.descriptionLabel.text! as NSString
                var substring = tempString.substring(to: 487)
                substring += "..."
                
                let mutableAttributedSubstring = NSMutableAttributedString(string: substring, attributes: [NSFontAttributeName: cell.descriptionLabel.font, NSForegroundColorAttributeName: cell.descriptionLabel.textColor])
                let attributedReadMoreString = NSAttributedString(string: readMoreText, attributes: [NSFontAttributeName: cell.descriptionLabel.font, NSForegroundColorAttributeName: UIColor.red])
                mutableAttributedSubstring.append(attributedReadMoreString)
                
                cell.descriptionLabel.attributedText = mutableAttributedSubstring
            }
        }
    }
    
    private func configureSendProposal(cell: ActivityDetailsSendProposalCell) {
        
        cell.selectionStyle = .none
        cell.likesCount = self.event.usersLiked?.count ?? 0
        cell.sendProposalView.alpha = self.event.isLikedByUser == true ? 1.0 : 0.4
        cell.sendProposalLabel.text = self.event.isLikedByUser == true ? self.sendProposalTextLiked : self.sendProposalTextNotLiked
    }
    
    private func configureLocation(cell: ActivityDetailsLocationCell) {
        
        cell.locationLabel.text = self.event.location
        cell.dateLabel.text = self.event.date
        cell.timeLabel.text = self.event.time
    }
    
    private func setupLikeView() {
    
        let mainLikeView = UIView(frame: CGRect(x: self.view.frame.size.width/2 - 25.0, y: self.view.frame.size.height - 80.0, width: 50.0, height: 76.0))
        mainLikeView.backgroundColor = .clear
        self.mainLikeView = mainLikeView
        
        let heartImageView = UIImageView(frame: CGRect(x: 3.0, y: 32.0, width: 44.0, height: 44.0))
        mainLikeView.addSubview(heartImageView)
        
        let likedImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 24.0))
        likedImageView.image = #imageLiteral(resourceName: "liked")
        likedImageView.alpha = 0.0
        mainLikeView.addSubview(likedImageView)
        
        let likeButton = UIButton(frame: heartImageView.frame)
        likeButton.backgroundColor = .clear
        likeButton.addTarget(self, action: #selector(onLikeButton), for: .touchUpInside)
        mainLikeView.addSubview(likeButton)
        
        self.heartImageView = heartImageView
        self.likedImageView = likedImageView
        self.likedImageView.alpha = 0.0
        
        self.view.addSubview(mainLikeView)
        
        self.changeHeartImage(liked: self.event.isLikedByUser)
        self.animateLikeButton(liked: self.event.isLikedByUser, animated: false)
    }
    
    private func animateLikeButton(liked: Bool, animated: Bool) {
        
        if liked {
            
            self.likedImageView.alpha = 1.0
            
            if animated {
                let duration = animated ? 0.1 : 0.0
                
                UIView.animate(withDuration: duration, animations: {
                    self.mainLikeView.frame.origin.y = self.view.frame.size.height - 130.0
                    }, completion: { (completed) in
                        UIView.animate(withDuration: 0.07, animations: {
                            self.mainLikeView.frame.origin.y = self.view.frame.size.height - 120.0
                            }, completion: { (completed) in
                                UIView.animate(withDuration: 0.05, animations: {
                                    self.mainLikeView.frame.origin.y = self.view.frame.size.height - 125.0
                                    }, completion: { (completed) in
                                        UIView.animate(withDuration: 0.03, animations: { 
                                            self.mainLikeView.frame.origin.y = self.view.frame.size.height - 120.0
                                        }, completion: { (completed) in
                                        })
                                })
                        })
                })
                
                UIView.animate(withDuration: 1.0, animations: { 
                    self.likedImageView.alpha = 0.0
                })
                
            } else {
                self.mainLikeView.frame.origin.y = self.view.frame.size.height - 120.0
                self.likedImageView.alpha = 0.0
            }
        } else {
            
            let duration = animated ? 0.3 : 0.0
            
            UIView.animate(withDuration: duration, animations: {
                self.mainLikeView.frame.origin.y = self.view.frame.size.height - 100.0
            }, completion: { (completed) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    self.likedImageView.alpha = 0.0
                })
            })
        }
    }
    
    private func changeHeartImage(liked: Bool) {
        self.heartImageView.image = liked ? #imageLiteral(resourceName: "heart_liked") : #imageLiteral(resourceName: "heart")
    }
}
