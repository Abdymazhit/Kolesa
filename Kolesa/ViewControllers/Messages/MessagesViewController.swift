//
//  MessagesViewController.swift
//  Kolesa
//
//  Created by Islam Abdymazhit on 09/05/2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

class MessagesViewController: UITableViewController {
    
    private var messages: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.hidesBackButton = true
        tabBarController?.title = "Сообщения"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messages.count == 0 {
            tableView.backgroundView = NoMessagesView()
        }
        
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = messages[indexPath.row]
        return cell
    }
}
