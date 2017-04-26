//
//  ChatViewController.swift
//  Go Dutch
//
//  Created by Denis Litvinskiy on 08.02.17.
//  Copyright © 2017 Sergey Bill. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Chat.sharedInstance.requestChannels { (completed) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? ChatChannelViewController else { return }
        guard let channel = sender as? ChatChannel else { return }
        controller.channel = channel
    }
    
    //MARK: - UITableViewDelegate/DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Chat.sharedInstance.channelsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell")!
        let channel = Chat.sharedInstance.channel(at: indexPath.row)
        cell.textLabel?.text = channel.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = Chat.sharedInstance.channel(at: indexPath.row)
        self.performSegue(withIdentifier: "Chat_Channel_Segue", sender: channel)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        Chat.sharedInstance.leaveChannel(at: indexPath.row)
        self.tableView.reloadData()
    }
}
