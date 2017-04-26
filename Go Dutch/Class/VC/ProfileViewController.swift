//
//  ProfileViewController.swift
//  Go Dutch
//
//  Created by Denis Litvinskiy on 04.12.16.
//  Copyright © 2016 Sergey Bill. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: BasicVC {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileDescriptionLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var profileLocationLabel: UILabel!
    
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if self.user == nil {
            self.user = Session.sharedInstance.currentUser
            let font = UIFont(name: "Dosis-Medium", size: 20.0)!
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.white]
            self.navigationItem.title = "My Profile"
        } else {
            self.navigationController?.navigationBar.tintColor = .white
        }
        
        self.layout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let chatChannelVC = segue.destination as? ChatChannelViewController else { return }
//        guard let channel = sender as? ChatChannel else { return }
//        chatChannelVC.channel = channel
    }
    
    //MARK: - IBActions
    
    @IBAction func onSendMessageButton(_ sender: Any) {
        guard let user = self.user else { return }
        Chat.sharedInstance.createChannel(with: user) { (created, channel) in
            guard channel != nil else { return }
            
            DispatchQueue.main.async {
                let vc = GroupChannelChattingViewController(nibName: "GroupChannelChattingViewController", bundle: Bundle.main)
                vc.groupChannel = channel?.channelObj
                vc.userName = channel?.name
                self.present(vc, animated: true, completion: nil)
            }

        }
    }
    
    //MARK: - Private
    
    private func layout() {
        
        self.profileDescriptionLabel.text = self.user!.userDescription
        self.profileNameLabel.text = self.user!.name
        self.profileLocationLabel.text = self.user!.location
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
        
        guard let photoURLString = self.user?.photo else { return }
        guard let photoURL = URL(string: photoURLString) else { return }
        self.backgroundImageView.sd_setImage(with: photoURL)
        self.profileImageView.sd_setImage(with: photoURL)
    }

}
