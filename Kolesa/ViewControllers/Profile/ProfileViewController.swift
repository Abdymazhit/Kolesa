//
//  ProfileViewController.swift
//  Kolesa
//
//  Created by Islam Abdymazhit on 08/05/2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.hidesBackButton = true
        tabBarController?.title = "Профиль"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
