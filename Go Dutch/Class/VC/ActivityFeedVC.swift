//
//  ActivityFeedVC.swift
//  Go Dutch
//
//  Created by Michal Solowow on 9/8/16.
//  Copyright © 2016 Sergey Bill. All rights reserved.
//

import Foundation
import SDWebImage
import AVFoundation
import SendBirdSDK

class ActivityFeedVC: BasicVC, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var user: User!
    private var events = [Event]()
    private var filteredEvents: [Event]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = Session.sharedInstance.currentUser
        self.setupSearchView()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Server().allEvents(userID: self.user.userID) { [weak self] (events) in
            guard let strongSelf = self else { return }
            strongSelf.events = events
            strongSelf.tableView.reloadData()
        }
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - IBAction
    
    func onLikeButton(sender: UIButton) {
        
        self.playSound(Sound_SignUpComplete)
        
        let event = self.events[sender.tag]
        let cell = self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! ActivityFeedCell
        if event.isLikedByUser == true {
            Server().dislikeEvent(userID: self.user.userID, eventID: event.eventID, completion: { [weak self] (success) in
                guard let strongSelf = self else { return }
                event.isLikedByUser = false
                DispatchQueue.main.async {
                    cell.changeLikeImage(liked: false)
                    cell.animateLikeButton(liked: false, animated: true, completion: {
                        strongSelf.reloadEventLikes(event: event, atRow: sender.tag)
                    })
                }
            })
        } else {
            Server().likeEvent(userID: self.user.userID, eventID: event.eventID) { [weak self] (success) in
                guard let strongSelf = self else { return }
                event.isLikedByUser = true
                DispatchQueue.main.async {
                    cell.changeLikeImage(liked: true)
                    cell.animateLikeButton(liked: true, animated: true, completion: {
                        strongSelf.reloadEventLikes(event: event, atRow: sender.tag)
                    })
                    
                }
            }
        }
    }
    
    //MARK: - UITableViewDelegate/DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = self.filteredEvents?.count ?? self.events.count
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityFeedCell") as! ActivityFeedCell
        
        self.configure(cell: cell, forRow: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let event = self.filteredEvents?[indexPath.row] ?? self.events[indexPath.row]
        let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "ActivityDetailsViewController") as! ActivityDetailsViewController
        detailsVC.event = event
        
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "Search..." {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = "Search..."
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText = textField.text! as NSString
        let filterString = textFieldText.replacingCharacters(in: range, with: string)
        if filterString == "" {
            self.filteredEvents = nil
        } else {
            self.filteredEvents = self.events.filter({ $0.title.contains(filterString)})
        }
        
        self.tableView.reloadData()
        
        return true
    }
    
    //MARK: - Private
    
    func configure(cell: ActivityFeedCell, forRow row: Int) {
        
        cell.selectionStyle = .none
        
        let event = self.filteredEvents?[row] ?? self.events[row]
        
        cell.eventCategoryLabel.text = event.categoryName
        cell.eventTitleLabel.text = event.title
        cell.eventLocationLabel.text = event.location
        cell.eventDateLabel.text = event.date
        cell.eventPriceLabel.text = "Starting at $" + event.cost
        cell.heartImageView.image = event.isLikedByUser! ? #imageLiteral(resourceName: "heart_liked") : #imageLiteral(resourceName: "heart")
        
        if !cell.animating {
            cell.animateLikeButton(liked: event.isLikedByUser, animated: false, completion: {})
        }
        
        
        if let imageURL = URL(string: event.photo) {
            cell.eventImageView.sd_setImage(with: imageURL)
        } else {
            cell.eventImageView.image = nil
        }
        
        cell.likeButton.tag = row
        cell.likeButton.addTarget(self, action: #selector(onLikeButton), for: .touchUpInside)
        
        if nil == event.usersLiked {
            Server().usersLikedEvent(eventID: event.eventID) { [weak self] (result) in
                guard let strongSelf = self else { return }
                if let usresLiked = result {
                    event.usersLiked = usresLiked
                } else {
                    event.usersLiked = []
                }
                
                strongSelf.events.remove(at: row)
                strongSelf.events.insert(event, at: row)
                strongSelf.configure(cell: cell, forRow: row)
            }
        } else {
            cell.likesCount = event.usersLiked?.count ?? 0
        }
    }
    
    func userLikedEvent(event: Event) -> Bool {
        
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
    
    func reloadEventLikes(event: Event, atRow row: Int) {
        
        Server().usersLikedEvent(eventID: event.eventID) {(result) in
            if let usresLiked = result {
                event.usersLiked = usresLiked
            } else {
                event.usersLiked = []
            }
            
            self.events.remove(at: row)
            self.events.insert(event, at: row)
            self.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
        }
    }
    
    func setupSearchView() {
        
        let searchTextField = UITextField(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 32.0))
        searchTextField.delegate = self
        searchTextField.backgroundColor = UIColor(red: 49.0/255.0, green: 81.0/255.0, blue: 138.0/255.0, alpha: 1.0)
        searchTextField.text = "Search..."
        searchTextField.textColor = UIColor.white
        searchTextField.font = UIFont(name: "Dosis-SemiBold", size: 14.0)
        searchTextField.leftViewMode = .always
        
        let searchImageView = UIImageView(frame: CGRect(x: 14.0, y: 0.0, width: 46.0, height: 16.0))
        searchImageView.image = #imageLiteral(resourceName: "search")
        searchImageView.contentMode = .scaleAspectFit
        searchTextField.leftView = searchImageView
        self.navigationItem.titleView = searchTextField
    }
}
