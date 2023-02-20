//
//  Database.swift
//  PaddleMyWay
//
//  Created by Patmavathi on 18/09/2022.
//

import Foundation
import FirebaseCore
import FirebaseDatabase

class FirebaseTables: NSObject {
    
    static var Destinations: DatabaseReference {
        return Database.database().reference().child("Destinations")
    }
    
    static var Seasons: DatabaseReference {
        return Database.database().reference().child("Seasons")
    }
    
    static var Peoples: DatabaseReference {
        return Database.database().reference().child("Peoples")
    }
    
    static var Chats: DatabaseReference {
        return Database.database().reference().child("Chats")
    }
    
    static var Locations: DatabaseReference {
        return Database.database().reference().child("Locations")
    }
    
    static var Events: DatabaseReference {
        return Database.database().reference().child("Events")
    }
    
    static var Reviews: DatabaseReference {
        return Database.database().reference().child("Reviews")
    }
}
