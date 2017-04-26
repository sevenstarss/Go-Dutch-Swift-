//
//  WhosLikedEventVC.swift
//  Go Dutch
//
//  Created by Denis Litvinskiy on 05.12.16.
//  Copyright © 2016 Sergey Bill. All rights reserved.
//

import UIKit
import SDWebImage

class WhosLikedEventVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var usersLikedEvent: [User]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBAction
    
    @IBAction func onBackButton(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - UITableViewDelegate/DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usersLikedEvent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserLikedCell") as! UserLikedCell
        cell.selectionStyle = .none
        let user = self.usersLikedEvent[indexPath.row]
        self.configure(cell: cell, user: user)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = self.usersLikedEvent[indexPath.row]
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profileVC.user = user
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    //MARK: - Private
    
    private func configure(cell: UserLikedCell, user: User) {
        
        cell.nameLabel.text = user.name
        cell.cityLabel.text = user.location
        cell.descriptionLabel.text = user.userDescription
        
        if let date = user.likeDate {
            let df = DateFormatter()
            df.dateFormat = "d MMM"
            let dateString = df.string(from: date)
            cell.likedDateLabel.text = "Liked activity on " + dateString
        }
        
        guard let photo = user.photo else { return }
        guard let imageURL = URL(string: photo) else { return }
        cell.profileImageView.sd_setImage(with: imageURL)
    }
}
