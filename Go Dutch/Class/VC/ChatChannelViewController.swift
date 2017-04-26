//
//  ChatChannelViewController.swift
//  Go Dutch
//
//  Created by Denis Litvinskiy on 09.02.17.
//  Copyright © 2017 Sergey Bill. All rights reserved.
//

import UIKit

class ChatChannelViewController : BasicVC
{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let groupChannelListViewController = GroupChannelListViewController(nibName: "GroupChannelListViewController", bundle: Bundle.main)

        groupChannelListViewController.addDelegates()
        groupChannelListViewController.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height)

        self.view.addSubview(groupChannelListViewController.view)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
