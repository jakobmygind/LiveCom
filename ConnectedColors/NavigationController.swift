//
//  NavigationController.swift
//  LiveCom
//
//  Created by Jakob Mygind Jensen on 18/10/2017.
//  Copyright © 2017 Example. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.barTintColor = UIColor.lcRed
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        if #available(iOS 11.0, *) {
            navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        } else {
            // Fallback on earlier versions
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
