//
//  BasicVC.swift
//  RWJ
//
//  Created by Michal Solowow on 8/15/16.
//  Copyright © 2016 Sebastian Obrincu. All rights reserved.
//

import UIKit
import JGProgressHUD
import AVFoundation

public protocol KeyboardMoveNotification : NSObjectProtocol {
    func keyboardMoved(_ gap: AnyObject?)
}

class BasicVC: UIViewController {
    
    var keyboardDelegate : KeyboardMoveNotification? = nil
    var progressHud : JGProgressHUD? = nil
    var audioPlayer:AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
//MARK: PlaySound
    
    func playSound(_ soundName : String){
        if let myAudioUrl = Bundle.main.url(forResource: soundName, withExtension: "wav") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: myAudioUrl)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
//MARK: ProgressHUD
    
    func showHUD(_ text: String, hStyle : JGProgressHUDStyle? = nil)
    {
        progressHud = JGProgressHUD(style: hStyle != nil ? hStyle! : .dark)
        progressHud!.textLabel.text = text
        progressHud!.show(in: self.view)
    }
    
    func hideHud() {
        progressHud?.dismiss(animated: true)
    }
    
//MARK: Show Alert
    func showAlert(_ title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func onPushBack(_ sender: AnyObject) {

        self.playSound(Sound_BtnClick)
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onModalBack(_ sender: AnyObject) {
        
        self.playSound(Sound_BtnClick)
        self.dismiss(animated: true, completion: nil)
    }

    
    func getDelegate() -> AppDelegate {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        return delegate
    }
    
    
//MARK: keyboard Notification
    func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(BasicVC.keyboardShown(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BasicVC.keyboardHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unRegisterKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    var keyboardDuration : Double = 0.2
    func keyboardShown(_ notification: Notification) {
        if let info = (notification as NSNotification).userInfo {
            let size = (info[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size
            if let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
                if(duration > 0) {
                    keyboardDuration = duration
                }
            }
            
            self.moveKeyboardDown(CGFloat(size.height) as AnyObject?)
        }
    }
    
    func keyboardHidden(_ notification: Notification) {
        
        self.moveKeyboardDown(CGFloat(0) as AnyObject?)
    }
    
    func moveKeyboardDown(_ gap: AnyObject?)
    {
        if let _ = gap as? CGFloat {
            
            if self.keyboardDelegate != nil
            {
                self.keyboardDelegate?.keyboardMoved(gap)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



