//
//  Database.swift
//  PaddleMyWay
//
//  Created by Patmavathi on 18/09/2022.
//

import Foundation
import FirebaseCore
import FirebaseDatabase

var navController = UINavigationController()

class FirebaseTables: NSObject {

    static var Destinations: DatabaseReference {
        return Database.database().reference().child("Destinations")
    }
    
    static var Chat: DatabaseReference {
        return Database.database().reference().child("Chat")
    }
}
