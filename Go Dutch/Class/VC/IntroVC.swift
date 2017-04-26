//
//  IntroVC.swift
//  Go Dutch
//
//  Created by Michal Solowow on 9/2/16.
//  Copyright © 2016 Sergey Bill. All rights reserved.
//

import UIKit

class IntroVC: BasicVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var btn_continue: UIButton!
    
    @IBOutlet weak var bottom_continueBtn: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.welcomeLabel.text = "Welcome to\nGo Dutch Today"
        self.descriptionLabel.text = "Using the app is a breeze.\nJust follow the steps bellow."
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.bottom_continueBtn.constant = 26.0
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut , animations: {
            self.view.layoutIfNeeded()
            
            self.btn_continue.alpha = 1
            }, completion: { (result) in
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - IBAction

    @IBAction func onContinue(_ sender: AnyObject) {
        
        self.playSound(Sound_BtnClick)
        self.performSegue(withIdentifier: "goJoin", sender: nil)
    }
    
    //MARK: - UITableViewDelegate/DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "IntroCell" + "\(indexPath.row)"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! IntroCell
        
        switch indexPath.row {
        case 0:
            
            let attachment = NSTextAttachment()
            attachment.image = #imageLiteral(resourceName: "heart_attachment")
            let attachmentString = NSAttributedString(attachment: attachment)
            let firstPart = NSAttributedString(string: "Tap the  ")
            let secondPart = NSAttributedString(string: "  for an activity to like it")
            let attributedString = NSMutableAttributedString(attributedString: firstPart)
            attributedString.append(attachmentString)
            attributedString.append(secondPart)
            cell.introLabel.attributedText = attributedString
            break
        case 1:
            cell.introLabel.text = "Browse Dutches who liked same activity"
            break
        case 2:
            cell.introLabel.text = "Send a date proposal"
            break
        case 3:
            cell.introLabel.text = "Proposal accepted, split cost and meet up!"
            break
        default:
            break
        }
        
        return cell
    }
    
    
}
