//
//  Persona.swift
//  carpoolApp
//
//  Created by Corde Lopez on 8/25/18.
//  Copyright © 2018 Corde Lopez. All rights reserved.
//

import Foundation
import Firebase

struct Persona {
    let key: String!
    let nombre : String!
    let celular: String!
    let numHijos: Int!
    let numPas: Int!
    let entrada: String!
    let salida: String!
    
    let itemRef : DatabaseReference
    
    init(snapshot: DataSnapshot){
        key = snapshot.key
        itemRef = snapshot.ref
        
        let snapshotValue = snapshot.value as! NSDictionary
        
        if let nom = snapshotValue["name"] as? String{
            nombre = nom
        }
        else{
            nombre = ""
        }
        
        if let cel = snapshotValue["celular"] as? String{
            celular = cel
        }
        else{
            celular = ""
        }
        
        if let numH = snapshotValue["numChildren"] as? String{
            numHijos = Int(numH)
        }
        else{
            numHijos = 0
        }
        
        if let numP = snapshotValue["numPassengers"] as? String{
            numPas = Int(numP)
        }
        else{
            numPas = 0
        }
        
        if let entr = snapshotValue["entryHour"] as? String{
            entrada = entr
        }
        else{
            entrada = ""
        }
        
        if let sal = snapshotValue["outHour"] as? String{
            salida = sal
        }
        else{
            salida = ""
        }
        
        
    }
    
}
