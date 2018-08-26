//
//  DataViewController.swift
//  carpoolApp
//
//  Created by Corde Lopez on 8/25/18.
//  Copyright © 2018 Corde Lopez. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class DataViewController: UIViewController, CLLocationManagerDelegate {
    
    // view text fields
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nomTF: UITextField!
    @IBOutlet weak var dirTF: UITextField!
    @IBOutlet weak var numHijosTF: UITextField!
    @IBOutlet weak var numPasTF: UITextField!
    @IBOutlet weak var entradaPIC: UIDatePicker!
    @IBOutlet weak var salidaPIC: UIDatePicker!
    
    // persona data
    var nombre : String!
    var direccion: String!
    var numHijos: String!
    var numPas: String!
    var entrada: String!
    var salida: String!
    var dbReference: DatabaseReference!
    
    // informacion que se va a pasar a MapVC
    var newKey: String!
    var newNombre: String!

    var locationManager = CLLocationManager()
    
    // esconde el teclado
  func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scrollView.keyboardDismissMode = .onDrag
        // pide acceso a la ubicacion del usuario
        locationManager.requestWhenInUseAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func uploadData(_ sender: Any) {
        if (checkTF()){
            print("text fields ok")
            updateDatabase()
        }
        else{
            print("missing info in text fields")
        }
        
    }
    
    
    func updateDatabase (){
        dbReference = Database.database().reference().child("usuarios")
        
        if let user = Auth.auth().currentUser{
            let key = user.uid
            let persona = ["name": nombre, "address": direccion, "numChildren": numHijos, "numPassengers": numPas, "entryHour": entrada, "outHour":salida, "coordinates": "false"]
            
            newKey = key
            newNombre = nombre
            
            let childUpdates = ["/\(key)": persona]
            dbReference.updateChildValues(childUpdates)
            
            print("upload to database complete")
        }
        
        
    }
   

    
    func checkTF()->Bool{
        if(nomTF.text! != "" && dirTF.text! != "" && numHijosTF.text! != "" && numPasTF.text! != ""){
            nombre = nomTF.text!
            direccion = dirTF.text!
            numHijos = numHijosTF.text!
            numPas = numPasTF.text!
            let date = entradaPIC.date
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "hh:mma"
            let stringDate = dateformatter.string(from: date)
            entrada = stringDate
            print(stringDate)
            let dateS = salidaPIC.date
            let dateformatterS = DateFormatter()
            dateformatterS.dateFormat = "hh:mma"
            let stringDateS = dateformatter.string(from: dateS)
            entrada = stringDateS
            print(stringDateS)
            salida = stringDateS
            
            return true
        }
        
        
        return false
    }
    

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toMapVC") {
            let mapVC = segue.destination as! MapViewController
            mapVC.newNombre = newNombre
            mapVC.newKey = newKey
        }
    }
 

}
