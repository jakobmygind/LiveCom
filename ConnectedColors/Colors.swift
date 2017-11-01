//
//  Colors.swift
//  LiveCom
//
//  Created by Jakob Mygind Jensen on 18/10/2017.
//  Copyright © 2017 Example. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static var lcRed: UIColor {
        
        return UIColor(red: 0xC0/255.0, green: 0x23/255.0, blue: 0x21/255, alpha: 1.0)
    }
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }}
