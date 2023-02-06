//
//  ChatModel.swift
//  PaddleMyWay
//
//  Created by Patmavathi on 04/02/2023.
//

import Foundation

struct ChatModel {
    
    var date: String?
    var chats: [Chat]?
    
    init() {}
}

struct Chat{
    
    var id: String?
    var message: String?
    var date: String?
    var sender: Int?
    var type: Int?
}
