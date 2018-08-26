//
//  File.swift
//  carpoolApp
//
//  Created by Fernando Carrillo on 8/25/18.
//  Copyright © 2018 Corde Lopez. All rights reserved.
//

import Foundation
import Firebase

struct LocationObj {
    let key: String!
    let lat: Double!
    let lon: Double!
    let description: String!
    let name: String!
    
    let itemRef: DatabaseReference
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        itemRef = snapshot.ref
        
        let snapshotValue = snapshot.value as! NSDictionary
        
        // assigns latitude
        if let latitude = snapshotValue["latitude"] as? String {
            lat = Double(latitude)
        } else {
            lat = 0.0
        }
        
        // assigns longitud
        if let longitud = snapshotValue["longitud"] as? String {
            lon = Double(longitud)
        } else {
            lon = 0.0
        }
        
        // assigns description
        if let desc = snapshotValue["description"] as? String {
            description = desc
        } else {
            description = "NA"
        }
        
        // assigns name
        if let newName = snapshotValue["name"] as? String {
            name = newName
        } else {
            name = "NA"
        }
    }
    
}
