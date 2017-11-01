//
//  ReceiverVC.swift
//  ConnectedColors
//
//  Created by Jakob Mygind Jensen on 03/10/2017.
//  Copyright © 2017 Example. All rights reserved.
//

import UIKit

class ReceiverVC: UIViewController {
    
    var messages = [ReceivedMessage]()
    
    var colorService: ColorServiceManager!
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            tableView.separatorColor = UIColor.lcRed
        }
    }
    
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        start()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    func start() {
        colorService = ColorServiceManager()
        colorService.delegate = self
        colorService.start(withName: "Server")
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
            self.tableView.reloadData()
        })
    }
    
    @objc func didBecomeActive() {
        start()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension ReceiverVC : ColorServiceManagerDelegate {
    
    func connectedDevicesChanged(manager: ColorServiceManager, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            self.title = "Connections: \(connectedDevices)"
        }
    }
    
    func colorChanged(manager: ColorServiceManager, colorString: String) {
        OperationQueue.main.addOperation {
           self.messages.append(ReceivedMessage(text: colorString))
            self.tableView.reloadData()
        }
    }
    
}

extension ReceiverVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let msg = messages.reversed()[indexPath.row]
        cell.backgroundColor = UIColor.black
        cell.textLabel?.textColor = UIColor.lcRed
        cell.textLabel?.font = UIFont.lcBold(withSize: 20)
        cell.textLabel?.numberOfLines = 2
        
        cell.textLabel?.text =  msg.text + " " + msg.date.timeAgoSinceNow
        return cell
    }
}
