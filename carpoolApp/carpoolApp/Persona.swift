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
    let direccion: String!
    let numHijos: Int!
    let numPas: Int!
    let entrada: String!
    let salida: String!
    let coordenadas: String!
    
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
        
        if let dir = snapshotValue["address"] as? String{
            direccion = dir
        }
        else{
            direccion = ""
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
        
        if let coor = snapshotValue["coordinates"] as? String{
            coordenadas = coor
        }
        else{
            coordenadas = ""
        }
        
    }
    
}
