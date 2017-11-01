//
//  ReceivedMessage.swift
//  LiveCom
//
//  Created by Jakob Mygind Jensen on 18/10/2017.
//  Copyright © 2017 Example. All rights reserved.
//

import Foundation


struct ReceivedMessage {
    let text: String
    let date: Date
    
    init(text: String, date: Date = Date()) {
        self.text = text
        self.date = date
    }
}
