//
//  ViewController.swift
//  Go Dutch
//
//  Created by Michal Solowow on 9/1/16.
//  Copyright © 2016 Sergey Bill. All rights reserved.
//

import UIKit

class WelcomeVC: BasicVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        self.playSound(Sound_BtnClick)
    }
}

